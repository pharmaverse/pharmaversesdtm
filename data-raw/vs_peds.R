# Dataset: vs_peds
# Description: Create VS test SDTM dataset for pediatric studies

# Load libraries -----
library(dplyr)
library(admiral)

# Read input test data from pharmaversesdtm ----
data("vs")

# Convert blank to NA ----
vs <- convert_blanks_to_na(vs)

# Subset to 5 patients present in dm_peds and only keep WEIGHT records ----
vs_subset <- vs %>%
  filter(USUBJID %in% c(
    "01-701-1015", "01-701-1023", "01-701-1028",
    "01-701-1033", "01-701-1034"
  ) &
    VSTESTCD %in% c("WEIGHT"))

# Create placeholder records for HEIGHT, BMI and HDCIRC from the WEIGHT records
vs_subset_height <- vs_subset %>%
  mutate(VSTESTCD = "HEIGHT")
vs_subset_bmi <- vs_subset %>%
  mutate(VSTESTCD = "BMI")
vs_subset_hdcirc <- vs_subset %>%
  mutate(VSTESTCD = "HDCIRC")

# Bind new parameter records to original dataset
vs_subset_full <- bind_rows(
  vs_subset,
  vs_subset_height,
  vs_subset_bmi,
  vs_subset_hdcirc
) %>%
  arrange(USUBJID, VSTESTCD, VISITNUM, VSDY)

