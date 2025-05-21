# Dataset: suppce_vaccine
# Description: SUPPCE test SDTM dataset for Vaccine studies


# Load libraries ----
library(tibble)
library(dplyr)
library(purrr)
library(metatools)

## Read input data ----
suppdm_vaccine <- pharmaversesdtm::suppdm_vaccine

suppce <- tribble(
  ~STUDYID,
  "ABC"
)

vx_suppce <- suppce %>%
  mutate(
    STUDYID = "ABC",
    USUBJID = "ABC-1001",
    RDOMAIN = "CE",
    IDVAR = "CESEQ",
    IDVARVAL = "1",
    QNAM = "CEEVAL",
    QVAL = "STUDY SUBJECT",
    QLABEL = "Evaluator",
    QORIG = "ASSIGNED"
  ) %>%
  add_row(
    STUDYID = "ABC",
    USUBJID = "ABC-1001",
    RDOMAIN = "CE",
    IDVAR = "CESEQ",
    IDVARVAL = "2",
    QNAM = "CEEVAL",
    QVAL = "STUDY SUBJECT",
    QLABEL = "Evaluator",
    QORIG = "ASSIGNED"
  ) %>%
  add_row(
    STUDYID = "ABC",
    USUBJID = "ABC-1002",
    RDOMAIN = "CE",
    IDVAR = "CESEQ",
    IDVARVAL = "1",
    QNAM = "CEEVAL",
    QVAL = "STUDY SUBJECT",
    QLABEL = "Evaluator",
    QORIG = "ASSIGNED"
  ) %>%
  add_row(
    STUDYID = "ABC",
    USUBJID = "ABC-1002",
    RDOMAIN = "CE",
    IDVAR = "CESEQ",
    IDVARVAL = "2",
    QNAM = "CEEVAL",
    QVAL = "STUDY SUBJECT",
    QLABEL = "Evaluator",
    QORIG = "ASSIGNED"
  )

# get common column names
common_cols <- intersect(names(vx_suppce), names(suppdm_vaccine))

# assign labels to vx_suppce
walk(common_cols, \(x) attr(vx_suppce[[x]], "label") <<-
  attr(suppdm_vaccine[[x]], "label"))

suppce_vaccine <- vx_suppce

# Label SUPPCE dataset ----
attr(suppce_vaccine, "label") <- "Supplemental Qualifiers for Clinical Events"

# Save dataset ----
usethis::use_data(suppce_vaccine, overwrite = TRUE)
