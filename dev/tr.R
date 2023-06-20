# TR

library(dplyr)
library(tidyselect)
library(metatools)
library(admiral)
library(metatools)

set.seed(1)

# Reading input data ----
data("admiral_dm")
data("admiral_suppdm")
data("admiral_sv")

# Converting blank to NA
dm <- convert_blanks_to_na(admiral_dm)
suppdm <- convert_blanks_to_na(admiral_suppdm)
sv <- convert_blanks_to_na(admiral_sv)

# Creating data frame with visits ----
dm1 <- dm %>%
  combine_supp(suppdm)

dm2 <- select(dm1, c(STUDYID, USUBJID, SAFETY, EFFICACY))

tr1 <- select(sv, c(STUDYID, USUBJID, VISIT, VISITNUM, VISITDY, SVSTDTC)) %>%
  filter(VISITNUM %in% c(3, 7, 9, 9.2, 9.3, 10.1, 12)) %>%
  rename(TRDTC = SVSTDTC, TRDY = VISITDY)

tr2 <- merge(dm2, tr1, by = c("STUDYID", "USUBJID"))

# Creating dummy tumors ----
trloc <- c(
  "ABDOMINAL CAVITY", "ADRENAL GLAND", "LYMPH NODE", "BLADDER",
  "BODY", "BONE", "BREAST", "CHEST", "COLON",
  "ESOPHAGUS", "HEAD AND NECK", "ANUS", "BILE DUCT",
  "BRAIN", "GALL BLADDER", "HEAD", "HEART",
  "KIDNEY", "LIVER", "LUNG", "MEDIASTINUM",
  "PLEURAL EFFUSION", "SOFT TISSUE", "PERIANAL REGION",
  "PROSTATE GLAND"
)

ttyped <- as.data.frame(trloc) %>% rename("TRLOC" = "trloc")
ttyped$tar1 <- as.double(row.names(ttyped))

# Adding records for TARGET, NON-TARGET and NEW LESIONS and
# Selecting Tumor Locations Randomly
nrows <- dim(tr2)[1]
tar <- floor(runif(n = nrows, min = 1, max = 5))
new <- floor(runif(n = nrows, min = 21, max = 22))

# Target Tumors
tr3a <- bind_rows(
  (tr2 %>% mutate("tar1" = tar, "TRLNKID" = "T01")),
  (tr2 %>% mutate("tar1" = tar + 1, "TRLNKID" = "T02")),
  (tr2 %>% mutate("tar1" = tar + 2, "TRLNKID" = "T03")),
  (tr2 %>% mutate("tar1" = tar + 3, "TRLNKID" = "T04")),
  (tr2 %>% mutate("tar1" = tar + 4, "TRLNKID" = "T05"))
) %>%
  mutate("TREVAL" = "INVESTIGATOR") %>%
  # add incomplete date
  mutate(TRDTC = if_else(
    USUBJID == "01-701-1015" & VISIT == "BASELINE",
    substr(TRDTC, 1, 7),
    TRDTC
  ))

tar <- floor(runif(n = nrows, min = 1, max = 5))
tr3b <- bind_rows(
  (tr2 %>% mutate("tar1" = tar, "TRLNKID" = "R1-T01")),
  (tr2 %>% mutate("tar1" = tar + 1, "TRLNKID" = "R1-T02")),
  (tr2 %>% mutate("tar1" = tar + 2, "TRLNKID" = "R1-T03")),
  (tr2 %>% mutate("tar1" = tar + 3, "TRLNKID" = "R1-T04")),
  (tr2 %>% mutate("tar1" = tar + 4, "TRLNKID" = "R1-T05"))
) %>%
  mutate(
    "TREVAL" = "INDEPENDENT ASSESSOR",
    "TREVALID" = "RADIOLOGIST 1"
  )

tar <- floor(runif(n = nrows, min = 1, max = 5))
tr3c <- bind_rows(
  (tr2 %>% mutate("tar1" = tar, "TRLNKID" = "R2-T01")),
  (tr2 %>% mutate("tar1" = tar + 1, "TRLNKID" = "R2-T02")),
  (tr2 %>% mutate("tar1" = tar + 2, "TRLNKID" = "R2-T03")),
  (tr2 %>% mutate("tar1" = tar + 3, "TRLNKID" = "R2-T04")),
  (tr2 %>% mutate("tar1" = tar + 4, "TRLNKID" = "R2-T05"))
) %>%
  mutate(
    "TREVAL" = "INDEPENDENT ASSESSOR",
    "TREVALID" = "RADIOLOGIST 2"
  )

tr3 <- bind_rows(tr3a, tr3b, tr3c) %>%
  left_join(ttyped, by = "tar1")