# Updating each parameters values and units to be consistent with the ages of these dummy patients
vs_peds <- vs_subset_full %>%
  mutate(VSSTRESN = case_when(
    USUBJID == "01-701-1015" & VSTESTCD == "WEIGHT" ~ case_when(
      VISIT == "SCREENING 1" ~ 9.11,
      VISIT == "BASELINE" ~ 9.2,
      VISIT == "WEEK 2" ~ 9.32,
      VISIT == "WEEK 4" ~ 9.54,
      VISIT == "WEEK 6" ~ 9.7,
      VISIT == "WEEK 8" ~ 9.91,
      VISIT == "WEEK 12" ~ 10.3,
      VISIT == "WEEK 16" ~ 10.7,
      VISIT == "WEEK 20" ~ 11.1,
      VISIT == "WEEK 24" ~ 11.56,
      VISIT == "WEEK 26" ~ 11.71,
    ),
    USUBJID == "01-701-1015" & VSTESTCD == "HEIGHT" ~ case_when(
      VISIT == "SCREENING 1" ~ 74.13,
      VISIT == "BASELINE" ~ 74.41,
      VISIT == "WEEK 2" ~ 74.71,
      VISIT == "WEEK 4" ~ 75.32,
      VISIT == "WEEK 6" ~ 75.93,
      VISIT == "WEEK 8" ~ 76.54,
      VISIT == "WEEK 12" ~ 77.72,
      VISIT == "WEEK 16" ~ 78.96,
      VISIT == "WEEK 20" ~ 80.22,
      VISIT == "WEEK 24" ~ 81.43,
      VISIT == "WEEK 26" ~ 82.03
    ),
    USUBJID == "01-701-1015" & VSTESTCD == "HDCIRC" ~ case_when(
      VISIT == "SCREENING 1" ~ 35.61,
      VISIT == "BASELINE" ~ 37.24,
      VISIT == "WEEK 2" ~ 38.57,
      VISIT == "WEEK 4" ~ 39.84,
      VISIT == "WEEK 6" ~ 40.95,
      VISIT == "WEEK 8" ~ 42.14,
      VISIT == "WEEK 12" ~ 43.67,
      VISIT == "WEEK 16" ~ 44.79,
      VISIT == "WEEK 20" ~ 45.92,
      VISIT == "WEEK 24" ~ 46.88,
      VISIT == "WEEK 26" ~ 47.56
    ),
    USUBJID == "01-701-1023" & VSTESTCD == "WEIGHT" ~ case_when(
      VISIT == "SCREENING 1" ~ 12.47,
      VISIT == "BASELINE" ~ 12.89,
      VISIT == "WEEK 2" ~ 13.14,
      VISIT == "WEEK 4" ~ 13.45
    ),
    USUBJID == "01-701-1023" & VSTESTCD == "HEIGHT" ~ case_when(
      VISIT == "SCREENING 1" ~ 87.65,
      VISIT == "BASELINE" ~ 88.25,
      VISIT == "WEEK 2" ~ 88.75,
      VISIT == "WEEK 4" ~ 89.23
    ),
    USUBJID == "01-701-1023" & VSTESTCD == "HDCIRC" ~ case_when(
      VISIT == "SCREENING 1" ~ 48.34,
      VISIT == "BASELINE" ~ 48.71,
      VISIT == "WEEK 2" ~ 49.12,
      VISIT == "WEEK 4" ~ 49.56
    ),
    USUBJID == "01-701-1028" & VSTESTCD == "HEIGHT" ~ case_when(
      VISIT == "SCREENING 1" ~ 98.32,
      VISIT == "BASELINE" ~ 98.95,
      VISIT == "WEEK 2" ~ 99.34,
      VISIT == "WEEK 4" ~ 99.68,
      VISIT == "WEEK 6" ~ 100.13,
      VISIT == "WEEK 8" ~ 100.45,
      VISIT == "WEEK 12" ~ 101.02,
      VISIT == "WEEK 16" ~ 101.48,
      VISIT == "WEEK 20" ~ 101.97,
      VISIT == "WEEK 24" ~ 102.44,
      VISIT == "WEEK 26" ~ 102.82
    ),
    USUBJID == "01-701-1028" & VSTESTCD == "WEIGHT" ~ case_when(
      VISIT == "SCREENING 1" ~ 14.65,
      VISIT == "BASELINE" ~ 14.95,
      VISIT == "WEEK 2" ~ 15.17,
      VISIT == "WEEK 4" ~ 15.43,
      VISIT == "WEEK 6" ~ 15.66,
      VISIT == "WEEK 8" ~ 15.84,
      VISIT == "WEEK 12" ~ 16.34,
      VISIT == "WEEK 16" ~ 16.73,
      VISIT == "WEEK 20" ~ 17.11,
      VISIT == "WEEK 24" ~ 17.56,
      VISIT == "WEEK 26" ~ 17.85
    ),
    USUBJID == "01-701-1028" & VSTESTCD == "HDCIRC" ~ case_when(
      VISIT == "SCREENING 1" ~ 51.34,
      VISIT == "BASELINE" ~ 51.71,
      VISIT == "WEEK 2" ~ 52.12,
      VISIT == "WEEK 4" ~ 52.56,
      VISIT == "WEEK 6" ~ 52.93,
      VISIT == "WEEK 8" ~ 53.45,
      VISIT == "WEEK 12" ~ 54.02,
      VISIT == "WEEK 16" ~ 54.48,
      VISIT == "WEEK 20" ~ 54.97,
      VISIT == "WEEK 24" ~ 55.44,
      VISIT == "WEEK 26" ~ 55.82
    ),
    USUBJID == "01-701-1033" & VSTESTCD == "HEIGHT" ~ case_when(
      VISIT == "SCREENING 1" ~ 59.45,
      VISIT == "BASELINE" ~ 60.53,
      VISIT == "WEEK 2" ~ 61.72,
      VISIT == "WEEK 4" ~ 62.91
    ),
    USUBJID == "01-701-1033" & VSTESTCD == "WEIGHT" ~ case_when(
      VISIT == "SCREENING 1" ~ 5.62,
      VISIT == "BASELINE" ~ 5.89,
      VISIT == "WEEK 2" ~ 6.17,
      VISIT == "WEEK 4" ~ 6.45
    ),
    USUBJID == "01-701-1033" & VSTESTCD == "HDCIRC" ~ case_when(
      VISIT == "SCREENING 1" ~ 40.34,
      VISIT == "BASELINE" ~ 40.71,
      VISIT == "WEEK 2" ~ 41.12,
      VISIT == "WEEK 4" ~ 41.56
    ),
    USUBJID == "01-701-1034" & VSTESTCD == "HEIGHT" ~ case_when(
      VISIT == "SCREENING 1" ~ 53.65,
      VISIT == "BASELINE" ~ 54.78,
      VISIT == "WEEK 2" ~ 55.95,
      VISIT == "WEEK 4" ~ 57.14,
      VISIT == "WEEK 6" ~ 58.23,
      VISIT == "WEEK 8" ~ 59.45,
      VISIT == "WEEK 12" ~ 60.67,
      VISIT == "WEEK 16" ~ 61.79,
      VISIT == "WEEK 20" ~ 62.91,
      VISIT == "WEEK 24" ~ 64.03,
      VISIT == "WEEK 26" ~ 65.15
    ),
    USUBJID == "01-701-1034" & VSTESTCD == "WEIGHT" ~ case_when(
      VISIT == "SCREENING 1" ~ 4.25,
      VISIT == "BASELINE" ~ 4.56,
      VISIT == "WEEK 2" ~ 4.84,
      VISIT == "WEEK 4" ~ 5.15,
      VISIT == "WEEK 6" ~ 5.47,
      VISIT == "WEEK 8" ~ 5.79,
      VISIT == "WEEK 12" ~ 6.11,
      VISIT == "WEEK 16" ~ 6.43,
      VISIT == "WEEK 20" ~ 6.75,
      VISIT == "WEEK 24" ~ 7.07,
      VISIT == "WEEK 26" ~ 7.39
    ),
    USUBJID == "01-701-1034" & VSTESTCD == "HDCIRC" ~ case_when(
      VISIT == "SCREENING 1" ~ 38.45,
      VISIT == "BASELINE" ~ 38.92,
      VISIT == "WEEK 2" ~ 39.34,
      VISIT == "WEEK 4" ~ 39.78,
      VISIT == "WEEK 6" ~ 40.23,
      VISIT == "WEEK 8" ~ 40.65,
      VISIT == "WEEK 12" ~ 41.07,
      VISIT == "WEEK 16" ~ 41.48,
      VISIT == "WEEK 20" ~ 41.89,
      VISIT == "WEEK 24" ~ 42.30,
      VISIT == "WEEK 26" ~ 42.72
    ),
    TRUE ~ VSSTRESN
  ))

