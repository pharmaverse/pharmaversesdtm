# Dataset: dm_neuro
# Description: Create DM test SDTM dataset for Alzheimer's Disease (Neuro)

library(admiral)
library(dplyr)
library(lubridate)

# Read input test data from pharmaversesdtm ----
dm <- pharmaversesdtm::dm

# Convert blank to NA ----
dm <- convert_blanks_to_na(dm)

# Subset to 15 patients
dm_neuro <- dm |>
  filter(USUBJID %in% c(
    "01-701-1015", "01-701-1023", "01-701-1028", "01-701-1034",
    "01-701-1146", "01-701-1153", "01-701-1181", "01-701-1234",
    "01-701-1275", "01-701-1302", "01-701-1345", "01-701-1360",
    "01-701-1383", "01-701-1392", "01-714-1288"
  ))

# Create a vector of USUBJID values to modify
usubjid_to_modify <- c(
  "01-701-1345", "01-714-1288", "01-701-1028",
  "01-701-1181", "01-701-1360"
)

# Store the labels before modifying
var_labels <- lapply(dm_neuro, function(x) attr(x, "label"))

# Modify the dataset
dm_neuro <- dm_neuro |>
  mutate(
    across(c(ARMCD, ARM, ACTARMCD, ACTARM, RFXSTDTC, RFXENDTC),
      ~ if_else(USUBJID %in% usubjid_to_modify, NA_character_, .),
      .names = "{.col}"
    ),
    ARMNRS = case_when(
      USUBJID %in% usubjid_to_modify ~ "Observational Study",
      TRUE ~ NA_character_
    ),

    # Convert RFSDTC from char to date, -2 days, and convert back to char
    RFICDTC = if_else(
      !is.na(RFSTDTC), # Check if RFSDTC is not NA
      as.character(as.Date(RFSTDTC, format = "%Y-%m-%d") - lubridate::days(2)),
      NA_character_ # Return NA if RFSDTC is NA
    )
  )

# Restore the labels after modification
for (col in names(var_labels)) {
  attr(dm_neuro[[col]], "label") <- var_labels[[col]]
}

# Assign the label for ARMNRS
attr(dm_neuro$ARMNRS, "label") <- "Reason Arm and/or Actual Arm is Null"

# Label dataset ----
attr(dm_neuro, "label") <- "Demographics"
attr(dm_neuro, "variable.labels") <- var_labels

# Save dataset ----
usethis::use_data(dm_neuro, overwrite = TRUE)
