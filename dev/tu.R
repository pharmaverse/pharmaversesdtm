# TU
# Please note that tr.R should run first

library(dplyr)
library(tidyselect)
library(admiral)
library(metatools)

# Reading input data  --  DUMMY DATA CREATED FROM TR data created from TR
data("admiral_tr")
data("admiral_supptr")

tr <- convert_blanks_to_na(admiral_tr)
supptr <- convert_blanks_to_na(admiral_supptr)

supptr1 <- supptr %>%
  mutate("DOMAIN" = RDOMAIN, TRSEQ = as.numeric(IDVARVAL), "TRLOC" = QVAL) %>%
  select(., c(STUDYID, USUBJID, TRSEQ, TRLOC))

tr <- full_join(tr, supptr1, by = c("STUDYID", "USUBJID", "TRSEQ"))

# Renaming And Adding TU Variables
tu1 <- tr %>%
  filter((VISITNUM == 3 | (TRGRPID == "NEW" &
    !is.na(TRORRES) & TRORRES != "NO"))) %>%
  filter(TRTESTCD %in% c("TUMSTATE", "DIAMETER")) %>%
  rename(
    TULNKID = TRLNKID,
    TUMETHOD = TRMETHOD,
    TUSEQ = TRSEQ,
    TUEVAL = TREVAL,
    TUEVALID = TREVALID,
    TUDTC = TRDTC,
    TUDY = TRDY,
    TULOC = TRLOC,
    TUACPTFL = TRACPTFL
  ) %>%
  mutate(
    DOMAIN = "TU",
    TUTESTCD = "TUMIDENT",
    TUTEST = "Tumor Identification",
    TUORRES = TRGRPID,
    TUSTRESC = TUORRES
  )

# TUSEQ
tu2 <- tu1 %>%
  arrange(STUDYID, USUBJID, VISITNUM, TUDTC, TULNKID) %>%
  group_by(STUDYID, USUBJID) %>%
  mutate(TUSEQ = row_number()) %>%
  ungroup()

# Creating TU
tu <- select(tu2, c(
  STUDYID, DOMAIN, USUBJID, TUSEQ, TULNKID,
  TUTESTCD, TUTEST, TUORRES, TUSTRESC, TULOC,
  TUMETHOD, TUEVAL, TUEVALID, TUACPTFL,
  VISITNUM, VISIT, TUDTC, TUDY
))

tu <- tu %>% add_labels(
  STUDYID = "Study Identifier",
  DOMAIN = "Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  TUSEQ = "Sequence Number",
  TULNKID = "Link ID",
  TUTESTCD = "Tumor Identification Short Name",
  TUTEST = "Tumor Identification Test Name",
  TUORRES = "Tumor Identification Result",
  TUSTRESC = "Tumor Identification Result Std. Format",
  TULOC = "Location of the Tumor",
  TUMETHOD = "Method of Identification",
  TUEVAL = "Evaluator",
  TUEVALID = "Evaluator Identifier",
  TUACPTFL = "Accepted Record Flag",
  VISITNUM = "Visit Number",
  VISIT = "Visit Name",
  TUDTC = "Date/Time of Tumor Identification",
  TUDY = "Study Day of Tumor Identification"
)

attr(tu, "label") <- "Tumor Identification"

admiral_tu <- tu
save(admiral_tu, file = "data/admiral_tu.rda", compress = "bzip2")
