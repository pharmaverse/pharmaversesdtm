# Dataset: vs_vaccine
# Description: VS test SDTM dataset for Vaccine studies


# Load libraries ----

library(tibble)
library(dplyr)
library(tidyr)
library(purrr)
library(metatools)

## Read input data ----
vs <- pharmaversesdtm::vs

# dummy data frame for 14 observation period for a subject.
vs_dummy <- as_tibble(matrix(nrow = 14))

# duplicating the 14 observation period data frame for two subjects
vx_vs <- vs_dummy %>%
  mutate(
    VSSEQ = 1:14,
    USUBJID = "ABC-1001"
  ) %>%
  bind_rows(mutate(
    vs_dummy,
    VSSEQ = 1:14,
    USUBJID = "ABC-1002"
  )) %>%
  mutate(
    STUDYID = "ABC",
    DOMAIN = "VS",
    VSTESTCD = "TEMP",
    VSCAT = "REACTOGENICITY",
    VSSCAT = "SYSTEMIC",
    VSTEST = "Temperature",
    VSTPTREF = ifelse(VSSEQ %in% c(1:7), "VACCINATION 1", "VACCINATION 2"),
    VSLNKGRP = paste(VSTPTREF, "FEVER", sep = "-"),
    EPOCH = VSTPTREF
  ) %>%
  group_by(USUBJID, VSTPTREF) %>%
  mutate(
    VSTPTNUM = row_number(),
    VSTPT = paste("DAY", VSTPTNUM),
    VSLNKID = paste(VSLNKGRP, VSTPT, sep = "-")
  )

# writing tibble for the measurement records
vx_vs1 <- tribble(
  ~VSORRES, ~VSORRESU, ~VSSTRESC, ~VSSTRESN, ~VSSTRESU, ~VSLOC, ~VSDTC, ~VSDY,
  "97.9", "F", "36.61", 36.61, "C", NA, "2021-11-03T18:00:23", 1,
  "99.1", "F", "37.28", 37.28, "C", NA, "2021-11-04T18:01:09", 2,
  "97.3", "F", "36.28", 36.28, "C", NA, "2021-11-05T19:04:07", 3,
  "98.3", "F", "36.83", 36.83, "C", NA, "2021-11-06T18:00:33", 4,
  "97.8", "F", "36.56", 36.56, "C", NA, "2021-11-07T18:01:25", 5,
  "99.1", "F", "37.28", 37.28, "C", NA, "2021-11-08T18:00:26", 6,
  "98.1", "F", "36.72", 36.72, "C", NA, "2021-11-09T18:08:04", 7,
  NA, NA, NA, NA, NA, NA, "2021-12-30", 58,
  NA, NA, NA, NA, NA, NA, "2021-12-31", 59,
  NA, NA, NA, NA, NA, NA, "2022-01-01", 60,
  NA, NA, NA, NA, NA, NA, "2022-01-02", 61,
  NA, NA, NA, NA, NA, NA, "2022-01-03", 62,
  NA, NA, NA, NA, NA, NA, "2022-01-04", 63,
  NA, NA, NA, NA, NA, NA, "2022-01-05", 64,
  "97.0", "F", "36.11", 36.11, "C", NA, "2021-10-07T19:14:10", 1,
  "98.1", "F", "36.72", 36.72, "C", NA, "2021-10-08T18:13:47", 2,
  "97.2", "F", "36.22", 36.22, "C", NA, "2021-10-09T18:02:12", 3,
  "97.1", "F", "36.17", 36.17, "C", NA, "2021-10-10T18:03:17", 4,
  "98.2", "F", "36.78", 36.78, "C", NA, "2021-10-11T18:11:54", 5,
  NA, NA, NA, NA, NA, NA, "2021-10-12", 6,
  "98.0", "F", "36.67", 36.67, "C", NA, "2021-10-13T19:27:24", 7,
  "97.4", "F", "36.33", 36.33, "C", NA, "2021-12-16T18:01:47", 71,
  "98.1", "F", "36.72", 36.72, "C", NA, "2021-12-17T18:22:25", 72,
  "98.5", "F", "36.94", 36.94, "C", NA, "2021-12-18T18:34:53", 73,
  "96.7", "F", "35.94", 35.94, "C", NA, "2021-12-19T18:40:14", 74,
  "98.7", "F", "37.06", 37.06, "C", NA, "2021-12-20T18:33:47", 75,
  "98.1", "F", "36.72", 36.72, "C", NA, "2021-12-21T18:20:15", 76,
  "97.8", "F", "36.56", 36.56, "C", NA, "2021-12-22T18:23:21", 77
)

vx_vs <- bind_cols(vx_vs, vx_vs1) %>%
  mutate(VSEVAL = ifelse(!is.na(VSSTRESC), "STUDY SUBJECT", NA_character_))

# ordering the variables
vx_vs <- vx_vs %>%
  select(
    STUDYID, DOMAIN, USUBJID, VSSEQ, VSLNKID, VSLNKGRP, VSTESTCD, VSTEST, VSCAT,
    VSSCAT, VSORRES, VSORRESU, VSSTRESC, VSSTRESN, VSSTRESU, VSEVAL, VSLOC,
    EPOCH, VSDTC, VSDY, VSTPT, VSTPTNUM, VSTPTREF
  )

# get common column names
common_cols <- intersect(names(vx_vs), names(vs))

# assign labels to vx_vs
walk(common_cols, \(x) attr(vx_vs[[x]], "label") <<- attr(vs[[x]], "label"))

vs_vaccine <- vx_vs %>%
  add_labels(
    VSLNKID = "Link ID",
    VSLNKGRP = "Link Group ID",
    VSCAT = "Category for Vital Signs",
    VSSCAT = "Subcategory for Vital Signs",
    VSEVAL = "Evaluator",
    EPOCH = "Epoch"
  )

# Label VS dataset ----
attr(vs_vaccine, "label") <- "Vital Signs"

# Save dataset ----
usethis::use_data(vs_vaccine, overwrite = TRUE)
