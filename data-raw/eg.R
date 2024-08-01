# Dataset: eg
# Description: Standard EG dataset generated using random data. Patients and visit schedule are copied from CDISC pilot study Vital Signs dataset.

# Load necessary libraries ----
library(dplyr)
library(metatools)

# Read input data ----
data("vs")

# Set seed for reproducibility ----
set.seed(123)

# Extract unique date/time of measurements for each subject and visit ----
egdtc <- vs %>%
  select(USUBJID, VISIT, VSDTC) %>%
  distinct() %>%
  rename(EGDTC = VSDTC)

# Generate patients data ----
eg <- expand.grid(
  USUBJID = unique(vs$USUBJID),
  EGTESTCD = c("QT", "HR", "RR", "ECGINT"),
  EGTPT = c(
    "AFTER LYING DOWN FOR 5 MINUTES",
    "AFTER STANDING FOR 1 MINUTE",
    "AFTER STANDING FOR 3 MINUTES"
  ),
  VISIT = c(
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
) %>%
  arrange(EGTESTCD) %>%
  group_by(VISIT) %>%
  filter(!(
    # The original CDISC dataset kept no information about ECG Interpretation on specified visits.
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
  inner_join(egdtc, by = c("USUBJID", "VISIT")) %>%
  mutate(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "EG",
    EGSEQ = as.numeric(row_number()),
    # Generate sequence number
    EGTESTCD = as.character(EGTESTCD),
    EGTEST = c(
      "QT" = "QT Duration",
      "HR" = "Heart Rate",
      "RR" = "RR Duration",
      "ECGINT" = "ECG Interpretation"
    )[EGTESTCD],
    EGORRESU = c(
      "QT" = "mmHg",
      "HR" = "BEATS/MIN",
      "RR" = "mmHg",
      "ECGINT" = "LB"
    )[EGTESTCD],
    EGELTM = ifelse(
      EGTESTCD == "ECGINT",
      "",
      c(
        "AFTER LYING DOWN FOR 5 MINUTES" = "PT5M",
        "AFTER STANDING FOR 1 MINUTE" = "PT1M",
        "AFTER STANDING FOR 3 MINUTES" = "PT3M"
      )[EGTPT]
    ),
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
    EGSTRESU = c(
      "QT" = "msec",
      "HR" = "BEATS/MIN",
      "RR" = "msec",
      "ECGINT" = NA
    )[EGTESTCD],
    EGSTAT = "",
    EGLOC = "",
    EGBLFL = ifelse(VISIT == "BASELINE", "Y", ""),
    VISITNUM = c(
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
    )[VISIT],
    VISITDY = c(
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
    )[VISIT],
    EGTPTNUM = ifelse(
      EGTESTCD == "ECGINT",
      NA,
      c(
        "AFTER LYING DOWN FOR 5 MINUTES" = 815,
        "AFTER STANDING FOR 1 MINUTE" = 816,
        "AFTER STANDING FOR 3 MINUTES" = 817
      )[EGTPT]
    ),
    EGTPTREF = ifelse(
      EGTESTCD == "ECGINT",
      "",
      ifelse(EGELTM == "PT5M", "PATIENT SUPINE", "PATIENT STANDING")
    ),
    EGDY = VISITDY,
    EGTPT = ifelse(EGTESTCD == "ECGINT", "", EGTPT)
  ) %>% arrange(USUBJID, EGTESTCD, VISITNUM) %>%
  group_by(USUBJID) %>%
  mutate(EGSEQ = row_number()) %>%
  ungroup() %>%
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
  ) %>% add_labels(
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

# Label the dataset ----
attr(eg, "label") <- "Electrocardiogram"

# Save the dataset ----
usethis::use_data(eg, overwrite = TRUE)
