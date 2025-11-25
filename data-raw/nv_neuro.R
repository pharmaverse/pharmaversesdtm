# Dataset: nv_neuro
# Description: Create NV test SDTM dataset for Alzheimer's Disease (neuro studies)

library(admiral)
library(dplyr)
library(lubridate)
library(tibble)

# Read input data ----

data("dm_neuro")

# Convert blank to NA ----

dm_neuro <- convert_blanks_to_na(dm_neuro)

# Separate placebo and observation from treatment group to mimic different disease progression ----

placebo_group <- dm_neuro %>%
  filter(!is.na(ARMCD) & ARMCD == "Pbo")

treatment_group <- dm_neuro %>%
  filter(!is.na(ARMCD) & ARMCD == "Xan_Hi")

observation_group <- dm_neuro %>%
  filter(is.na(ARMCD) & ARMNRS == "Observational Study")

# Leverage VS visits at BASELINE, WEEK12 and WEEK26

visit_schedule <- pharmaversesdtm::vs %>%
  filter(USUBJID %in% dm_neuro$USUBJID) %>%
  filter(VISITNUM %in% c(3.0, 9.0, 13.0)) %>%
  rename(NVDTC = VSDTC, NVDY = VSDY) %>%
  select(USUBJID, VISITNUM, VISIT, VISITDY, NVDTC, NVDY) %>%
  group_by(USUBJID) %>%
  distinct()

# All USUBJID have BASELINE but not all have visits 9 or 13 data

visit9_usubjid <- visit_schedule %>%
  filter(VISITNUM == 9) %>%
  select(USUBJID) %>%
  distinct() %>%
  unlist()

visit13_usubjid <- visit_schedule %>%
  filter(VISITNUM == 13) %>%
  distinct() %>%
  unlist()

# Create records for one USUBJID ----

create_records_for_one_id <- function(usubjid = "01-701-1015", amy_tracer = "FBP", vendor = "AVID",
                                      visitnum = 3, amy_suvr_value, tau_suvr_value, upsit_value) {
  tibble::tibble(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "NV",
    USUBJID = usubjid,
    SUBJID = sub(".*-", "", usubjid),
    NVTESTCD = c("VR", "SUVR", "SUVR", "UPSIT"),
    NVTEST = c(
      "Qualitative Visual Classification",
      "Standardized Uptake Value Ratio",
      "Standardized Uptake Value Ratio",
      "University of Pennsylvania Smell Identification Test"
    ),
    NVCAT = c(amy_tracer, amy_tracer, "FTP", "OLFACTORY FUNCTION"),
    NVORRES = c("Positive", as.character(amy_suvr_value), as.character(tau_suvr_value), as.character(upsit_value)),
    NVLOC = c(NA_character_, "NEOCORTICAL COMPOSITE", "NEOCORTICAL COMPOSITE", NA_character_),
    NVNAM = c("IXICO", vendor, vendor, "Sensonics International"),
    NVMETHOD = c(
      paste(amy_tracer, "VISUAL CLASSIFICATION"),
      paste(vendor, amy_tracer, "SUVR PIPELINE"),
      paste(vendor, "FTP", "SUVR PIPELINE"),
      NA_character_
    ),
    VISITNUM = visitnum
  )
}

# Create dataset for visit 3 (baseline) for all ids from dm_neuro ----

# Set the seed for reproducibility
set.seed(2774)

