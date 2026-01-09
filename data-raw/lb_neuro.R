# Dataset: lb_neuro
# Description: Create LB test SDTM dataset for Alzheimer's Disease (Neuro)

# Load libraries
library(admiral)
library(dplyr)
library(cli)

# Print numeric numbers in regular decimal format
options(scipen = 999)

# Read input data
dm_neuro <- pharmaversesdtm::dm_neuro
nv_neuro <- pharmaversesdtm::nv_neuro

# Convert blank to NA
dm_neuro <- convert_blanks_to_na(dm_neuro)
nv_neuro <- convert_blanks_to_na(nv_neuro)

# Select patients from DM Neuro only (following adsl_neuro.R pattern)
# Separate randomized group to identify which subjects don't have planned study days
randomized_group <- dm_neuro %>%
  # Subjects with non-missing ARMNRS are randomized, otherwise from observational study
  filter(is.na(ARMNRS)) %>%
  select(USUBJID) %>%
  pull()

# Get visit schedule from NV data for all visits
visit_schedule <- nv_neuro %>%
  filter(VISIT == "BASELINE") %>%
  select(USUBJID, VISITNUM, VISIT, NVDTC, NVDY) %>%
  group_by(USUBJID, VISIT) %>%
  arrange(as.Date(NVDTC)) %>%
  slice(1) %>%
  ungroup() %>%
  rename(LBDTC = NVDTC, LBDY = NVDY) %>%
  mutate(
    VISITDY = if_else(
      USUBJID %in% randomized_group,
      as.numeric(LBDY),
      NA_real_
    ),
    LBDTC = as.character(LBDTC)
  ) %>%
  distinct()

# Alpha Synuclein data generation

# Get subject characteristics with treatment information from dm_neuro ----
subject_chars <- dm_neuro %>%
  select(STUDYID, USUBJID, ARM, ARMCD) %>%
  mutate( # Create treatment groups for analysis (pattern as in nv_neuro.R)
    TRTGRP = case_when(
      ARM == "Placebo" ~ "PLACEBO_CONTROL",
      ARMCD == "Pbo" ~ "PLACEBO_CONTROL",
      ARMCD == "Xan_Hi" ~ "TREATMENT",
      is.na(ARMCD) ~ "PLACEBO_CONTROL"
    )
  )

# Create Alpha Synuclein Seed Amplification Assay record for one subject-visit ----
create_asyn_record <- function(usubjid, visitnum, visit, visitdy, lbdtc, lbdy, trtgrp) {
  # Define positive rates based on treatment group and visit
  pos_rate <- case_when(
    trtgrp == "PLACEBO_CONTROL" ~ 0.30, # 30% positive for placebo/control at all visits
    trtgrp == "TREATMENT" & visit == "BASELINE" ~ 0.30, # Assume baseline similar for all
    TRUE ~ 0.00 # Default
  )

  # Generate SAA result based on positive rate
  lborres <- if (runif(1) < pos_rate) "Positive" else "Negative"

  tibble(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "LB",
    USUBJID = usubjid,
    LBSEQ = "missing",
    LBTESTCD = "ASYNASAA",
    LBTEST = "Alpha Synuclein Seed Amplification Assay (CSF)",
    LBCAT = "Biomarkers",
    LBORRES = lborres,
    LBORRESU = NA_character_,
    LBORNRLO = NA_character_,
    LBORNRHI = NA_character_,
    LBSTRESC = lborres,
    LBSTRESN = case_when(
      lborres == "Positive" ~ 1,
      lborres == "Negative" ~ 0,
      TRUE ~ NA_real_
    ),
    LBSTRESU = NA_character_,
    LBSTNRLO = NA_real_,
    LBSTNRHI = NA_real_,
    LBNRIND = NA_character_,
    LBBLFL = ifelse(visit == "BASELINE", "Y", NA_character_),
    VISITNUM = visitnum,
    VISIT = visit,
    VISITDY = visitdy,
    LBDTC = lbdtc,
    LBDY = lbdy
  )
}

# Set seed for reproducibility
set.seed(2774)

# Generate Alpha Synuclein LB records
asyn_records <- visit_schedule %>%
  left_join(subject_chars, by = c("USUBJID")) %>%
  rowwise() %>%
  do(
    create_asyn_record(
      usubjid = .$USUBJID,
      visitnum = .$VISITNUM,
      visit = .$VISIT,
      visitdy = .$VISITDY,
      lbdtc = .$LBDTC,
      lbdy = .$LBDY,
      trtgrp = .$TRTGRP
    )
  ) %>%
  ungroup()

