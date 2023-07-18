# from CDISC pilot study ----
library(haven)
library(admiral)
sdtm_path <- "https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/" # nolint
raw_dm <- read_xpt(paste0(sdtm_path, "dm", ".xpt?raw=true"))
raw_suppdm <- read_xpt(paste0(sdtm_path, "suppdm", ".xpt?raw=true"))
dm <- convert_blanks_to_na(raw_dm)
suppdm <- convert_blanks_to_na(raw_suppdm)

usethis::use_data(dm, overwrite = TRUE)
usethis::use_data(suppdm, overwrite = TRUE)
