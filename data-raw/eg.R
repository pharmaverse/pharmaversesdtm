# Dataset: eg_test
# Description: Standard EG dataset from CDISC pilot study (includes random data)

# Load necessary libraries
library(dplyr)
library(labelled)

# Define constants and mappings
studyid <- "CDISCPILOT01"
domain <- "EG"
usubjids <-
  unique(vs$USUBJID) # Get unique subject IDs from vs data frame
egtestcds <- c("QT", "HR", "RR", "ECGINT")
visits <- c(
  "SCREENING 1",
  "SCREENING 2",
  "BASELINE",
  "AMBUL ECG PLACEMENT",
  "WEEK 2",
  "WEEK 4",
  "AMBUL ECG REMOVAL",
  "WEEK 6",
  "WEEK 8",
  "WEEK 12",
  "WEEK 16",
  "WEEK 20",
  "WEEK 24",
  "WEEK 26",
  "RETRIEVAL"
)
egtpts <- c(
  "AFTER LYING DOWN FOR 5 MINUTES",
  "AFTER STANDING FOR 1 MINUTE",
  "AFTER STANDING FOR 3 MINUTES"
)
visitnum_mapping <- c(
  "SCREENING 1" = 1,
  "SCREENING 2" = 2,
  "BASELINE" = 3,
  "AMBUL ECG PLACEMENT" = 3.5,
  "WEEK 2" = 4,
  "WEEK 4" = 5,
  "AMBUL ECG REMOVAL" = 6,
  "WEEK 6" = 7,
  "WEEK 8" = 8,
  "WEEK 12" = 9,
  "WEEK 16" = 10,
  "WEEK 20" = 11,
  "WEEK 24" = 12,
  "WEEK 26" = 13,
  "RETRIEVAL" = 201
)
visitdy_mapping <- c(
  "SCREENING 1" = -7,
  "SCREENING 2" = -1,
  "BASELINE" = 1,
  "AMBUL ECG PLACEMENT" = 13,
  "WEEK 2" = 14,
  "WEEK 4" = 28,
  "AMBUL ECG REMOVAL" = 30,
  "WEEK 6" = 42,
  "WEEK 8" = 56,
  "WEEK 12" = 84,
  "WEEK 16" = 112,
  "WEEK 20" = 140,
  "WEEK 24" = 168,
  "WEEK 26" = 182,
  "RETRIEVAL" = 168
)
egtptnum_mapping <- c(
  "AFTER LYING DOWN FOR 5 MINUTES" = 815,
  "AFTER STANDING FOR 1 MINUTE" = 816,
  "AFTER STANDING FOR 3 MINUTES" = 817
)
egeltm_mapping <- c(
  "AFTER LYING DOWN FOR 5 MINUTES" = "PT5M",
  "AFTER STANDING FOR 1 MINUTE" = "PT1M",
  "AFTER STANDING FOR 3 MINUTES" = "PT3M"
)
egtest_mapping <- c(
  "QT" = "QT Duration",
  "HR" = "Heart Rate",
  "RR" = "RR Duration",
  "ECGINT" = "ECG Interpretation"
)
egorresu_mapping <- c(
  "QT" = "mmHg",
  "HR" = "BEATS/MIN",
  "RR" = "mmHg",
  "ECGINT" = "LB"
)
egstresu_mapping <- c(
  "QT" = "msec",
  "HR" = "BEATS/MIN",
  "RR" = "msec",
  "ECGINT" = NA
)

# Extract unique date/time of measurements for each subject and visit
egdtc <- vs %>%
  select(USUBJID, VISIT, VSDTC) %>%
  distinct() %>%
  rename(EGDTC = VSDTC)

# Set seed for reproducibility
set.seed(123)