# Adding Diameter Values Randomly ----
trows <- dim(tr3)[1]
diam <- floor((runif(n = trows, min = 5, max = 15)))

tr3 <- tr3 %>%
  mutate(
    TRSTRESN = diam,
    SUBJNO = as.numeric(substr(USUBJID, 8, 12))
  )

# Modifying Diameter Values To Get Some CR And NE In Target Response Data
tr3 <- tr3 %>% mutate(
  "TRSTRESN" = case_when(
    floor(SUBJNO %% 5) == 0 & VISITNUM %in% c(9, 10.1) ~ 0,
    floor(SUBJNO %% 9) == 0 & TREVAL == "INVESTIGATOR" &
      VISITNUM == 7 & TRLNKID == paste0("T0", SUBJNO %% 5 + 1) ~ NA_real_,
    floor(SUBJNO %% 8) == 0 &
      (TREVALID == "RADIOLOGIST 1" | TREVALID == "RADIOLOGIST 2") &
      VISITNUM == 10.1 ~ NA_real_,
    floor(SUBJNO %% 2) != 0 & VISITNUM == 3 ~ TRSTRESN + 5,
    floor(SUBJNO %% 2) == 0 & VISITNUM != 3 ~ TRSTRESN + 5,
    TRUE ~ TRSTRESN
  ),
  "TRORRES" = as.character(TRSTRESN),
  "TRSTRESC" = TRORRES,
  "TRORRESU" = "mm",
  "TRSTRESU" = TRORRESU,
  "TRGRPID" = "TARGET",
  "TRTESTCD" = "DIAMETER",
  "TRTEST" = "Diameter"
)

# Adding LDIAM and LPERP ----
tr3ldiam <- tr3 %>% mutate(
  TRSTRESN = if_else(
    TRLOC == "LYMPH NODE",
    TRSTRESN * 1.1,
    TRSTRESN
  ),
  TRORRES = as.character(TRSTRESN),
  TRSTRESC = TRORRES,
  TRTESTCD = "LDIAM",
  TRTEST = "Longest Diameter"
)

tr3lperp <- tr3 %>% mutate(
  TRSTRESN = if_else(
    TRLOC == "LYMPH NODE",
    TRSTRESN,
    TRSTRESN * 0.9
  ),
  TRORRES = as.character(TRSTRESN),
  TRSTRESC = TRORRES,
  TRTESTCD = "LPERP",
  TRTEST = "Longest Perpendicular"
)

# SUMDIAM ----
tr3sum <- tr3 %>%
  group_by(
    STUDYID, USUBJID, VISITNUM, VISIT, TREVAL,
    TREVALID, TRDTC, TRDY, TRGRPID, TRORRESU,
    TRSTRESU, SAFETY, EFFICACY
  ) %>%
  summarize(TRSTRESN = sum(TRSTRESN, na.rm = TRUE)) %>%
  mutate(
    "TRTESTCD" = "SUMDIAM",
    "TRTEST" = "Sum of Diameter",
    "TRORRES" = as.character(TRSTRESN),
    "TRSTRESC" = TRORRES
  )

# Non-target Tumors ----

ntar <- floor(runif(n = nrows, min = 11, max = 15))
ntr3a <- bind_rows(
  (tr2 %>% mutate("tar1" = ntar, "TRLNKID" = "NT01")),
  (tr2 %>% mutate("tar1" = ntar + 1, "TRLNKID" = "NT02")),
  (tr2 %>% mutate("tar1" = ntar + 2, "TRLNKID" = "NT03")),
  (tr2 %>% mutate("tar1" = ntar + 3, "TRLNKID" = "NT04")),
  (tr2 %>% mutate("tar1" = ntar + 4, "TRLNKID" = "NT05"))
) %>%
  mutate("TREVAL" = "INVESTIGATOR")

ntar <- floor(runif(n = nrows, min = 11, max = 15))
ntr3b <- bind_rows(
  (tr2 %>% mutate("tar1" = ntar, "TRLNKID" = "R1-NT01")),
  (tr2 %>% mutate("tar1" = ntar + 1, "TRLNKID" = "R1-NT02")),
  (tr2 %>% mutate("tar1" = ntar + 2, "TRLNKID" = "R1-NT03")),
  (tr2 %>% mutate("tar1" = ntar + 3, "TRLNKID" = "R1-NT04")),
  (tr2 %>% mutate("tar1" = ntar + 4, "TRLNKID" = "R1-NT05"))
) %>%
  mutate(
    "TREVAL" = "INDEPENDENT ASSESSOR",
    "TREVALID" = "RADIOLOGIST 1"
  )

