# Dataset: MB
# Description: A synthetic SDTM MB domain representing microbiology findings
# and linkage to MS domain (ms).

# Load libraries -----
library(dplyr)
ms <- pharmaversesdtm::ms

## Identify unique organism/specimen/subject combinations ----
## RELTYPE: Many-to-one
mb_base <- filter(ms, !duplicated(MSGRPID))

## Assign MBREFID per subject/specimen/visit ----
mb_base <- mb_base %>%
  group_by(USUBJID, VISITNUM, MSSPEC) %>%
  mutate(MBREFID = paste0("SPEC", sprintf("%02d", cur_group_id()))) %>%
  ungroup()

## Identify organisms (this is not a CDISC derivation, just for synthetic data purposes) ----
## (Note: Please, before changing this logic, check ms.R to ensure consistency & viceversa)
mb_base <- mb_base %>%
  mutate(
    organism = gsub(MSGRPID, pattern = ".*-.*-(.*)", replacement = "\\1"),
    MBORRES = ifelse(
      MSTRESC == "RESISTANT", 
      paste0(organism, " ", "RESISTANT"),
      organism
    )
  )

## Assign MBSPID per organism identified----
mb_base <- mb_base %>%
  group_by(USUBJID, organism) %>%
  mutate(MBSPID = paste0("ORG", sprintf("%02d", cur_group_id()))) %>%
  ungroup()

## Assign MBSEQ for each record within each subject ----
mb_base <- mb_base %>%
  group_by(USUBJID) %>%
  mutate(MBSEQ = row_number()) %>%
  ungroup()

## Assign MBGRPID (same as MSGRPID for linking) ----
## Required to be specific for specimen and organism (check ms.R)
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
    MBRESCAT = case_when(
      # This is an arbitrary assignment done here:
      USUBJID == unique(USUBJID)[c(1, 2)] ~ "COLONIZING", # Patient 1 and 2 has no infection symptoms
      TRUE ~ "INFECTING"                                  # The rest of the patients have
    )
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

## Add variable labels ----
mb <- mb %>%
  labelled::set_variable_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    MBSEQ = "Sequence Number",
    MBSPID = "Sponsor-Defined Identifier",
    MBGRPID = "Group ID",
    MBREFID = "Reference ID",
    MBTESTCD = "Microbiology Test or Finding Short Name",
    MBTEST = "Microbiology Test or Finding Name",
    MBORRES = "Original Result",
    MBRESCAT = "Result Category",
    MBLOC = "Specimen Collection Location",
    MBSPEC = "Specimen Type",
    VISIT = "Visit Name",
    VISITNUM = "Visit Number",
    MBDTC = "Date/Time of Specimen Collection"
  )

## Save MB domain ----
usethis::use_data(mb, overwrite = TRUE)
