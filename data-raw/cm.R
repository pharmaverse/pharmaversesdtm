# from CDISC pilot study ----
library(haven)
library(admiral)
raw_cm <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/cm.xpt?raw=true") # nolint
cm <- convert_blanks_to_na(raw_cm)

usethis::use_data(cm, overwrite = TRUE)