# pTau, Amyloid, and Ratio data generation
# Input amyloid data from admiralneuro.adapet - ensure the data is accurate
visit_all <- tribble(
  ~USUBJID, ~CRIT1FL, ~CRIT1, ~VISITNUM, ~VISIT, ~LBDTC, ~LBDY,
  "01-701-1015", "N", "CENTILOID < 24.1", 0, "BASELINE", "2014-01-02", 1,
  "01-701-1015", "N", "CENTILOID < 24.1", 12, "WEEK 12", "2014-03-26", 84,
  "01-701-1015", "N", "CENTILOID < 24.1", 26, "WEEK 26", "2014-07-02", 182,
  "01-701-1023", "N", "CENTILOID < 24.1", 0, "BASELINE", "2012-08-05", 1,
  "01-701-1028", "N", "CENTILOID < 24.1", 0, "BASELINE", "2013-07-19", NA,
  "01-701-1028", "N", "CENTILOID < 24.1", 12, "WEEK 12", "2013-10-09", NA,
  "01-701-1028", "N", "CENTILOID < 24.1", 26, "WEEK 26", "2014-01-14", NA,
  "01-701-1034", "N", "CENTILOID < 24.1", 0, "BASELINE", "2014-07-01", 1,
  "01-701-1034", "N", "CENTILOID < 24.1", 12, "WEEK 12", "2014-09-25", 87,
  "01-701-1034", "N", "CENTILOID < 24.1", 26, "WEEK 26", "2014-12-30", 183,
  "01-701-1146", "N", "CENTILOID < 24.1", 0, "BASELINE", "2013-05-20", 1,
  "01-701-1153", "N", "CENTILOID < 24.1", 0, "BASELINE", "2013-09-23", 1,
  "01-701-1153", "N", "CENTILOID < 24.1", 12, "WEEK 12", "2013-12-16", 85,
  "01-701-1153", "N", "CENTILOID < 24.1", 26, "WEEK 26", "2014-04-01", 191,
  "01-701-1181", "N", "CENTILOID < 24.1", 0, "BASELINE", "2013-12-05", NA,
  "01-701-1234", "N", "CENTILOID < 24.1", 0, "BASELINE", "2013-03-30", 1,
  "01-701-1234", "N", "CENTILOID < 24.1", 12, "WEEK 12", "2013-07-07", 100,
  "01-701-1234", "N", "CENTILOID < 24.1", 26, "WEEK 26", "2013-09-22", 177,
  "01-701-1275", "N", "CENTILOID < 24.1", 0, "BASELINE", "2014-02-07", 1,
  "01-701-1275", "N", "CENTILOID < 24.1", 12, "WEEK 12", "2014-05-03", 86,
  "01-701-1302", "N", "CENTILOID < 24.1", 0, "BASELINE", "2013-08-29", 1,
  "01-701-1302", "Y", "CENTILOID < 24.1", 12, "WEEK 12", "2013-11-05", 69,
  "01-701-1345", "N", "CENTILOID < 24.1", 0, "BASELINE", "2013-10-08", NA,
  "01-701-1345", "N", "CENTILOID < 24.1", 12, "WEEK 12", "2013-12-31", NA,
  "01-701-1360", "N", "CENTILOID < 24.1", 0, "BASELINE", "2013-07-31", NA,
  "01-701-1383", "N", "CENTILOID < 24.1", 0, "BASELINE", "2013-02-04", 1,
  "01-701-1383", "N", "CENTILOID < 24.1", 12, "WEEK 12", "2013-04-30", 86,
  "01-701-1383", "Y", "CENTILOID < 24.1", 26, "WEEK 26", "2013-08-06", 184,
  "01-701-1392", "N", "CENTILOID < 24.1", 0, "BASELINE", "2012-10-28", 1,
  "01-701-1392", "N", "CENTILOID < 24.1", 12, "WEEK 12", "2013-01-20", 85,
  "01-701-1392", "N", "CENTILOID < 24.1", 26, "WEEK 26", "2013-04-28", 183,
  "01-714-1288", "N", "CENTILOID < 24.1", 0, "BASELINE", "2013-12-04", NA,
  "01-714-1288", "N", "CENTILOID < 24.1", 12, "WEEK 12", "2014-03-02", NA,
  "01-714-1288", "N", "CENTILOID < 24.1", 26, "WEEK 26", "2014-06-17", NA
)

