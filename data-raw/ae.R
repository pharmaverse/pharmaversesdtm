# Datasets: ae, suppae
# Description: Standard AE, SUPPAE datasets from CDISC pilot study

# Load libraries -----
library(dplyr)
library(metatools)
library(haven)
library(admiral)

# Create ae, suppae ----
raw_ae <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/ae.xpt?raw=true") # nolint
raw_suppae <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/suppae.xpt?raw=true") # nolint
ae <- convert_blanks_to_na(raw_ae)
suppae <- convert_blanks_to_na(raw_suppae)

# Label dataset ----
attr(ae, "label") <- "Adverse Events"
attr(suppae, "label") <- "Supplemental Qualifiers for AE"

# Save datasets ----
usethis::use_data(ae, overwrite = TRUE)
usethis::use_data(suppae, overwrite = TRUE)
