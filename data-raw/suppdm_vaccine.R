# Dataset: suppdm_vaccine
# Description: SUPPDM SDTM dataset for Vaccine studies


# Load libraries ----
library(tibble)
library(dplyr)
library(purrr)
library(metatools)

# create suppdm
## Read input data ----
data("dm_vaccine")

suppdm <- tribble(
  ~STUDYID,
  "ABC"
)

vx_suppdm <- suppdm %>%
  mutate(
    STUDYID = "ABC",
    USUBJID = "ABC-1001",
    RDOMAIN = "DM",
    IDVAR = "",
    IDVARVAL = "",
    QNAM = "RACIALD",
    QVAL = "OTHER",
    QLABEL = "Racial Designation",
    QORIG = "CRF"
  ) %>%
  add_row(
    STUDYID = "ABC",
    USUBJID = "ABC-1002",
    RDOMAIN = "DM",
    IDVAR = "",
    IDVARVAL = "",
    QNAM = "RACIALD",
    QVAL = "OTHER",
    QLABEL = "Racial Designation",
    QORIG = "CRF"
  )

# get common column names
common_cols <- intersect(names(vx_suppdm), names(dm_vaccine))

# assign labels to vx_suppdm
walk(common_cols, \(x) attr(vx_suppdm[[x]], "label") <<-
  attr(dm_vaccine[[x]], "label"))

suppdm_vaccine <- vx_suppdm %>%
  add_labels(
    RDOMAIN = "Related Domain Abbreviation",
    IDVAR = "Identifying Variable",
    IDVARVAL = "Identifying Variable Value",
    QNAM = "Qualifier Variable Name",
    QLABEL = "Qualifier Variable Label",
    QVAL = "Data Value",
    QORIG = "Origin"
  )

# Label SUPPDM dataset ----
attr(suppdm_vaccine, "label") <- "Supplemental Qualifiers for Demographics"

# Save dataset ----
usethis::use_data(suppdm_vaccine, overwrite = TRUE)