# Create LB record for one subject-visit with pTau, Amyloid, and Ratio ----
create_ratio_record <- function(
  usubjid,
  visitnum,
  visit,
  visitdy,
  lbdtc,
  lbdy,
  trtgrp,
  crit1fl
) {
  set.seed(as.numeric(gsub("\\D", "", usubjid)) + visitnum)

  # Generate Aβ42 plasma  ----
  amyloid_value <- runif(1, 80, 1200) # pg/mL

  # Generate pTau conditional on crit1fl status
  ptau_value <- case_when(
    crit1fl == "Y" ~ runif(1,
      min = 0.0015 * amyloid_value,
      max = 0.00370 * amyloid_value
    ),
    crit1fl == "N" ~ runif(1,
      min = 0.00738 * amyloid_value,
      max = 0.0120 * amyloid_value
    ),
    TRUE ~ runif(1,
      min = 0.00371 * amyloid_value,
      max = 0.00737 * amyloid_value
    )
  )

  # Placebo / Untreated stability
  if (trtgrp %in% c("Placebo", "No Treatment") && visit != "BASELINE") {
    ptau_value <- ptau_value * runif(1, 0.98, 1.02)
    amyloid_value <- amyloid_value * runif(1, 0.98, 1.02)
  }

  # add Intermediate cases
  make_intermediate <- runif(1) < 0.15 # ~15% of visits

  if (make_intermediate) {
    # Force ratio into intermediate band
    ratio_target <- runif(1, 0.00371, 0.00737)

    # Adjust pTau (Aβ42 unchanged)
    ptau_value <- ratio_target * amyloid_value
  }

  # Derive ratio
  ratio_value <- ptau_value / amyloid_value

  # Interpretation
  ratio_lbnrind <- case_when(
    ratio_value <= 0.00370 ~ "Negative",
    ratio_value >= 0.00738 ~ "Positive",
    TRUE ~ "Indeterminate"
  )

  # ---- pTau record ----
  ptau_record <- tibble(
    STUDYID   = "CDISCPILOT01",
    DOMAIN    = "LB",
    USUBJID   = usubjid,
    LBTESTCD  = "PTAU217",
    LBTEST    = "Lumipulse G pTau 217 Plasma",
    LBCAT     = "Biomarkers",
    LBORRES   = sprintf("%.4f", ptau_value),
    LBORRESU  = "pg/mL",
    LBSTRESC  = sprintf("%.4f", ptau_value),
    LBSTRESN  = ptau_value,
    LBSTRESU  = "pg/mL",
    LBBLFL    = ifelse(visit == "BASELINE", "Y", NA_character_),
    VISITNUM  = visitnum,
    VISIT     = visit,
    VISITDY   = visitdy,
    LBDTC     = lbdtc,
    LBDY      = lbdy
  )

  # ---- Aβ42 record ----
  amyloid_record <- tibble(
    STUDYID   = "CDISCPILOT01",
    DOMAIN    = "LB",
    USUBJID   = usubjid,
    LBTESTCD  = "AMYLB42",
    LBTEST    = "Lumipulse G Beta-Amyloid 1-42-N Plasma",
    LBCAT     = "Biomarkers",
    LBORRES   = sprintf("%.1f", amyloid_value),
    LBORRESU  = "pg/mL",
    LBSTRESC  = sprintf("%.1f", amyloid_value),
    LBSTRESN  = amyloid_value,
    LBSTRESU  = "pg/mL",
    LBBLFL    = ifelse(visit == "BASELINE", "Y", NA_character_),
    VISITNUM  = visitnum,
    VISIT     = visit,
    VISITDY   = visitdy,
    LBDTC     = lbdtc,
    LBDY      = lbdy
  )

  # ---- Ratio record ----
  ratio_record <- tibble(
    STUDYID   = "CDISCPILOT01",
    DOMAIN    = "LB",
    USUBJID   = usubjid,
    LBTESTCD  = "PTAB42R",
    LBTEST    = "Lumipulse G pTau 217/Beta-Amyloid 1-42 Plasma Ratio",
    LBCAT     = "Biomarkers",
    LBORRES   = sprintf("%.5f", ratio_value),
    LBORNRLO  = "0.00370",
    LBORNRHI  = "0.00738",
    LBSTRESC  = sprintf("%.5f", ratio_value),
    LBSTRESN  = ratio_value,
    LBSTNRLO  = 0.00370,
    LBSTNRHI  = 0.00738,
    LBNRIND   = ratio_lbnrind,
    LBBLFL    = ifelse(visit == "BASELINE", "Y", NA_character_),
    VISITNUM  = visitnum,
    VISIT     = visit,
    VISITDY   = visitdy,
    LBDTC     = lbdtc,
    LBDY      = lbdy
  )

  bind_rows(ptau_record, amyloid_record, ratio_record)
}

