# Dataset: vs_metabolic
# Description: Create VS test SDTM dataset for metabolic studies

# Load libraries ----

library(dplyr)
library(admiral)
library(purrr)

## Read input data ----

vs <- pharmaversesdtm::vs

# Subset to 5 patients present in dm_metabolic
vs1 <- vs %>%
  filter(USUBJID %in% c(
    "01-701-1015", "01-701-1023", "01-701-1028",
    "01-701-1033", "01-701-1034"
  ))

# Create placeholder record for WAIST CIRCUMFERENCE from the WEIGHT records
vs1_wstcir <- vs1 %>%
  filter(VSTESTCD == "WEIGHT") %>%
  mutate(VSTESTCD = "WSTCIR", VSTEST = "Waist Circumference")

vs1_hipcir <- vs1 %>%
  filter(VSTESTCD == "WEIGHT") %>%
  mutate(VSTESTCD = "HIPCIR", VSTEST = "Hip Circumference")

# Bind new parameter records to original dataset
vs_full <- bind_rows(vs1, vs1_wstcir, vs1_hipcir) %>%
  arrange(USUBJID, VSTESTCD, VISITNUM, VSDY)

# Updating each parameter values for each subject to make them obese
vs_mb <- vs_full %>%
  mutate(
    VSSTRESN =
      case_when(
        USUBJID == "01-701-1015" & # PLACEBO
          VSTESTCD == "WEIGHT" ~ case_when(
          VISIT == "SCREENING 1" ~ 89.20,
          VISIT == "BASELINE" ~ 89.10,
          VISIT == "WEEK 2" ~ 90.20,
          VISIT == "WEEK 4" ~ 90.42,
          VISIT == "WEEK 6" ~ 90.54,
          VISIT == "WEEK 8" ~ 90.81,
          VISIT == "WEEK 12" ~ 91.20,
          VISIT == "WEEK 16" ~ 90.31,
          VISIT == "WEEK 20" ~ 91.37,
          VISIT == "WEEK 24" ~ 91.55,
          VISIT == "WEEK 26" ~ 93.10,
        ),
        USUBJID == "01-701-1015" & # PLACEBO
          VSTESTCD == "HEIGHT" ~ case_when(VISIT == "SCREENING 1" ~ 153),
        USUBJID == "01-701-1015" & # PLACEBO
          VSTESTCD == "WSTCIR" ~ case_when(
          VISIT == "SCREENING 1" ~ 99,
          VISIT == "BASELINE" ~ 99,
          VISIT == "WEEK 2" ~ 100,
          VISIT == "WEEK 4" ~ 100.4,
          VISIT == "WEEK 6" ~ 101,
          VISIT == "WEEK 8" ~ 101,
          VISIT == "WEEK 12" ~ 102,
          VISIT == "WEEK 16" ~ 102.5,
          VISIT == "WEEK 20" ~ 102.7,
          VISIT == "WEEK 24" ~ 104,
          VISIT == "WEEK 26" ~ 105,
        ),
        USUBJID == "01-701-1015" & # PLACEBO
          VSTESTCD == "HIPCIR" ~ case_when(
          VISIT == "SCREENING 1" ~ 102,
          VISIT == "BASELINE" ~ 102,
          VISIT == "WEEK 2" ~ 103,
          VISIT == "WEEK 4" ~ 103,
          VISIT == "WEEK 6" ~ 103,
          VISIT == "WEEK 8" ~ 104,
          VISIT == "WEEK 12" ~ 104.2,
          VISIT == "WEEK 16" ~ 104.7,
          VISIT == "WEEK 20" ~ 105,
          VISIT == "WEEK 24" ~ 105.1,
          VISIT == "WEEK 26" ~ 105.2,
        ),
        USUBJID == "01-701-1023" & # PLACEBO
          VSTESTCD == "WEIGHT" ~ case_when(
          VISIT == "SCREENING 1" ~ 110.11,
          VISIT == "BASELINE" ~ 110.02,
          VISIT == "WEEK 2" ~ 111.31,
          VISIT == "WEEK 4" ~ 112.21
        ),
        USUBJID == "01-701-1023" & # PLACEBO
          VSTESTCD == "HEIGHT" ~ case_when(VISIT == "SCREENING 1" ~ 169),
        USUBJID == "01-701-1023" & # PLACEBO
          VSTESTCD == "WSTCIR" ~ case_when(
          VISIT == "SCREENING 1" ~ 106,
          VISIT == "BASELINE" ~ 107,
          VISIT == "WEEK 2" ~ 107.8,
          VISIT == "WEEK 4" ~ 109
        ),
        USUBJID == "01-701-1023" & # PLACEBO
          VSTESTCD == "HIPCIR" ~ case_when(
          VISIT == "SCREENING 1" ~ 110,
          VISIT == "BASELINE" ~ 110,
          VISIT == "WEEK 2" ~ 111.4,
          VISIT == "WEEK 4" ~ 112
        ),
        USUBJID == "01-701-1028" & # Insulin
          VSTESTCD == "WEIGHT" ~ case_when(
          VISIT == "SCREENING 1" ~ 95.14,
          VISIT == "BASELINE" ~ 95.11,
          VISIT == "WEEK 2" ~ 94.23,
          VISIT == "WEEK 4" ~ 92.11,
          VISIT == "WEEK 6" ~ 91.55,
          VISIT == "WEEK 8" ~ 90.24,
          VISIT == "WEEK 12" ~ 89.33,
          VISIT == "WEEK 16" ~ 88.82,
          VISIT == "WEEK 20" ~ 88.15,
          VISIT == "WEEK 24" ~ 87.06,
          VISIT == "WEEK 26" ~ 86.12
        ),
        USUBJID == "01-701-1028" & # Insulin
          VSTESTCD == "HEIGHT" ~ case_when(VISIT == "SCREENING 1" ~ 159),
        USUBJID == "01-701-1028" & # Insulin
          VSTESTCD == "WSTCIR" ~ case_when(
          VISIT == "SCREENING 1" ~ 105,
          VISIT == "BASELINE" ~ 105,
          VISIT == "WEEK 2" ~ 104,
          VISIT == "WEEK 4" ~ 102,
          VISIT == "WEEK 6" ~ 101,
          VISIT == "WEEK 8" ~ 100,
          VISIT == "WEEK 12" ~ 99.4,
          VISIT == "WEEK 16" ~ 99,
          VISIT == "WEEK 20" ~ 97,
          VISIT == "WEEK 24" ~ 96,
          VISIT == "WEEK 26" ~ 95
        ),
        USUBJID == "01-701-1028" & # Insulin
          VSTESTCD == "HIPCIR" ~ case_when(
          VISIT == "SCREENING 1" ~ 111,
          VISIT == "BASELINE" ~ 111,
          VISIT == "WEEK 2" ~ 110,
          VISIT == "WEEK 4" ~ 112,
          VISIT == "WEEK 6" ~ 109,
          VISIT == "WEEK 8" ~ 108,
          VISIT == "WEEK 12" ~ 107.5,
          VISIT == "WEEK 16" ~ 106.2,
          VISIT == "WEEK 20" ~ 104,
          VISIT == "WEEK 24" ~ 103,
          VISIT == "WEEK 26" ~ 102
        ),
        USUBJID == "01-701-1033" & # Insulin
          VSTESTCD == "WEIGHT" ~ case_when(
          VISIT == "SCREENING 1" ~ 101.82,
          VISIT == "BASELINE" ~ 101.61,
          VISIT == "WEEK 2" ~ 100.64,
          VISIT == "WEEK 4" ~ 99.91
        ),
        USUBJID == "01-701-1033" & # Insulin
          VSTESTCD == "HEIGHT" ~ case_when(VISIT == "SCREENING 1" ~ 158),
        USUBJID == "01-701-1033" & # Insulin
          VSTESTCD == "WSTCIR" ~ case_when(
          VISIT == "SCREENING 1" ~ 108,
          VISIT == "BASELINE" ~ 107,
          VISIT == "WEEK 2" ~ 107,
          VISIT == "WEEK 4" ~ 106
        ),
        USUBJID == "01-701-1033" & # Insulin
          VSTESTCD == "HIPCIR" ~ case_when(
          VISIT == "SCREENING 1" ~ 110,
          VISIT == "BASELINE" ~ 110,
          VISIT == "WEEK 2" ~ 108,
          VISIT == "WEEK 4" ~ 107
        ),
        USUBJID == "01-701-1034" & # Insulin
          VSTESTCD == "WEIGHT" ~ case_when(
          VISIT == "SCREENING 1" ~ 108.12,
          VISIT == "BASELINE" ~ 107.43,
          VISIT == "WEEK 2" ~ 105.41,
          VISIT == "WEEK 4" ~ 104.92,
          VISIT == "WEEK 6" ~ 103.65,
          VISIT == "WEEK 8" ~ 103.12,
          VISIT == "WEEK 12" ~ 100.11,
          VISIT == "WEEK 16" ~ 97.42,
          VISIT == "WEEK 20" ~ 96.95,
          VISIT == "WEEK 24" ~ 94.86,
          VISIT == "WEEK 26" ~ 94.11
        ),
        USUBJID == "01-701-1034" & # Insulin
          VSTESTCD == "HEIGHT" ~ case_when(VISIT == "SCREENING 1" ~ 163),
        USUBJID == "01-701-1034" & # Insulin
          VSTESTCD == "WSTCIR" ~ case_when(
          VISIT == "SCREENING 1" ~ 115,
          VISIT == "BASELINE" ~ 115,
          VISIT == "WEEK 2" ~ 114,
          VISIT == "WEEK 4" ~ 113,
          VISIT == "WEEK 6" ~ 112,
          VISIT == "WEEK 8" ~ 113,
          VISIT == "WEEK 12" ~ 110,
          VISIT == "WEEK 16" ~ 109.2,
          VISIT == "WEEK 20" ~ 109,
          VISIT == "WEEK 24" ~ 108,
          VISIT == "WEEK 26" ~ 107
        ),
        USUBJID == "01-701-1034" & # Insulin
          VSTESTCD == "HIPCIR" ~ case_when(
          VISIT == "SCREENING 1" ~ 120,
          VISIT == "BASELINE" ~ 119.7,
          VISIT == "WEEK 2" ~ 119.1,
          VISIT == "WEEK 4" ~ 118.3,
          VISIT == "WEEK 6" ~ 117.7,
          VISIT == "WEEK 8" ~ 117,
          VISIT == "WEEK 12" ~ 116.4,
          VISIT == "WEEK 16" ~ 115,
          VISIT == "WEEK 20" ~ 114,
          VISIT == "WEEK 24" ~ 113,
          VISIT == "WEEK 26" ~ 113
        ),
        TRUE ~ VSSTRESN
      )
  )

