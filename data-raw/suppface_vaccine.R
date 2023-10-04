# Dataset: suppface_vaccine
# Description: SUPPFACE test SDTM dataset for Vaccine studies


# Load libraries ----
library(tibble)
library(dplyr)
library(purrr)
library(metatools)

## Read input data ----
data("suppdm_vaccine")

suppface <- tribble(
  ~STUDYID,
  "ABC"
)

vx_suppface <- suppface %>%
  mutate(
    STUDYID = "ABC",
    USUBJID = "ABC-1001",
    RDOMAIN = "FACE",
    IDVAR = "FASEQ",
    IDVARVAL = "1",
    QNAM = "CLTYP",
    QVAL = "DAIRY",
    QLABEL = "Collection Type",
    QORIG = "Predecessor"
  ) %>%
  add_row(
    STUDYID = "ABC",
    USUBJID = "ABC-1001",
    RDOMAIN = "FACE",
    IDVAR = "FASEQ",
    IDVARVAL = "2",
    QNAM = "CLTYP",
    QVAL = "DAIRY",
    QLABEL = "Collection Type",
    QORIG = "Predecessor"
  ) %>%
  add_row(
    STUDYID = "ABC",
    USUBJID = "ABC-1002",
    RDOMAIN = "FACE",
    IDVAR = "FASEQ",
    IDVARVAL = "1",
    QNAM = "CLTYP",
    QVAL = "DAIRY",
    QLABEL = "Collection Type",
    QORIG = "Predecessor"
  ) %>%
  add_row(
    STUDYID = "ABC",
    USUBJID = "ABC-1002",
    RDOMAIN = "FACE",
    IDVAR = "FASEQ",
    IDVARVAL = "2",
    QNAM = "CLTYP",
    QVAL = "DAIRY",
    QLABEL = "Collection Type",
    QORIG = "Predecessor"
  )

# get common column names
common_cols <- intersect(names(vx_suppface), names(suppdm_vaccine))

# assign labels to vx_suppface
walk(common_cols, \(x) attr(vx_suppface[[x]], "label") <<-
  attr(suppdm_vaccine[[x]], "label"))

suppface_vaccine <- vx_suppface

# Label SUPPFACE dataset ----
attr(suppface_vaccine, "label") <-
  "Supplemental Qualifiers for Findings About Clinical Events"

# Save dataset ----
usethis::use_data(suppface_vaccine, overwrite = TRUE)
