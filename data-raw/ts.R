# from CDISC pilot study ----
library(haven)
library(admiral)
raw_ts <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/ts.xpt?raw=true") # nolint
ts <- convert_blanks_to_na(raw_ts)

usethis::use_data(ts, overwrite = TRUE)
