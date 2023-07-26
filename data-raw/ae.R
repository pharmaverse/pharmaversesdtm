# from CDISC pilot study ----
library(dplyr)
library(metatools)
library(haven)
library(admiral)

raw_ae <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/ae.xpt?raw=true") # nolint
raw_suppae <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/suppae.xpt?raw=true") # nolint
ae <- convert_blanks_to_na(raw_ae)
suppae <- convert_blanks_to_na(raw_suppae)

# Save dataset ----
save(ae, file = "data/ae.rda", compress = "bzip2")
usethis::use_data(suppae, overwrite = TRUE)
