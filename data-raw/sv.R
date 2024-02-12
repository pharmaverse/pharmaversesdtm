# Dataset: sv
# Description: StandardSV dataset from CDISC pilot study

# Load libraries -----
library(haven)
library(admiral)
library(dplyr)
raw_sv <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/sv.xpt?raw=true") # nolint
sv <- convert_blanks_to_na(raw_sv)

sv <- sv %>%
  group_by(USUBJID, VISITNUM) %>%
  mutate(
    ASEQ = row_number(),
    n = n()
  ) %>%
  mutate(
    VISIT = ifelse(n > 1, paste0("UNSCHEDULED ", floor(VISITNUM), ".", ASEQ), VISIT),
    VISITNUM = ifelse(n > 1, as.numeric(paste0(floor(VISITNUM), ".", ASEQ)), VISITNUM)
  ) %>%
  ungroup() %>%
  select(-ASEQ, -n)

# Label dataset ----
attr(sv, "label") <- "Subject Visits"

# Save dataset ----
usethis::use_data(sv, overwrite = TRUE)