ntar <- floor(runif(n = nrows, min = 11, max = 15))
ntr3c <- bind_rows(
  (tr2 %>% mutate("tar1" = ntar, "TRLNKID" = "R2-NT01")),
  (tr2 %>% mutate("tar1" = ntar + 1, "TRLNKID" = "R2-NT02")),
  (tr2 %>% mutate("tar1" = ntar + 2, "TRLNKID" = "R2-NT03")),
  (tr2 %>% mutate("tar1" = ntar + 3, "TRLNKID" = "R2-NT04")),
  (tr2 %>% mutate("tar1" = ntar + 4, "TRLNKID" = "R2-NT05"))
) %>%
  mutate(
    "TREVAL" = "INDEPENDENT ASSESSOR",
    "TREVALID" = "RADIOLOGIST 2"
  )

ntr3 <- bind_rows(ntr3a, ntr3b, ntr3c)

# Adding Non Target Result Values Randomly
ntrorresf <- c("NOT", "UNEQUIVOCAL", "ABSENT", "PRESENT")

ntrespd <- tibble::tibble(ntrorresf)
ntrespd <- ntrespd %>% rename("ntrorres" = "ntrorresf")
ntrespd$ntresn <- NULL
ntrespd$ntresn <- row.names(ntrespd)

ntrows <- dim(ntr3)[1]
x <- runif(ntrows, 0, 1)
ntr3$ntresn <- as.numeric(cut(x, breaks = c(0, 0.05, 0.15, 0.6, 1)))

ntr3 <- merge(ntr3, ntrespd, by = "ntresn") %>%
  mutate(
    "TRGRPID" = "NON-TARGET",
    "TRTESTCD" = "TUMSTATE",
    "TRTEST" = "Tumor State",
    "TRORRES" = case_when(
      VISITNUM == 3 ~ "PRESENT",
      !is.na(ntrorres) & ntrorres != "NOT" ~ ntrorres
    ),
    "SUBJNO" = as.numeric(substr(USUBJID, 8, 12))
  )

# Modifying Non-target Values To Get Some CR In Data
ntr3 <- ntr3 %>% mutate(
  "TRORRES" = ifelse(floor(SUBJNO %% 5) == 0 &
    VISITNUM %in% c(9, 10.1), "ABSENT", TRORRES),
  "TRSTRESC" = TRORRES
)

# New Lesions - assigning new lesions only on last visit
new <- floor(runif(n = nrows, min = 21, max = 22))
new3a <- tr2 %>% mutate(
  "tar1" = new,
  "TRLNKID" = "NEW01",
  "TREVAL" = "INVESTIGATOR"
)

new <- floor(runif(n = nrows, min = 21, max = 22))
new3b <- tr2 %>% mutate(
  "tar1" = new,
  "TRLNKID" = "R1-NEW01",
  "TREVAL" = "INDEPENDENT ASSESSOR",
  "TREVALID" = "RADIOLOGIST 1"
)

new <- floor(runif(n = nrows, min = 21, max = 22))
new3c <- tr2 %>% mutate(
  "tar1" = new,
  "TRLNKID" = "R2-NEW01",
  "TREVAL" = "INDEPENDENT ASSESSOR",
  "TREVALID" = "RADIOLOGIST 2"
)

new3 <- bind_rows(new3a, new3b, new3c) %>%
  mutate(
    "SUBJNO" = as.numeric(substr(USUBJID, 8, 12)),
    "TRGRPID" = "NEW",
    "TRTESTCD" = "TUMSTATE",
    "TRTEST" = "Tumor State"
  ) %>%
  mutate(
    "TRORRES" = case_when(
      VISITNUM == 12 & floor(SUBJNO %% 9) == 0 ~ "UNEQUIVOCAL",
      VISITNUM == 12 & floor(SUBJNO %% 4) == 0 ~ "EQUIVOCAL",
      TRUE ~ "NO"
    ),
    "TRSTRESC" = TRORRES
  ) %>%
  filter(VISITNUM > 3 & (TRORRES != "NO"))

# Setting All Tumor Data ----
tr <- bind_rows(
  tr3 %>% filter(EFFICACY == "Y" | (SAFETY == "Y" & VISITNUM == 3)),
  tr3ldiam %>% filter(EFFICACY == "Y" | (SAFETY == "Y" & VISITNUM == 3)),
  tr3lperp %>% filter(EFFICACY == "Y" | (SAFETY == "Y" & VISITNUM == 3)),
  tr3sum %>% filter(EFFICACY == "Y" | (SAFETY == "Y" & VISITNUM == 3)),
  ntr3 %>% filter(EFFICACY == "Y" | (SAFETY == "Y" & VISITNUM == 3)),
  new3 %>% filter(EFFICACY == "Y" | (SAFETY == "Y" & VISITNUM == 3))
) %>%
  mutate("TRLNKG" = case_when(
    VISITNUM == 3 ~ "A1",
    VISITNUM == 7 ~ "A2",
    VISITNUM == 9 ~ "A3",
    VISITNUM == 10.2 ~ "A4",
    VISITNUM == 12 ~ "A4"
  ))

