# Dataset: dm_metabolic
# Description: Crate DM test SDTM dataset for metabolic studies

# Load libraries ----
library(dplyr)
library(admiral)
library(purrr)

# Import DM data from `pharmaversesdtm` ----
dm <- pharmaversesdtm::dm

# Subset to first 5 subjects ----
dm_subset <- dm %>%
  filter(USUBJID %in% c(
    "01-701-1015", "01-701-1023", "01-701-1028",
    "01-701-1033", "01-701-1034"
  ))

# Change treatment arms ----
dm_metabolic <- dm_subset %>%
  mutate(
    ARMCD = case_when(
      ARMCD == "Pbo" ~ "Pbo",
      ARMCD %in% c("Xan_Hi", "Xan_Lo") ~ "Ins"
    ),
    ARM = case_when(
      ARM == "Placebo" ~ "Placebo",
      ARM %in% c(
        "Xanomeline High Dose",
        "Xanomeline Low Dose"
      ) ~ "Insulin"
    ),
    ACTARMCD = ARMCD,
    ACTARM = ARM
  )

# Restore attributes ----
common_cols <- intersect(names(dm_metabolic), names(dm))
walk(
  .x = common_cols,
  .f = \(x) attr(dm_metabolic[[x]], "label") <<- attr(dm[[x]], "label")
)

# Save data inside data folder----
usethis::use_data(dm_metabolic, overwrite = TRUE)