# Generate the data using lapply
all_visit3_dat <- bind_rows(
  lapply(seq_len(nrow(dm_neuro)), function(i) {
    id <- dm_neuro$USUBJID[i]
    sex <- dm_neuro$SEX[i]

    # Generate random values for the parameters
    amy_tracer <- sample(c("FBP", "FBB"), size = 1)
    vendor <- sample(c("AVID", "BERKELEY"), size = 1)

    fbp_suvr_cb <- round(runif(1, 1.25, 2.5), 3)
    fbb_suvr_com <- round(fbp_suvr_cb - runif(1, min = 0.005, max = 0.01), 3)
    ftp_suvr_icbgm <- round(fbp_suvr_cb - runif(1, min = 0.1, max = 0.13), 3)

    if (amy_tracer == "FBP") {
      suvr_value <- fbp_suvr_cb
    } else if (amy_tracer == "FBB") {
      suvr_value <- fbb_suvr_com
    }

    upsit_cat <- runif(1, 0, 1)

    if (upsit_cat <= 0.05) {
      if (sex == "F") {
        upsit_value <- sample(35:40, 1, replace = TRUE)
      } else if (sex == "M") {
        upsit_value <- sample(34:40, 1, replace = TRUE)
      }
    } else if (upsit_cat <= 0.1) {
      if (sex == "F") {
        upsit_value <- sample(31:34, 1, replace = TRUE)
      } else if (sex == "M") {
        upsit_value <- sample(30:33, 1, replace = TRUE)
      }
    } else if (upsit_cat <= 0.2) {
      if (sex == "F") {
        upsit_value <- sample(26:30, 1, replace = TRUE)
      } else if (sex == "M") {
        upsit_value <- sample(26:29, 1, replace = TRUE)
      }
    } else if (upsit_cat <= 0.3) {
      upsit_value <- sample(19:25, 1, replace = TRUE)
    } else {
      upsit_value <- sample(0:18, 1, replace = TRUE)
    }

    # Create the dataset using create_records_for_one_id function
    create_records_for_one_id(
      usubjid = id,
      amy_tracer = amy_tracer,
      vendor = vendor,
      visitnum = 3,
      amy_suvr_value = suvr_value,
      tau_suvr_value = ftp_suvr_icbgm,
      upsit_value = upsit_value
    )
  })
)

# Create visit 9 dataset for placebo and observational groups ----

pbo_obs_visit9_dat <- all_visit3_dat %>%
  filter(USUBJID %in% c(placebo_group$USUBJID, observation_group$USUBJID)) %>%
  filter(NVTESTCD == "SUVR") %>%
  mutate(
    VISITNUM = 9,
    NVORRES = as.character(round(as.numeric(NVORRES) + runif(1, min = 0.1, max = 0.2), 3)),
    NVORRES
  )

# Create visit 9 dataset for treatment group ----

treat_visit9_dat <- all_visit3_dat %>%
  filter(USUBJID %in% treatment_group$USUBJID) %>%
  filter(NVTESTCD == "SUVR") %>%
  mutate(
    VISITNUM = 9,
    NVORRES = if_else(NVCAT %in% c("FBP", "FBB"),
      as.character(round(as.numeric(NVORRES) - runif(1, min = 0.3, max = 0.8), 3)),
      if_else(NVCAT == "FTP",
        as.character(round(as.numeric(NVORRES) - runif(1, min = 0.005, max = 0.01), 3)), NVORRES
      )
    )
  )

# Create visit 13 dataset for placebo and observational groups ----

pbo_obs_visit13_dat <- pbo_obs_visit9_dat %>%
  filter(NVTESTCD == "SUVR") %>%
  mutate(
    VISITNUM = 13,
    NVORRES = as.character(round(as.numeric(NVORRES) + runif(1, min = 0.2, max = 0.3), 3)),
    NVORRES
  )

# Create visit 13 dataset for treatment group ----

treat_visit13_dat <- treat_visit9_dat %>%
  filter(NVTESTCD == "SUVR") %>%
  mutate(
    VISITNUM = 13,
    NVORRES = if_else(NVCAT %in% c("FBP", "FBB"),
      as.character(round(as.numeric(NVORRES) - runif(1, min = 0.3, max = 0.8), 3)),
      if_else(NVCAT == "FTP",
        as.character(round(as.numeric(NVORRES) - runif(1, min = 0.01, max = 0.05), 3)), NVORRES
      )
    )
  )

# Combine datasets and add additional variables ----

