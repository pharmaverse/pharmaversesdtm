# Dataset: tu
# Description: TU test SDTM dataset for Oncology studies

# Please note that tr_onco.R should run first

# Load libraries ----
library(dplyr)
library(tidyselect)
library(admiral)
library(metatools)


# Create tu ----
## Read input data  --  DUMMY DATA CREATED FROM TR data created from TR ----
tr_onco <- pharmaversesdtm::tr_onco
supptr_onco <- pharmaversesdtm::supptr_onco

tr <- convert_blanks_to_na(tr_onco)
supptr <- convert_blanks_to_na(supptr_onco)

supptr1 <- supptr %>%
  mutate("DOMAIN" = RDOMAIN, TRSEQ = as.numeric(IDVARVAL), "TRLOC" = QVAL) %>%
  select(., c(STUDYID, USUBJID, TRSEQ, TRLOC))

tr <- full_join(tr, supptr1, by = c("STUDYID", "USUBJID", "TRSEQ"))

## Rename And Add TU Variables ----
tu1 <- tr %>%
  filter((VISITNUM == 3 | (TRGRPID == "NEW" &
    !is.na(TRORRES) & TRORRES != "NO"))) %>%
  filter(TRTESTCD %in% c("TUMSTATE", "DIAMETER")) %>%
  rename(
    TULNKID = TRLNKID,
    TUMETHOD = TRMETHOD,
    TUSEQ = TRSEQ,
    TUEVAL = TREVAL,
    TUEVALID = TREVALID,
    TUDTC = TRDTC,
    TUDY = TRDY,
    TULOC = TRLOC,
    TUACPTFL = TRACPTFL
  ) %>%
  mutate(
    DOMAIN = "TU",
    TUTESTCD = "TUMIDENT",
    TUTEST = "Tumor Identification",
    TUORRES = TRGRPID,
    TUSTRESC = TUORRES
  )

## TUSEQ ----
tu2 <- tu1 %>%
  arrange(STUDYID, USUBJID, VISITNUM, TUDTC, TULNKID) %>%
  group_by(STUDYID, USUBJID) %>%
  mutate(TUSEQ = row_number()) %>%
  ungroup()

## Create TU ----
tu <- select(tu2, c(
  STUDYID, DOMAIN, USUBJID, TUSEQ, TULNKID,
  TUTESTCD, TUTEST, TUORRES, TUSTRESC, TULOC,
  TUMETHOD, TUEVAL, TUEVALID, TUACPTFL,
  VISITNUM, VISIT, TUDTC, TUDY
))

tu_onco <- tu %>% add_labels(
  STUDYID = "Study Identifier",
  DOMAIN = "Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  TUSEQ = "Sequence Number",
  TULNKID = "Link ID",
  TUTESTCD = "Tumor Identification Short Name",
  TUTEST = "Tumor Identification Test Name",
  TUORRES = "Tumor Identification Result",
  TUSTRESC = "Tumor Identification Result Std. Format",
  TULOC = "Location of the Tumor",
  TUMETHOD = "Method of Identification",
  TUEVAL = "Evaluator",
  TUEVALID = "Evaluator Identifier",
  TUACPTFL = "Accepted Record Flag",
  VISITNUM = "Visit Number",
  VISIT = "Visit Name",
  TUDTC = "Date/Time of Tumor Identification",
  TUDY = "Study Day of Tumor Identification"
)

# Label dataset ----
attr(tu_onco, "label") <- "Tumor/Lesion Identification"

# Save dataset ----
usethis::use_data(tu_onco, overwrite = TRUE)
