# Dataset: nv_neuro
# Description: Create NV test SDTM dataset for Alzheimer's Disease (neuro studies)

#' @importFrom tibble tibble
#' @importFrom dplyr filter rename select distinct group_by ungroup mutate arrange
#' left_join case_when if_else bind_rows row_number n_distinct dense_rank
#' @importFrom admiral convert_blanks_to_na
#' @importFrom lubridate days ymd
#' @importFrom usethis use_data
#' @noRd

# Read input data ----

data("dm_neuro")

# Convert blank to NA ----

dm_neuro <- admiral::convert_blanks_to_na(dm_neuro)

# Separate placebo and observation from treatment group to mimic different disease progression ----

placebo_group <- dm_neuro |>
  dplyr::filter(!is.na(ARMCD) & ARMCD == "Pbo")

treatment_group <- dm_neuro |>
  dplyr::filter(!is.na(ARMCD) & ARMCD == "Xan_Hi")

observation_group <- dm_neuro |>
  dplyr::filter(is.na(ARMCD) & ARMNRS == "Observational Study")

# Leverage VS visits at BASELINE, WEEK12 and WEEK26

visit_schedule <- pharmaversesdtm::vs |>
  dplyr::filter(USUBJID %in% dm_neuro$USUBJID) |>
  dplyr::filter(VISITNUM %in% c(3.0, 9.0, 13.0)) |>
  dplyr::rename(NVDTC = VSDTC, NVDY = VSDY) |>
  dplyr::select(USUBJID, VISITNUM, VISIT, VISITDY, NVDTC, NVDY) |>
  dplyr::group_by(USUBJID) |>
  dplyr::distinct()

# All USUBJID have BASELINE but not all have visits 9 or 13 data

visit9_usubjid <- visit_schedule |>
  dplyr::filter(VISITNUM == 9) |>
  dplyr::select(USUBJID) |>
  dplyr::distinct() |>
  unlist()

visit13_usubjid <- visit_schedule |>
  dplyr::filter(VISITNUM == 13) |>
  dplyr::distinct() |>
  unlist()

# Create records for one USUBJID ----

create_records_for_one_id <- function(usubjid = "01-701-1015", amy_tracer = "FBP", vendor = "AVID",
                                      visitnum = 3, amy_suvr_value, tau_suvr_value) {
  tibble::tibble(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "NV",
    USUBJID = usubjid,
    SUBJID = sub(".*-", "", usubjid),
    NVTESTCD = c("VR", "SUVR", "SUVR"),
    NVTEST = c(
      "Qualitative Visual Classification",
      "Standardized Uptake Value Ratio",
      "Standardized Uptake Value Ratio"
    ),
    NVCAT = c(amy_tracer, amy_tracer, "FTP"),
    NVORRES = c("Positive", as.character(amy_suvr_value), as.character(tau_suvr_value)),
    NVLOC = c(NA_character_, "NEOCORTICAL COMPOSITE", "NEOCORTICAL COMPOSITE"),
    NVNAM = c("IXICO", vendor, vendor),
    NVMETHOD = c(
      paste(amy_tracer, "VISUAL CLASSIFICATION"),
      paste(vendor, amy_tracer, "SUVR PIPELINE"),
      paste(vendor, "FTP", "SUVR PIPELINE")
    ),
    VISITNUM = visitnum
  )
}

# Create dataset for visit 3 (baseline) for all ids from dm_neuro ----

# Set the seed for reproducibility
set.seed(2774)

# Generate the data using lapply
all_visit3_dat <- dplyr::bind_rows(
  lapply(dm_neuro$USUBJID, function(id) {
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

    # Create the dataset using create_records_for_one_id function
    create_records_for_one_id(
      usubjid = id,
      amy_tracer = amy_tracer,
      vendor = vendor,
      visitnum = 3,
      amy_suvr_value = suvr_value,
      tau_suvr_value = ftp_suvr_icbgm
    )
  })
)

# Create visit 9 dataset for placebo and observational groups ----

pbo_obs_visit9_dat <- all_visit3_dat |>
  dplyr::filter(USUBJID %in% c(placebo_group$USUBJID, observation_group$USUBJID)) |>
  dplyr::filter(NVTESTCD == "SUVR") |>
  dplyr::mutate(
    VISITNUM = 9,
    NVORRES = as.character(round(as.numeric(NVORRES) + runif(1, min = 0.1, max = 0.2), 3)),
    NVORRES
  )

# Create visit 9 dataset for treatment group ----

