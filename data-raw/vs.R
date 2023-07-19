# from CDISC pilot study ----
library(haven)
library(admiral)
raw_vs <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/vs.xpt?raw=true") # nolint
vs <- convert_blanks_to_na(raw_vs)

usethis::use_data(vs, overwrite = TRUE)
