# Dataset: is_vaccine
# Description: SUPPIS SDTM dataset for Vaccine studies

# Load libraries ----
library(tibble)
library(dplyr)
library(purrr)
library(metatools)

# create suppis_vaccine
## Read input data ----
suppdm_vaccine <- pharmaversesdtm::suppdm_vaccine

vx_suppis <- tribble(
  ~USUBJID, ~IDVAR, ~IDVARVAL, ~QNAM, ~QLABEL, ~QVAL, ~QORIG, ~QEVAL,
  "ABC-1001", "ISSEQ", "1", "LOD", "Limit of Detection", "4", "CRF", NA,
  "ABC-1001", "ISSEQ", "2", "LOD", "Limit of Detection", "5", "CRF", NA,
  "ABC-1001", "ISSEQ", "3", "LOD", "Limit of Detection", "4", "CRF", NA,
  "ABC-1001", "ISSEQ", "4", "LOD", "Limit of Detection", "8", "CRF", NA,
  "ABC-1001", "ISSEQ", "5", "LOD", "Limit of Detection", "4", "CRF", NA,
  "ABC-1001", "ISSEQ", "6", "LOD", "Limit of Detection", "5", "CRF", NA,
  "ABC-1001", "ISSEQ", "7", "LOD", "Limit of Detection", "4", "CRF", NA,
  "ABC-1001", "ISSEQ", "8", "LOD", "Limit of Detection", "8", "CRF", NA,
  "ABC-1002", "ISSEQ", "1", "LOD", "Limit of Detection", "4", "CRF", NA,
  "ABC-1002", "ISSEQ", "2", "LOD", "Limit of Detection", "5", "CRF", NA,
  "ABC-1002", "ISSEQ", "3", "LOD", "Limit of Detection", "4", "CRF", NA,
  "ABC-1002", "ISSEQ", "4", "LOD", "Limit of Detection", "8", "CRF", NA,
  "ABC-1002", "ISSEQ", "5", "LOD", "Limit of Detection", "4", "CRF", NA,
  "ABC-1002", "ISSEQ", "6", "LOD", "Limit of Detection", "5", "CRF", NA,
  "ABC-1002", "ISSEQ", "7", "LOD", "Limit of Detection", "4", "CRF", NA,
  "ABC-1002", "ISSEQ", "8", "LOD", "Limit of Detection", "8", "CRF", NA
) %>%
  mutate(
    STUDYID = "ABC",
    RDOMAIN = "IS"
  ) %>%
  select(
    STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM, QLABEL, QVAL, QORIG, QEVAL
  )

# get common column names
common_cols <- intersect(names(vx_suppis), names(suppdm_vaccine))

# assign labels to vx_suppis
walk(common_cols, \(x) attr(vx_suppis[[x]], "label") <<-
  attr(suppdm_vaccine[[x]], "label"))

suppis_vaccine <- vx_suppis %>%
  add_labels(QEVAL = "Evaluator")

# Label SUPPIS dataset ----
attr(suppis_vaccine, "label") <-
  "Supplemental Qualifiers for Immunogenicity Specimen Assessments"

# Save dataset ----
usethis::use_data(suppis_vaccine, overwrite = TRUE)
