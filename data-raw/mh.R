# Dataset: mh
# Description: Standard MH dataset from CDISC pilot study with variables MENDTC, MHPRESP, MHOCCUR etc

# Load libraries -----
library(metatools)
library(lubridate)
library(haven)
library(admiral)
library(dplyr)

# CReate mh ----
sdtm_path <- "https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/" # nolint
raw_mh <- read_xpt(paste0(sdtm_path, "mh", ".xpt?raw=true"))

## Get dm ----
dm <- pharmaversesdtm::dm

## Convert blank to NA ----
dm <- convert_blanks_to_na(dm) %>%
  select(STUDYID, USUBJID, RFSTDTC, RFENDTC, RFXSTDTC, RFXENDTC)
mh_orig <- convert_blanks_to_na(raw_mh)

## Set seed so that result stays the same for each run ----
set.seed(1)
ran_int <- sample.int(400, nrow(raw_mh), replace = TRUE)

## Add new variables ----
mh1 <- mh_orig %>%
  # Add MHENDTC
  mutate(MHENDTC = as.character(as.Date(MHSTDTC) + days(ran_int))) %>%
  # Add MHPRESP
  mutate(MHPRESP = ifelse(MHTERM == "ALZHEIMER'S DISEASE", "Y", NA_character_)) %>%
  # Add MHOCCUR
  mutate(MHOCCUR = case_when(
    MHPRESP == "Y" & !is.na(MHSTDTC) ~ "Y",
    MHPRESP == "Y" & is.na(MHSTDTC) ~ "N",
    MHPRESP == "N" ~ NA_character_
  )) %>%
  left_join(dm, by = c("STUDYID", "USUBJID")) %>%
  # Add MHSTRTPT
  mutate(MHSTRTPT = if_else(MHTERM == "ALZHEIMER'S DISEASE", NA_character_,
    "BEFORE"
  )) %>%
  # Add MHENRTPT
  mutate(MHENRTPT = if_else(as.Date(MHENDTC) < as.Date(RFXSTDTC),
    "BEFORE", "ONGOING"
  )) %>%
  # Add MHSTTPT
  mutate(MHSTTPT = if_else(MHTERM == "ALZHEIMER'S DISEASE", NA_character_,
    "SCREENING"
  )) %>%
  # Add MHENTPT
  mutate(MHENTPT = if_else(MHTERM == "ALZHEIMER'S DISEASE", "SCREENING",
    "FIRST DOSE OF STUDY DRUG"
  )) %>%
  # Add MHENRF
  mutate(MHENRF = case_when(
    as.Date(MHENDTC) < as.Date(RFSTDTC) ~ "BEFORE",
    as.Date(MHENDTC) > as.Date(RFENDTC) ~ "AFTER",
    is.na(MHENDTC) ~ NA_character_,
    TRUE ~ "DURING"
  )) %>%
  # Add MHSTAT
  mutate(MHSTAT = ifelse(MHPRESP == "Y" & is.na(MHOCCUR), "NOT DONE",
    NA_character_
  )) %>%
  # Remove variables from DM
  select(-c("RFSTDTC", "RFENDTC", "RFXSTDTC", "RFXENDTC")) %>%
  # Variable labels
  add_labels(
    MHENDTC = "End Date/Time of Medical History Event",
    MHPRESP = "Medical History Event Pre-Specified",
    MHOCCUR = "Medical History Occurrence",
    MHSTTPT = "Start Reference Time Point",
    MHENTPT = "End Reference Time Point",
    MHSTRTPT = "Start Relative to Reference Time Point",
    MHENRTPT = "End Relative to Reference Time Point",
    MHENRF = "End Relative to Reference Period",
    MHSTAT = "Completion Status"
  )

# Label dataset ----
attr(mh1, "label") <- "Medical History"
mh <- mh1

# Save dataset ----
usethis::use_data(mh, overwrite = TRUE)