# Function to generate patient data
add_patient <- function(usubjid) {
  patient <- expand.grid(
    USUBJID = usubjid,
    EGTESTCD = egtestcds,
    EGTPT = egtpts,
    VISIT = visits
  ) %>%
    arrange(EGTESTCD) %>%
    group_by(VISIT) %>%
    filter(!(
      EGTESTCD == "ECGINT" &
        VISIT %in% c(
          "AMBUL ECG PLACEMENT",
          "AMBUL ECG REMOVAL",
          "RETRIEVAL",
          "SCREENING 2"
        )
    ) &
      !(EGTESTCD == "ECGINT" & duplicated(EGTESTCD))) %>%
    ungroup() %>%
    left_join(egdtc, by = c("USUBJID", "VISIT")) %>%
    filter(!is.na(EGDTC)) %>%
    mutate(
      STUDYID = studyid,
      DOMAIN = domain,
      EGSEQ = as.numeric(row_number()),
      # Generate sequence number
      EGTESTCD = as.character(EGTESTCD),
      EGTEST = egtest_mapping[EGTESTCD],
      EGORRESU = egorresu_mapping[EGTESTCD],
      EGELTM = ifelse(EGTESTCD == "ECGINT", "", egeltm_mapping[EGTPT]),
      # Generate random results based on test type and time point
      EGSTRESN = case_when(
        EGTESTCD == "RR" ~ floor(rnorm(
          n(), ifelse(
            EGELTM == "PT5M",
            543.9985,
            ifelse(EGELTM == "PT3M", 536.0161, 532.3233)
          ), 80
        )),
        EGTESTCD == "HR" ~ floor(rnorm(
          n(), ifelse(
            EGELTM == "PT5M",
            70.04389,
            ifelse(EGELTM == "PT3M", 74.27798, 74.77461)
          ), 8
        )),
        EGTESTCD == "QT" ~ floor(rnorm(
          n(), ifelse(
            EGELTM == "PT5M",
            450.9781,
            ifelse(EGELTM == "PT3M", 457.7265, 455.3394)
          ), 60
        ))
      ),
      EGSTRESC = ifelse(EGTESTCD == "ECGINT", sample(c(
        "NORMAL", "ABNORMAL"
      ), 1), as.character(EGSTRESN)),
      EGORRES = EGSTRESC,
      EGSTRESU = egstresu_mapping[EGTESTCD],
      EGSTAT = "",
      EGLOC = "",
      EGBLFL = ifelse(VISIT == "BASELINE", "Y", ""),
      VISITNUM = visitnum_mapping[VISIT],
      VISITDY = visitdy_mapping[VISIT],
      EGTPTNUM = ifelse(EGTESTCD == "ECGINT", NA, egtptnum_mapping[EGTPT]),
      EGTPTREF = ifelse(
        EGTESTCD == "ECGINT",
        "",
        ifelse(EGELTM == "PT5M", "PATIENT SUPINE", "PATIENT STANDING")
      ),
      EGDY = VISITDY,
      EGTPT = ifelse(EGTESTCD == "ECGINT", "", EGTPT)
    )
  return(patient)
}

# Apply the add_patient function to each subject ID and combine results
eg_test <- lapply(usubjids, add_patient) %>%
  bind_rows() %>%
  select(
    STUDYID,
    DOMAIN,
    USUBJID,
    EGSEQ,
    EGTESTCD,
    EGTEST,
    EGORRES,
    EGORRESU,
    EGSTRESC,
    EGSTRESN,
    EGSTRESU,
    EGSTAT,
    EGLOC,
    EGBLFL,
    VISITNUM,
    VISIT,
    VISITDY,
    EGDTC,
    EGDY,
    EGTPT,
    EGTPTNUM,
    EGELTM,
    EGTPTREF
  )

# Add labels to the columns
var_label(eg_test) <- list(
  STUDYID = "Study Identifier",
  DOMAIN = "Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  EGSEQ = "Sequence Number",
  EGTESTCD = "Test Code",
  EGTEST = "Test Name",
  EGORRES = "Original Result",
  EGORRESU = "Original Units",
  EGELTM = "Elapsed Time",
  EGSTRESC = "Standard Character Result",
  EGSTRESN = "Standard Numeric Result",
  EGSTRESU = "Standard Units",
  EGSTAT = "Completion Status",
  EGLOC = "Location of Vital Signs Measurement",
  EGBLFL = "Baseline Flag",
  VISITNUM = "Visit Number",
  VISIT = "Visit Name",
  VISITDY = "Planned Study Day of Visit",
  EGDTC = "Date/Time of Measurements",
  EGDY = "Study Day of Vital Signs",
  EGTPT = "Planned Time Point Number",
  EGTPTNUM = "Time Point Number",
  EGELTM = "Planned Elapsed Time from Time Point Ref",
  EGTPTREF = "Time Point Reference"
)

# Label the dataset
attr(eg_test, "label") <- "Electrocardiogram"

# Save the dataset
usethis::use_data(eg_test, overwrite = TRUE)
