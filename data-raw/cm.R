# Dataset: cm
# Description: Standard CM dataset from CDISC pilot study

# Load libraries -----
library(haven)
library(admiral)
library(dplyr)
library(metatools)

# Create cm ----
raw_cm <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/cm.xpt?raw=true") # nolint
cm <- convert_blanks_to_na(raw_cm) %>%
  mutate(CMENRTPT = if_else(is.na(CMENDTC), "ONGOING", NA_character_))

# Label variables ----
cm <- cm %>%
  add_labels(
    CMENRTPT = "End Relative to Reference Time Point"
  )

# Label dataset ----
attr(cm, "label") <- "Concomitant Medications"

# Save dataset ----
usethis::use_data(cm, overwrite = TRUE)
