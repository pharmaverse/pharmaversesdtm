# ATTENTION: tr_onco_recist.R must be run before this script

library(stringr)
library(dplyr)


# read tr_screen created by tr_onco_recist.R
tr_screen <- readRDS("data-raw/tu_help_data.rds")

locations <- c(
  "ABDOMINAL CAVITY", "ADRENAL GLAND", "BLADDER",
  "BODY", "BONE", "BREAST", "CHEST", "COLON",
  "ESOPHAGUS", "HEAD AND NECK", "ANUS", "BILE DUCT",
  "BRAIN", "GALL BLADDER", "HEAD", "HEART",
  "KIDNEY", "LIVER", "LUNG", "MEDIASTINUM",
  "PLEURAL EFFUSION", "SOFT TISSUE", "PERIANAL REGION",
  "PROSTATE GLAND"
)
tu <- tr_screen %>%
  mutate(
    TULOC = if_else(
      TRTESTCD == "LPERP",
      "LYMPH NODE",
      locations[as.numeric(SUBJNR) + as.numeric(substr(TRLINKID, str_length(TRLINKID), str_length(TRLINKID)))]
    ),
    TUTESTCD = "TUMIDENT",
    TUTEST = "Tumore Identification"
  )

tu_onco_recist <- tu %>%
  mutate(
    DOMAIN = "TU",
    .before = STUDYID
  ) %>%
  mutate(
    TUORRES = if_else(substr(TRLINKID, 1, 1) == "T", "TARGET", "NON-TARGET"),
    TUSTRESC = TUORRES,
    TUMETHOD = "CT SCAN",
    TULINKID = TRLINKID
  ) %>%
  select(-starts_with("TR"))

usethis::use_data(tu_onco_recist, overwrite = TRUE)
