# Dataset: ex
# Description: Standard EX dataset from CDISC pilot study

# Load libraries -----
library(haven)
library(admiral)

# Create ex ----
raw_ex <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/ex.xpt?raw=true") # nolint
ex <- convert_blanks_to_na(raw_ex)

# Label dataset ----
attr(ex, "label") <- "Exposure"

# Save dataset ----
usethis::use_data(ex, overwrite = TRUE)