# Derive BMI values ----
vs_mb_bmi <- vs_mb %>%
  # use body weight as a base for the table
  filter(VSTESTCD == "WEIGHT") %>%
  mutate(VSSTRESN = as.numeric(VSSTRESN)) %>%
  # rename value to body weight
  rename(BODYWEIGHT = VSSTRESN) %>%
  # drop irrelevant columns
  select(-VSORRES, -VSORRESU) %>%
  # add height
  left_join(
    vs_mb %>%
      # pick height
      filter(VSTESTCD == "HEIGHT") %>%
      # Convert height from cm to m
      mutate(VSSTRESN = as.numeric(VSSTRESN / 100)) %>%
      # rename
      rename(HEIGHT = VSSTRESN) %>%
      # drop irrelevant
      select(USUBJID, HEIGHT),
    by = "USUBJID"
  ) %>%
  # calculate bmi
  mutate(
    VSSTRESN = as.numeric(BODYWEIGHT / (HEIGHT^2)),
    VSTESTCD = "BMI",
    VSTEST = "Body Mass Index",
  ) %>%
  # drop irrelevant
  select(-BODYWEIGHT, -HEIGHT)

# Bind BMI dataset to vs_mb dataset
vs_mb <- bind_rows(vs_mb, vs_mb_bmi) %>% arrange(USUBJID, VSTESTCD, VISITNUM, VSDY)

# Formatting the output dataset ----
vs_mb <- vs_mb %>%
  mutate(
    VSSEQ = row_number(),
    VSORRESU = case_when(
      VSTESTCD == "WEIGHT" ~ "kg",
      VSTESTCD == "BMI" ~ "kg/m2",
      VSTESTCD == "WSTCIR" ~ "cm",
      VSTESTCD == "HIPCIR" ~ "cm",
      VSTESTCD == "HEIGHT" ~ "cm",
      TRUE ~ VSORRESU
    ),
    VSSTRESC = as.character(VSSTRESN),
    VSORRES = VSSTRESC,
    VSSTRESU = VSORRESU,
  ) %>%
  arrange(USUBJID, VSTESTCD, VISITNUM, VSDY)

# get common column names
common_cols <- intersect(names(vs_mb), names(vs))

# assign labels to mb_vs
walk(common_cols, \(x) attr(vs_mb[[x]], "label") <<- attr(vs[[x]], "label"))

# Ordering columns as per vs dataset
vs_metabolic <- vs_mb[, colnames(vs)]

# Label VS dataset ----
attr(vs_metabolic, "label") <- "Vital Signs"

# Save dataset ----
usethis::use_data(vs_metabolic, overwrite = TRUE)
