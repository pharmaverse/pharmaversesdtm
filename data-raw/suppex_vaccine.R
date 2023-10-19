# Dataset: suppex_vaccine
# Description: SUPPEX SDTM dataset for Vaccine studies

# Load libraries ----
library(tibble)
library(dplyr)
library(purrr)
library(metatools)

# create suppex
## Read input data ----
data("suppdm_vaccine")

suppex <- tribble(
  ~STUDYID,
  "ABC"
)

vx_suppex <- suppex %>%
  mutate(
    STUDYID = "ABC",
    USUBJID = "ABC-1001",
    RDOMAIN = "EX",
    IDVAR = "EXSEQ",
    IDVARVAL = "1",
    QNAM = "EXTDV",
    QVAL = "N",
    QLABEL = "Temporary Delay of Vaccination",
    QORIG = "ASSIGNED"
  ) %>%
  add_row(
    STUDYID = "ABC",
    USUBJID = "ABC-1001",
    RDOMAIN = "EX",
    IDVAR = "EXSEQ",
    IDVARVAL = "2",
    QNAM = "EXTDV",
    QVAL = "Y",
    QLABEL = "Temporary Delay of Vaccination",
    QORIG = "ASSIGNED"
  ) %>%
  add_row(
    STUDYID = "ABC",
    USUBJID = "ABC-1002",
    RDOMAIN = "EX",
    IDVAR = "EXSEQ",
    IDVARVAL = "1",
    QNAM = "EXTDV",
    QVAL = "N",
    QLABEL = "Temporary Delay of Vaccination",
    QORIG = "ASSIGNED"
  ) %>%
  add_row(
    STUDYID = "ABC",
    USUBJID = "ABC-1002",
    RDOMAIN = "EX",
    IDVAR = "EXSEQ",
    IDVARVAL = "2",
    QNAM = "EXTDV",
    QVAL = "Y",
    QLABEL = "Temporary Delay of Vaccination",
    QORIG = "ASSIGNED"
  )

# get common column names
common_cols <- intersect(names(vx_suppex), names(suppdm_vaccine))

# assign labels to vx_suppex
walk(common_cols, \(x) attr(vx_suppex[[x]], "label") <<-
  attr(suppdm_vaccine[[x]], "label"))

suppex_vaccine <- vx_suppex

# Label suppex dataset ----
attr(suppex_vaccine, "label") <- "Supplemental Qualifiers for Exposure"

# Save dataset ----
usethis::use_data(suppex_vaccine, overwrite = TRUE)
