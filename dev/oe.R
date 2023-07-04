# OE

library(dplyr)
library(metatools)
library(tidyselect)
library(admiral)

# Read in data
data("admiral_dm")
data("admiral_sv")

# Convert blank to NA
dm <- convert_blanks_to_na(admiral_dm)
sv <- convert_blanks_to_na(admiral_sv)

# set seed to get same results each run
set.seed(999)

oe1 <- select(sv, c(STUDYID, USUBJID, VISIT, VISITNUM, VISITDY, SVSTDTC)) %>%
  filter(VISITNUM %in% c(1, 3, 5, 7, 8, 8.1, 9, 10, 11, 12)) %>%
  rename(OEDTC = SVSTDTC)

oe2 <- merge(dm, oe1, by = c("STUDYID", "USUBJID"))

oestat <- sample(1:100, nrow(oe2) * 2, replace = TRUE)

# BCVA - Visual Acuity Score
oe31 <- bind_rows(
  (oe2 %>% mutate("OELAT" = "LEFT")),
  (oe2 %>% mutate("OELAT" = "RIGHT"))
) %>% mutate(
  "OETESTCD" = "VACSCORE",
  "OETEST" = "Visual Acuity Score",
  "OECAT" = "BEST CORRECTED VISUAL ACUITY",
  "OESCAT" = "OVERALL EVALUATION",
  "OESTRESN" = sample.int(100, n(), replace = TRUE),
  "OESTRESC" = as.character(OESTRESN),
  "OEORRES" = OESTRESC,
  "OELOC" = "EYE",
  "OEMETHOD" = "ETDRS EYE CHART"
)

# DRSS
oe32 <- bind_rows(
  (oe2 %>% mutate("OELAT" = "LEFT")),
  (oe2 %>% mutate("OELAT" = "RIGHT"))
) %>% mutate(
  "OETESTCD" = "DRSSR",
  "OETEST" = "Diabetic Retinopathy Sev Recode Value",
  "OETSTDTL" = "DIABETIC RETINOPATHY SEVERITY LEVEL RECODE VALUE (ETDRS SCALE)",
  "OECAT" = "OPHTHALMIC ASSESSMENTS",
  "OESCAT" = "FORM FOR CFP EVALUATION FOR 7M/4W",
  "oestat" = oestat,
  "OESTRESN" = ifelse(oestat < 2, NA, sample.int(12, n(), replace = TRUE)),
  "OESTRESC" = ifelse(is.na(OESTRESN), "NOT APPLICABLE", as.character(OESTRESN)),
  "OEORRES" = OESTRESC,
  "OELOC" = "RETINA",
  "OEMETHOD" = "COLOR FUNDUS PHOTOGRAPH"
)

# IOP
oe33 <- bind_rows(
  (oe2 %>% mutate("OELAT" = "LEFT")),
  (oe2 %>% mutate("OELAT" = "RIGHT"))
) %>% mutate(
  "OETESTCD" = "IOP",
  "OETEST" = "Intraocular Pressure",
  "OECAT" = "INTRAOCULAR PRESSURE",
  "oestat" = oestat,
  "OESTRESN" = ifelse(oestat > 99, NA, round(runif(n(), min = 5, max = 30))),
  "OESTRESC" = ifelse(is.na(OESTRESN), NA_character_, as.character(OESTRESN)),
  "OEORRES" = OESTRESC,
  "OEORRESU" = ifelse(is.na(OESTRESN), NA_character_, "mmHg"),
  "OESTRESU" = OEORRESU,
  "OESTAT" = ifelse(is.na(OESTRESN), "NOT DONE", NA_character_),
  "OELOC" = "EYE",
  "OEMETHOD" = "APPLANATION TONOMETRY"
)

# CST - Central Subfield Thickness
oe34 <- bind_rows(
  (oe2 %>% mutate("OELAT" = "LEFT")),
  (oe2 %>% mutate("OELAT" = "RIGHT"))
) %>% mutate(
  "OETESTCD" = "CSUBTH",
  "OETEST" = "Center Subfield Thickness",
  "OETSTDTL" = "CENTER SUBFIELD THICKNESS",
  "OECAT" = "OPHTHALMIC ASSESSMENTS",
  "OESCAT" = "SD-OCT CST SINGLE FORM",
  "OESTAT" = NA_character_,
  "OESTRESN" = sample.int(500, n(), replace = TRUE),
  "OESTRESC" = as.character(OESTRESN),
  "OEORRES" = OESTRESC,
  "OEORRESU" = "um",
  "OESTRESU" = "um",
  "OELOC" = "RETINA",
  "OEMETHOD" = "SD-OCT"
)

oe4 <- bind_rows(oe31, oe32, oe33, oe34) %>%
  arrange(STUDYID, USUBJID, VISITNUM, OEDTC, OETESTCD, OELAT) %>%
  group_by(STUDYID, USUBJID) %>%
  mutate(
    "OESEQ" = row_number(),
    "DOMAIN" = "OE",
    "OEDY" = as.numeric(as.Date(OEDTC) - as.Date(RFSTDTC)) + (as.Date(OEDTC) >= as.Date(RFSTDTC)),
    "OETPT" = NA_character_,
    "OETPTNUM" = NA
  )

oe <- oe4 %>%
  select(
    STUDYID, DOMAIN, USUBJID, OESEQ, OECAT, OESCAT, OEDTC, VISIT, VISITNUM, VISITDY,
    OESTRESN, OESTRESC, OEORRES, OETEST, OETESTCD, OETSTDTL, OELAT, OELOC, OEDY,
    OEMETHOD, OEORRESU, OESTRESU, OESTAT, OETPT, OETPTNUM
  ) %>%
  add_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    OESEQ = "Sequence Number",
    OECAT = "Category for Ophthalmic Test or Exam",
    OESCAT = "Subcategory for Ophthalmic Test or Exam",
    OEDTC = "Date/Time of Collection",
    OESTRESN = "Numeric Result/Finding in Standard Units",
    OESTRESC = "Character Result/Finding in Std Format",
    OEORRES = "Result or Finding in Original Units",
    OETEST = "Name of Ophthalmic Test or Examination",
    OETESTCD = "Short Name of Ophthalmic Test or Exam",
    OETSTDTL = "Ophthalmic Test or Exam Detail",
    OELAT = "Laterality",
    OELOC = "Location Used for the Measurement",
    OEDY = "Study Day of Visit/Collection/Exam",
    VISIT = "Visit Name",
    VISITNUM = "Visit Number",
    VISITDY = "Planned Study Day of Visit",
    OEMETHOD = "Method of Test or Examination",
    OEORRESU = "Original Units",
    OESTRESU = "Standard Units",
    OESTAT = "Completion Status",
    OETPT = "Planned Time Point Name",
    OETPTNUM = "Planned Time Point Number"
  )

attr(oe, "label") <- "Ophthalmic Examinations"

admiral_oe <- oe

save(admiral_oe, file = "data/admiral_oe.rda", compress = "bzip2")