# TRSEQ and Other Variables ----
tr <- tr %>%
  arrange(STUDYID, USUBJID, VISITNUM, TRDTC, TRGRPID, TRLNKID) %>%
  group_by(STUDYID, USUBJID) %>%
  mutate(
    TRSEQ = row_number(),
    "TRSTAT" = case_when(is.na(TRORRES) ~ "NOT DONE"),
    "TRLOC" = ifelse(!is.na(TRORRES) & TRORRES == "NOT APPLICABLE", NA, TRLOC),
    "TRREASND" = ifelse(TRSTAT == "NOT DONE",
      "NOT ASSESSABLE: Image obscured", NA
    ),
    "TRORRESU" = ifelse(is.na(TRORRES) & TRGRPID == "TARGET", NA, TRORRESU),
    "TRSTRESU" = ifelse(is.na(TRORRES) & TRGRPID == "TARGET", NA, TRSTRESU),
    "TRMETHOD" = "CT SCAN",
    "DOMAIN" = "TR",
    "TRLNKGRP" = case_when(
      is.na(TREVALID) ~ TRLNKG,
      TREVALID == "RADIOLOGIST 1" ~ paste("R1", TRLNKG, sep = "-"),
      TREVALID == "RADIOLOGIST 2" ~ paste("R2", TRLNKG, sep = "-"),
      TRUE ~ TRLNKG
    ),
    "TRACPTFL" = case_when(TREVALID == "RADIOLOGIST 1" ~ "Y")
  ) %>%
  ungroup()

# Creating SUPPTR ----
supptr1 <- select(tr, c("STUDYID", "USUBJID", "TRSEQ", "DOMAIN", "TRLOC"))
supptr2 <- rename(supptr1, "RDOMAIN" = "DOMAIN") %>%
  mutate(
    "IDVARVAL" = as.character(TRSEQ),
    "IDVAR" = "TRSEQ",
    "QVAL" = TRLOC,
    "QNAM" = "TRLOC",
    "QLABEL" = "Location of the Tumor",
    "QORIG" = "CRF"
  )

supptr <- select(
  supptr2,
  c(
    STUDYID, RDOMAIN, USUBJID,
    IDVAR, IDVARVAL, QNAM, QLABEL,
    QVAL, QORIG
  )
)

supptr <- supptr %>% add_labels(
  STUDYID = "Study Identifier",
  RDOMAIN = "Related Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  IDVAR = "Identifying Variable",
  IDVARVAL = "Identifying Variable Value",
  QNAM = "Qualifier Variable Name",
  QLABEL = "Qualifier Variable Label",
  QVAL = "Data Value",
  QORIG = "Origin"
)

attr(supptr, "label") <- "Supplemental Tumor Results"

# Creating TR ----
tr <- select(tr, c(
  STUDYID, DOMAIN, USUBJID, TRSEQ, TRGRPID, TRLNKGRP,
  TRLNKID, TRTESTCD, TRTEST, TRORRES, TRORRESU, TRSTRESC,
  TRSTRESN, TRSTRESU, TRSTAT, TRREASND, TRMETHOD,
  TREVAL, TREVALID, TRACPTFL, VISITNUM, VISIT, TRDTC, TRDY
))

tr <- tr %>% add_labels(
  STUDYID = "Study Identifier",
  DOMAIN = "Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  TRSEQ = "Sequence Number",
  TRGRPID = "Group ID",
  TRLNKID = "Link ID",
  TRLNKGRP = "Link Group",
  TRTESTCD = "Tumor Assessment Short Name",
  TRTEST = "Tumor Assessment Test Name",
  TRORRES = "Result or Finding in Original Units",
  TRORRESU = "Original Units",
  TRSTRESC = "Character Result/Finding in Std Format",
  TRSTRESN = "Numeric Result/Finding in Standard Units",
  TRSTRESU = "Standard Units",
  TRSTAT = "Completion Status",
  TRREASND = "Reason Tumor Measurement Not Performed",
  TRMETHOD = "Method used to Identify the Tumor",
  TREVAL = "Evaluator",
  TREVALID = "Evaluator Identifier",
  TRACPTFL = "Accepted Record Flag",
  VISITNUM = "Visit Number",
  VISIT = "Visit Name",
  TRDTC = "Date/Time of Tumor Measurement",
  TRDY = "Study Day of Tumor Measurement"
)

attr(tr, "label") <- "Tumor Results"

admiral_tr <- tr
admiral_supptr <- supptr

save(admiral_tr, file = "data/admiral_tr.rda", compress = "bzip2")
save(admiral_supptr, file = "data/admiral_supptr.rda", compress = "bzip2")