# Generate all LB pTau, Amyloid and corresponding Ratio's records by joining 'visit_schedule' and 'subject_chars' ----
ratio_records <- visit_all %>%
  left_join(subject_chars, by = "USUBJID") %>%
  rowwise() %>%
  do(
    create_ratio_record(
      usubjid  = .$USUBJID,
      visitnum = .$VISITNUM,
      visit    = .$VISIT,
      visitdy  = .$LBDY,
      lbdtc    = .$LBDTC,
      lbdy     = .$LBDY,
      trtgrp   = .$TRTGRP,
      crit1fl  = .$CRIT1FL
    )
  ) %>%
  ungroup()

# Add sequence numbers and finalize
lb_neuro <- bind_rows(asyn_records, ratio_records) %>%
  arrange(USUBJID, VISITNUM) %>%
  group_by(USUBJID) %>%
  mutate(LBSEQ = row_number()) %>%
  ungroup() %>%
  select(
    STUDYID, DOMAIN, USUBJID, LBSEQ, LBTESTCD, LBTEST, LBCAT,
    LBORRES, LBORRESU, LBORNRLO, LBORNRHI, LBSTRESC, LBSTRESN,
    LBSTRESU, LBSTNRLO, LBSTNRHI, LBNRIND, LBBLFL,
    VISITNUM, VISIT, VISITDY, LBDTC, LBDY
  )

# Validation checks
expected_visits <- c("BASELINE", "WEEK 12", "WEEK 26")

# Check if all VISIT values are in the expected set
if (!all(lb_neuro$VISIT %in% expected_visits)) {
  cli_abort("The values in 'lb_neuro$VISIT' are not all in the expected 'expected_visits'.")
}

# Check if LBORRES values are either "Positive" or "Negative"
ASYNASAA_data <- lb_neuro[lb_neuro$LBTESTCD == "ASYNASAA", ]
if (!all(ASYNASAA_data$LBORRES %in% c("Positive", "Negative"))) {
  cli_abort(
    message = "For LBTESTCD = ASYNASAA, the values in 'LBORRES' must be either 'Positive' or 'Negative'."
  )
}

# Check if LBTESTCD values have more than 8 characters
if (!all(nchar(lb_neuro$LBTESTCD) <= 8)) {
  cli_abort("The length of values in 'lb_neuro$LBTESTCD' must not exceed 8 characters.")
}

# Check for one record per subject per visit
visit_counts <- lb_neuro %>%
  count(USUBJID, LBTESTCD, VISIT) %>%
  filter(n > 1)

if (nrow(visit_counts) > 0) {
  warning("Duplicate records found for some subjects/visits")
}

# Assign labels for lb_neuro variables
labels <- list(
  STUDYID = "Study Identifier",
  DOMAIN = "Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  LBSEQ = "Sequence Number",
  LBTESTCD = "Lab Test or Examination Short Name",
  LBTEST = "Lab Test or Examination Name",
  LBCAT = "Category for Lab Test",
  LBORRES = "Result or Finding in Original Units",
  LBORRESU = "Original Units",
  LBORNRLO = "Reference Range Lower Limit in Orig Unit",
  LBORNRHI = "Reference Range Upper Limit in Orig Unit",
  LBSTRESC = "Character Result/Finding in Std Format",
  LBSTRESN = "Numeric Result/Finding in Standard Units",
  LBSTRESU = "Standard Units",
  LBSTNRLO = "Reference Range Lower Limit-Std Units",
  LBSTNRHI = "Reference Range Upper Limit-Std Units",
  LBNRIND = "Reference Range Indicator",
  LBBLFL = "Baseline Flag",
  VISITNUM = "Visit Number",
  VISIT = "Visit Name",
  VISITDY = "Planned Study Day of Visit",
  LBDTC = "Date/Time of Specimen Collection",
  LBDY = "Study Day of Specimen Collection"
)

for (var in names(labels)) {
  attr(lb_neuro[[var]], "label") <- labels[[var]]
}

# Label dataset
attr(lb_neuro, "label") <- "Laboratory Test Results Dataset"

# Save dataset
usethis::use_data(lb_neuro, overwrite = TRUE)