treat_visit9_dat <- all_visit3_dat |>
  dplyr::filter(USUBJID %in% treatment_group$USUBJID) |>
  dplyr::filter(NVTESTCD == "SUVR") |>
  dplyr::mutate(
    VISITNUM = 9,
    NVORRES = dplyr::if_else(NVCAT %in% c("FBP", "FBB"),
      as.character(round(as.numeric(NVORRES) - runif(1, min = 0.3, max = 0.8), 3)),
      dplyr::if_else(NVCAT == "FTP",
        as.character(round(as.numeric(NVORRES) - runif(1, min = 0.005, max = 0.01), 3)), NVORRES
      )
    )
  )

# Create visit 13 dataset for placebo and observational groups ----

pbo_obs_visit13_dat <- pbo_obs_visit9_dat |>
  dplyr::filter(NVTESTCD == "SUVR") |>
  dplyr::mutate(
    VISITNUM = 13,
    NVORRES = as.character(round(as.numeric(NVORRES) + runif(1, min = 0.2, max = 0.3), 3)),
    NVORRES
  )

# Create visit 13 dataset for treatment group ----

treat_visit13_dat <- treat_visit9_dat |>
  dplyr::filter(NVTESTCD == "SUVR") |>
  dplyr::mutate(
    VISITNUM = 13,
    NVORRES = dplyr::if_else(NVCAT %in% c("FBP", "FBB"),
      as.character(round(as.numeric(NVORRES) - runif(1, min = 0.3, max = 0.8), 3)),
      dplyr::if_else(NVCAT == "FTP",
        as.character(round(as.numeric(NVORRES) - runif(1, min = 0.01, max = 0.05), 3)), NVORRES
      )
    )
  )

# Combine datasets and add additional variables ----

all_dat <- dplyr::bind_rows(
  all_visit3_dat,
  pbo_obs_visit9_dat |>
    dplyr::filter(USUBJID %in% visit9_usubjid),
  treat_visit9_dat |>
    dplyr::filter(USUBJID %in% visit9_usubjid),
  pbo_obs_visit13_dat |>
    dplyr::filter(USUBJID %in% visit13_usubjid),
  treat_visit13_dat |>
    dplyr::filter(USUBJID %in% visit13_usubjid)
) |>
  dplyr::mutate(
    NVLOBXFL = dplyr::if_else(VISITNUM == 3, "Y", NA_character_),
    NVORRESU = dplyr::if_else(NVTESTCD == "SUVR",
      "RATIO", NA
    ),
    NVSTRESC = NVORRES,
    NVSTRESN = dplyr::if_else(NVTESTCD == "SUVR",
      suppressWarnings(as.numeric(NVORRES)), NA
    ),
    NVSTRESU = dplyr::if_else(NVTESTCD == "SUVR",
      "RATIO", NA
    )
  ) |>
  dplyr::left_join(
    visit_schedule,
    by = c("USUBJID", "VISITNUM")
  ) |>
  # Differentiate Tau tracer visit dates from Amyloid tracer visit dates for realism
  dplyr::group_by(USUBJID, VISIT) |>
  dplyr::mutate(
    rand_diff = sample(2:4, 1),
    rand_sign = sample(c(-1, 1), size = 1)
  ) |>
  dplyr::mutate(
    # Apply a random difference of between +/- 2 to 4 days to visit date for Tau tracer
    # assessments. For baseline only subtraction is done
    NVDTC = dplyr::case_when(
      NVCAT == "FTP" & VISIT == "BASELINE" ~ as.character(lubridate::ymd(NVDTC) -
        lubridate::days(rand_diff)),
      NVCAT == "FTP" & VISIT != "BASELINE" ~ as.character(lubridate::ymd(NVDTC) +
        rand_sign * lubridate::days(rand_diff)),
      TRUE ~ NVDTC
    ),
    VISITDY = dplyr::case_when(
      NVCAT == "FTP" & VISIT == "BASELINE" ~ VISITDY - rand_diff,
      NVCAT == "FTP" & VISIT != "BASELINE" ~ VISITDY + rand_sign * rand_diff,
      TRUE ~ VISITDY
    ),
    NVDY = dplyr::case_when(
      NVCAT == "FTP" & VISIT == "BASELINE" ~ NVDY - rand_diff,
      NVCAT == "FTP" & VISIT != "BASELINE" ~ NVDY + rand_sign * rand_diff,
      TRUE ~ NVDY
    )
  ) |>
  dplyr::ungroup() |>
  dplyr::group_by(USUBJID) |>
  dplyr::mutate(NVSEQ = dplyr::row_number()) |>
  dplyr::ungroup() |>
  dplyr::arrange(USUBJID, VISIT) |>
  dplyr::group_by(USUBJID) |>
  dplyr::mutate(
    NVLNKID = match(NVCAT, c("FBP", "FBB", "FTP")) +
      (dplyr::n_distinct(NVCAT) * (dplyr::dense_rank(VISIT) - 1))
  ) |>
  dplyr::ungroup() |>
  dplyr::select(
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