all_dat <- bind_rows(
  all_visit3_dat,
  pbo_obs_visit9_dat %>%
    filter(USUBJID %in% visit9_usubjid),
  treat_visit9_dat %>%
    filter(USUBJID %in% visit9_usubjid),
  pbo_obs_visit13_dat %>%
    filter(USUBJID %in% visit13_usubjid),
  treat_visit13_dat %>%
    filter(USUBJID %in% visit13_usubjid)
) %>%
  mutate(
    NVLOBXFL = if_else(VISITNUM == 3, "Y", NA_character_),
    NVORRESU = if_else(NVTESTCD == "SUVR",
      "RATIO", NA
    ),
    NVSTRESC = NVORRES,
    NVSTRESN = if_else(NVTESTCD %in% c("SUVR", "UPSIT"),
      suppressWarnings(as.numeric(NVORRES)), NA
    ),
    NVSTRESU = if_else(NVTESTCD == "SUVR",
      "RATIO", NA
    )
  ) %>%
  left_join(
    visit_schedule,
    by = c("USUBJID", "VISITNUM")
  ) %>%
  # Differentiate Tau tracer visit dates from Amyloid tracer visit dates for realism
  group_by(USUBJID, VISIT) %>%
  mutate(
    rand_diff = sample(2:4, 1),
    rand_sign = sample(c(-1, 1), size = 1)
  ) %>%
  mutate(
    # Apply a random difference of between +/- 2 to 4 days to visit date for Tau tracer
    # assessments. For baseline only subtraction is done
    NVDTC = case_when(
      NVCAT == "FTP" & VISIT == "BASELINE" ~ as.character(lubridate::ymd(NVDTC) -
        lubridate::days(rand_diff)),
      NVCAT == "FTP" & VISIT != "BASELINE" ~ as.character(lubridate::ymd(NVDTC) +
        rand_sign * lubridate::days(rand_diff)),
      TRUE ~ NVDTC
    ),
    VISITDY = case_when(
      NVCAT == "FTP" & VISIT == "BASELINE" ~ VISITDY - rand_diff,
      NVCAT == "FTP" & VISIT != "BASELINE" ~ VISITDY + rand_sign * rand_diff,
      TRUE ~ VISITDY
    ),
    NVDY = case_when(
      NVCAT == "FTP" & VISIT == "BASELINE" ~ NVDY - rand_diff,
      NVCAT == "FTP" & VISIT != "BASELINE" ~ NVDY + rand_sign * rand_diff,
      TRUE ~ NVDY
    )
  ) %>%
  ungroup() %>%
  group_by(USUBJID) %>%
  mutate(NVSEQ = row_number()) %>%
  ungroup() %>%
  arrange(USUBJID, VISIT) %>%
  group_by(USUBJID) %>%
  mutate(
    NVLNKID = match(NVCAT, c("FBP", "FBB", "FTP", "OLFACTORY FUNCTION")) +
      (n_distinct(NVCAT) * (dense_rank(VISIT) - 1))
  ) %>%
  ungroup() %>%
  select(
    STUDYID, DOMAIN, USUBJID, NVSEQ, NVLNKID,
    NVTESTCD, NVTEST, NVCAT,
    NVLOC, NVMETHOD, NVNAM,
    NVORRES, NVORRESU, NVSTRESC, NVSTRESN, NVSTRESU,
    VISITNUM, VISIT, NVDTC, NVDY,
    NVLOBXFL
  )

# Add labels to variables ----

labels <- list(
  # Identifier Variables (Key variables)
  STUDYID = "Study Identifier",
  DOMAIN = "Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  NVSEQ = "Sequence Number",
  NVLNKID = "Link ID",

  # Topic Variables\
  NVTESTCD = "Short Name of Nervous System Test",
  NVTEST = "Name of Nervous System Test",
  NVCAT = "Category for Nervous System Test",

  # Qualifier Variables
  NVLOC = "Location Used for the Measurement",
  NVMETHOD = "Method of Test or Examination",
  NVNAM = "Vendor Name",

  # Result Variables
  NVORRES = "Result or Finding in Original Units",
  NVORRESU = "Original Units",
  NVSTRESC = "Character Result/Finding in Std Format",
  NVSTRESN = "Numeric Result/Finding in Standard Units",
  NVSTRESU = "Standard Units",

  # Timing Variables
  VISITNUM = "Visit Number",
  VISIT = "Visit Name",
  NVDTC = "Date/Time of Collection",
  NVDY = "Study Day of Collection",

  # Additional Qualifier
  NVLOBXFL = "Last Observation Before Exposure Flag"
)

for (var in names(labels)) {
  attr(all_dat[[var]], "label") <- labels[[var]]
}

nv_neuro <- all_dat

# Label NV dataset ----

attr(nv_neuro, "label") <- "Nervous System Findings"

# Save dataset ----

usethis::use_data(nv_neuro, overwrite = TRUE)
