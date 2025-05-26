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
      locations[as.numeric(SUBJNR) + as.numeric(substr(TRLNKID, str_length(TRLNKID), str_length(TRLNKID)))]
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
    TUORRES = if_else(substr(TRLNKID, 1, 1) == "T", "TARGET", "NON-TARGET"),
    TUSTRESC = TUORRES,
    TUMETHOD = "CT SCAN",
    TULNKID = TRLNKID,
    TUEVAL = TREVAL,
    TUEVALID = TREVALID,
    TUACPTFL = TRACPTFL
  ) %>%
  select(-starts_with("TR"), -SUBJNR) %>%
  derive_var_obs_number(
    by_vars = exprs(USUBJID),
    new_var = TUSEQ,
    order = exprs(TUEVAL, TUEVALID)
  )

# label variables
tu_onco_recist <- tu_onco_recist %>%
  add_labels(
    DOMAIN = "Domain Abbreviation",
    STUDYID = "Study Identifier",
    USUBJID = "Unique Subject Identifier",
    VISIT = "Visit Name",
    VISITNUM = "Visit Number",
    TULOC = "Location of the Tumor/Lesion",
    TUTESTCD = "Tumor/Lesion ID Short Name",
    TUTEST = "Tumor/Lesion ID Test Name",
    TUORRES = "Tumor/Lesion ID Result",
    TUSTRESC = "Tumor/Lesion ID Result Std. Format",
    TUMETHOD = "Method of Identification",
    TULNKID = "Link ID",
    TUEVAL = "Evaluator",
    TUEVALID = "Evaluator Identifier",
    TUACPTFL = "Accepted Record Flag",
    TUSEQ = "Sequence Number"
  )

usethis::use_data(tu_onco_recist, overwrite = TRUE)
