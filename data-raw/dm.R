# Datasets: dm, suppdm
# Description: Standard DM, SUPPDM datasets from CDISC pilot study

# Load libraries -----
library(haven)
library(admiral)

# Create dm, suppdm ----
sdtm_path <- "https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/" # nolint
raw_dm <- read_xpt(paste0(sdtm_path, "dm", ".xpt?raw=true"))
raw_suppdm <- read_xpt(paste0(sdtm_path, "suppdm", ".xpt?raw=true"))
dm <- convert_blanks_to_na(raw_dm)
suppdm <- convert_blanks_to_na(raw_suppdm)

# Label dataset ----
attr(dm, "label") <- "Demographics"
attr(suppdm, "label") <- "Supplemental Demographics"

# Save datasets ----
usethis::use_data(dm, overwrite = TRUE)
usethis::use_data(suppdm, overwrite = TRUE)
