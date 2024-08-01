# Dataset: dm_peds
# Description: Create DM test SDTM dataset for pediatric studies

# Load libraries -----
library(dplyr)
library(admiral)

# Read input test data from pharmaversesdtm ----
data("dm")

# Convert blank to NA ----
dm <- convert_blanks_to_na(dm)

# Subset to first 5 patients only (which is enough for our examples) ----
dm_subset <- dm %>%
  filter(USUBJID %in% c(
    "01-701-1015", "01-701-1023", "01-701-1028",
    "01-701-1033", "01-701-1034"
  ))

# Add birth dates/age realistic for pediatrics in line with treatment dates ----
dm_peds <- dm_subset %>%
  mutate(BRTHDTC = case_when(
    USUBJID == "01-701-1015" ~ "2013-01-02",
    USUBJID == "01-701-1023" ~ "2010-08-05",
    USUBJID == "01-701-1028" ~ "2010-07-19",
    USUBJID == "01-701-1033" ~ "2014-01-01",
    USUBJID == "01-701-1034" ~ "2014-06-01"
  )) %>%
  mutate(AGE = case_when(
    USUBJID == "01-701-1015" ~ 1,
    USUBJID == "01-701-1023" ~ 2,
    USUBJID == "01-701-1028" ~ 3,
    USUBJID == "01-701-1033" ~ 0,
    USUBJID == "01-701-1034" ~ 0
  ))

# Variable labels ----
attr(dm_peds$BRTHDTC, "label") <- "Date/Time of Birth"
attr(dm_peds$AGE, "label") <- "Age"

# Label dataset ----
attr(dm_peds, "label") <- "Demographics"

# Save dataset ----
usethis::use_data(dm_peds, overwrite = TRUE)
