# Dataset: ex_vaccine
# Description: EX SDTM dataset for Vaccine studies

# Load libraries ----
library(tibble)
library(dplyr)
library(purrr)
library(metatools)

# create ex
## Read input data ----
ex <- pharmaversesdtm::ex

vx_ex <- tribble(
  ~USUBJID, ~EXSEQ, ~EXDTC, ~EXSTDTC, ~EXENDTC, ~EXDY, ~VISITNUM,
  "ABC-1001", 1, "2021-11-03T10:50:00", "2021-11-03T10:50:00", "2021-11-03T10:50:00", 1, 1,
  "ABC-1001", 2, "2021-12-30T09:10:00", "2021-12-30T09:10:00", "2021-12-30T09:10:00", 58, 2,
  "ABC-1002", 1, "2021-10-07T12:48:00", "2021-10-07T12:48:00", "2021-10-07T12:48:00", 1, 1,
  "ABC-1002", 2, "2021-12-16T12:41:00", "2021-12-16T12:41:00", "2021-12-16T12:41:00", 71, 2
) %>%
  mutate(
    STUDYID = "ABC",
    DOMAIN = "EX",
    EXCAT = "INVESTIGATIONAL PRODUCT",
    EXDOSU = "SYRINGE",
    EXDOSE = 1,
    EXDOSFRM = "INJECTION",
    EXROUTE = "INTRAMUSCULAR",
    VISIT = case_when(
      VISITNUM == 1 ~ "VISIT 1",
      VISITNUM == 2 ~ "VISIT 2",
      TRUE ~ NA_character_
    ),
    EPOCH = ifelse(EXSEQ == 1, "VACCINATION 1", "VACCINATION 2"),
    EXLNKGRP = EPOCH,
    EXTRT = ifelse(EXSEQ == 1, "VACCINE A", "VACCINE B"),
    EXLOC = "DELTOID MUSCLE",
    EXLAT = "LEFT",
    EXLNKID = paste(EXLNKGRP, EXLOC, EXLAT, sep = "-")
  ) %>%
  select(
    STUDYID, DOMAIN, USUBJID, EXSEQ, EXLNKGRP, EXLNKID, EXTRT, EXCAT,
    EXDOSE, EXDOSU, EXDOSFRM, EXROUTE, EXLOC, EXLAT, VISITNUM, VISIT, EPOCH,
    EXDTC, EXSTDTC, EXENDTC, EXDY
  )

# get common column names
common_cols <- intersect(names(vx_ex), names(ex))

# assign labels to vx_ex
walk(common_cols, \(x) attr(vx_ex[[x]], "label") <<- attr(ex[[x]], "label"))

ex_vaccine <- vx_ex %>%
  add_labels(
    EXDTC = "Date/Time of Collection",
    EXDY = "Study Day of Collection",
    EXLNKID = "Link ID",
    EXLNKGRP = "Link Group ID",
    EXLOC = "Location of Dose Administration",
    EXLAT = "Laterality",
    EPOCH = "Epoch",
    EXCAT = "Category of Treatment"
  )

# Label ex dataset ----
attr(ex_vaccine, "label") <- "Exposure"

# Save dataset ----
usethis::use_data(ex_vaccine, overwrite = TRUE)
