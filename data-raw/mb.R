# Dataset: MB
# Description: A synthetic SDTM MB domain representing microbiology findings
# and linkage to MS domain (ms).

# Load libraries -----
library(dplyr)
ms <- pharmaversesdtm::ms

## Identify unique organism/specimen/subject combinations ----
mb_base <- ms %>%
  distinct(STUDYID, USUBJID, NHOID, MSGRPID, MSREFID, VISITNUM, MSSPEC) %>%
  arrange(USUBJID, VISITNUM, NHOID)

## Assign MBSPID per subject/organism ----
mb_base <- mb_base %>%
  group_by(USUBJID, NHOID) %>%
  mutate(MBSPID = paste0("ORG", sprintf("%02d", cur_group_id()))) %>%
  ungroup()

## Assign MBSEQ per subject ----
mb_base <- mb_base %>%
  group_by(USUBJID) %>%
  mutate(MBSEQ = row_number()) %>%
  ungroup()

## Assign MBGRPID (same as MSGRPID for linking) ----
mb_base <- mb_base %>%
  mutate(MBGRPID = MSGRPID)

## Assign MBTESTCD, MBTEST, MBORRES, MBRESCAT, MBSPEC, MBDTC ----
mb_base <- mb_base %>%
  mutate(
    DOMAIN = "MB",
    MBTESTCD = "ORGANISM",
    MBTEST = "Organism Present",
    MBMETHOD = "CULTURE PLATE",
    MBORRES = NHOID,
    MBSPEC = MSSPEC,
    MBLOC = ifelse(MBSPEC == "URINE", "URINARY SYSTEM", "SKIN OF THE AXILLA"),
    MBRESCAT = ifelse(MBSPEC == "URINE", "COLONIZER", "INFECTING"),
    VISIT = paste0("Visit ", VISITNUM),
    MBDTC = paste0("2005-06-", sprintf("%02d", 15 + VISITNUM), "T08:00")
  )

## Select and order columns per SDTM ----
mb <- mb_base %>%
  select(
    STUDYID, DOMAIN, USUBJID, MBSEQ, MBSPID, MBGRPID, MBREFID = MSREFID, 
    MBTESTCD, MBTEST, MBORRES, MBRESCAT, MBLOC, MBSPEC,
    VISIT, VISITNUM, MBDTC
  )

## Save MB domain ----
usethis::use_data(mb, overwrite = TRUE)
