# Datasets: ts
# Description: Standard TS dataset from CDISC pilot study

# Load libraries -----
library(haven)
library(admiral)
raw_ts <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/ts.xpt?raw=true") # nolint
ts <- convert_blanks_to_na(raw_ts)

# Label dataset ----
attr(ts, "label") <- "Trial Summary Information"

# Save dataset -----
usethis::use_data(ts, overwrite = TRUE)
