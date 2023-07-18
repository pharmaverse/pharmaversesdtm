# from CDISC pilot study ----
library(haven)
library(admiral)
raw_sv <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/sv.xpt?raw=true") # nolint
sv <- convert_blanks_to_na(raw_sv)

usethis::use_data(sv, overwrite = TRUE)
