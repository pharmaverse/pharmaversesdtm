# Dataset: dm_vaccine
# Description: DM SDTM dataset for Vaccine  studies


# Load libraries ----
library(tibble)
library(dplyr)
library(purrr)
library(metatools)

# create dm ----
## Read input data ----
data("dm")

vx_dm <- tribble(
  ~USUBJID, ~SUBJID, ~RFSTDTC, ~RFENDTC, ~RFXSTDTC, ~RFXENDTC, ~RFICDTC, ~RFPENDTC, ~SITEID, ~INVID,
  ~INVNAM, ~BRTHDTC, ~AGE, ~AGEU, ~SEX, ~RACE, ~ETHNIC,
  "ABC-1001", "1001", "2021-11-03T10:50:00", "2022-04-27", "2021-11-03T10:50:00",
  "2021-12-30T09:10:00", "2021-10-28", "2022-04-27", 1001, 1328, "Potter, Harry", "1947-09-21", 74,
  "YEARS", "F", "WHITE", "NOT HISPANIC OR LATINO",
  "ABC-1002", "1002", "2021-10-07T12:48:00", "2022-06-14", "2021-10-07T12:48:00",
  "2021-12-16T12:41:00", "2021-09-22", "2022-06-14", 1002, 1212, "Gomez, Selena", "1951-07-13", 70,
  "YEARS", "F", "BLACK OR AFRICAN AMERICAN", "HISPANIC OR LATINO"
) %>%
  mutate(
    STUDYID = "ABC",
    DOMAIN = "DM",
    DTHDTC = NA_character_,
    DTHFL = NA_character_,
    ARMCD = "VAXAB",
    ARM = "VACCINE A VACCINE B",
    ACTARMCD = "VAXAB",
    ACTARM = "VACCINE A VACCINE B",
    COUNTRY = "USA",
    DMDTC = NA_character_,
    DMDY = NA_integer_
  ) %>%
  # ordering the variables
  select(
    STUDYID, DOMAIN, USUBJID, SUBJID, RFSTDTC, RFENDTC, RFXSTDTC, RFXENDTC,
    RFICDTC, RFPENDTC, DTHDTC, DTHFL, SITEID, INVID, INVNAM, BRTHDTC, AGE, AGEU,
    SEX, RACE, ETHNIC, ARMCD, ARM, ACTARMCD, ACTARM, COUNTRY, DMDTC, DMDY
  )

# get common column names
common_cols <- intersect(names(vx_dm), names(dm))

# assign labels to vx_dm
walk(common_cols, \(x) attr(vx_dm[[x]], "label") <<- attr(dm[[x]], "label"))

dm_vaccine <- vx_dm %>%
  add_labels(
    INVID = "Investigator Identifier",
    INVNAM = "Investigator Name",
    BRTHDTC = "Date/Time of Birth"
  )

# Label dm dataset ----
attr(dm_vaccine, "label") <- "Demographics"

# Save dataset ----
usethis::use_data(dm_vaccine, overwrite = TRUE)