# Derive BMI values ----
vs_peds <- vs_peds %>%
  arrange(USUBJID, VISITNUM, VSTESTCD, VSDY) %>%
  group_by(USUBJID, VISITNUM) %>%
  mutate(
    VSSTRESN = case_when(
      VSTESTCD == "BMI" ~ {
        weight <- VSSTRESN[VSTESTCD == "WEIGHT"]
        height <- VSSTRESN[VSTESTCD == "HEIGHT"] / 100 # Convert height from cm to m
        as.numeric(weight / (height^2)) # BMI calculation
      },
      TRUE ~ VSSTRESN
    )
  ) %>%
  ungroup()

# Formatting the output dataset ----
vs_peds <- vs_peds %>%
  mutate(
    VSSEQ = row_number(),
    VSPOS = NA_character_,
    VSORRESU = case_when(
      VSTESTCD == "HEIGHT" ~ "cm",
      VSTESTCD == "WEIGHT" ~ "kg",
      VSTESTCD == "BMI" ~ "kg/m2",
      VSTESTCD == "HDCIRC" ~ "cm",
      TRUE ~ NA_character_
    ),
    VSTEST = case_when(
      VSTESTCD == "HEIGHT" ~ "Height",
      VSTESTCD == "WEIGHT" ~ "Weight",
      VSTESTCD == "BMI" ~ "BMI",
      VSTESTCD == "HDCIRC" ~ "Head Circumference",
      TRUE ~ NA_character_
    ),
    VSSTRESC = as.character(VSSTRESN),
    VSORRES = VSSTRESC,
    VSSTRESU = VSORRESU,
    VSSTAT = NA_character_,
    VSLOC = NA_character_,
    VSBLFL = if_else(VISITNUM == 2, "Y", NA_character_),
    VISITDY = NA_integer_,
    VSDY = NA_integer_,
    VSEVAL = NA_character_,
    EPOCH = "Epoch"
  ) %>%
  arrange(USUBJID, VSTESTCD, VISITNUM, VSDY)

# Get common column names with VS
common_cols <- intersect(names(vs), names(vs_peds))

# Copy attributes (including labels) from vs to vs_peds for common columns
for (col in common_cols) {
  attributes(vs_peds[[col]]) <- attributes(vs[[col]])
}
# Set the labels for non-commn variables
attr(vs_peds$VSEVAL, "label") <- "Evaluator"
attr(vs_peds$EPOCH, "label") <- "Epoch"

# Label dataset ----
attr(vs_peds, "label") <- "Vital Signs"

# Save dataset ----
usethis::use_data(vs_peds, overwrite = TRUE)
