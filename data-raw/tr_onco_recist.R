library(tibble)
library(dplyr)
library(lubridate)
library(admiraldev)
library(admiral)

# create tumor results to be used for RS
tr <- tribble(
  ~SUBJNR,  ~TRLNKID,  ~TRTESTCD,  ~TRORRES,  ~VISITNUM,
  # BOR = CR, CBOR = SD
  "1",      "T01",     "LDIAM",    "21",              1,
  "1",      "T02",     "LPERP",    "32",              1,
  "1",      "T03",     "LDIAM",    "24",              1,
  "1",      "T04",     "LDIAM",    "19",              1,
  # SD
  "1",      "T01",     "LDIAM",    "20",              2,
  "1",      "T02",     "LPERP",    "34",              2,
  "1",      "T03",     "LDIAM",    "24",              2,
  "1",      "T04",     "LDIAM",    "18",              2,
  # NE
  "1",      "T01",     "LDIAM",    "20",              3,
  "1",      "T04",     "LDIAM",    "18",              3,
  # CR
  "1",      "T01",     "LDIAM",    "0",               4,
  "1",      "T02",     "LPERP",    "7",               4,
  "1",      "T03",     "LDIAM",    "0",               4,
  "1",      "T04",     "LDIAM",    "0",               4,

  # BOR = PD, CBOR = PD
  "2",      "T01",     "LDIAM",    "16",              1,
  "2",      "T02",     "LDIAM",    "22",              1,
  "2",      "T03",     "LDIAM",    "21",              1,
  "2",      "T04",     "LDIAM",    "17",              1,
  "2",      "T05",     "LDIAM",    "18",              1,
  # SD
  "2",      "T01",     "LDIAM",    "16",              2,
  "2",      "T02",     "LDIAM",    "21",              2,
  "2",      "T03",     "LDIAM",    "19",              2,
  "2",      "T04",     "LDIAM",    "17",              2,
  "2",      "T05",     "LDIAM",    "18",              2,
  # PD
  "2",      "T02",     "LDIAM",    "34",              3,
  "2",      "T03",     "LDIAM",    "41",              3,
  "2",      "T04",     "LDIAM",    "26",              3,
  "2",      "T05",     "LDIAM",    "9",               3,
  # SD
  "2",      "T01",     "LDIAM",    "17",              4,
  "2",      "T02",     "LDIAM",    "23",              4,
  "2",      "T03",     "LDIAM",    "20",              4,
  "2",      "T04",     "LDIAM",    "25",              4,
  "2",      "T05",     "LDIAM",    "7",               4,

  # BOR = NON-CR/NON-PD, CBOR = NON-CR/NON-PD
  "3",      "NT01",    "TUMSTATE", "PRESENT",         1,
  "3",      "NT02",    "TUMSTATE", "PRESENT",         1,
  "3",      "NT03",    "TUMSTATE", "PRESENT",         1,
  # NON-CR/NON-PD
  "3",      "NT01",    "TUMSTATE", "PRESENT",         2,
  "3",      "NT02",    "TUMSTATE", "ABSENT",          2,
  "3",      "NT03",    "TUMSTATE", "PRESENT",         2,
  # NON-CR/NON-PD
  "3",      "NT01",    "TUMSTATE", "PRESENT",         3,
  "3",      "NT02",    "TUMSTATE", "ABSENT",          3,
  "3",      "NT03",    "TUMSTATE", "ABSENT",          3,

  # BOR = NE, CBOR = NE
  "4",      "NT01",    "TUMSTATE", "PRESENT",         1,
  "4",      "NT02",    "TUMSTATE", "PRESENT",         1,
  # NON-CR/NON-PD
  "4",      "NT01",    "TUMSTATE", "ABSENT",          2,
  "4",      "NT02",    "TUMSTATE", "PRESENT",         2,

  # BOR = CR CBOR = PR
  "5",      "T01",     "LPERP",    "31",              1,
  "5",      "T02",     "LDIAM",    "42",              1,
  "5",      "T03",     "LPERP",    "17",              1,
  # SD
  "5",      "T01",     "LPERP",    "31",              2,
  "5",      "T02",     "LDIAM",    "34",              2,
  "5",      "T03",     "LPERP",    "9",               2,
  # PR
  "5",      "T01",     "LPERP",    "19",              3,
  "5",      "T02",     "LDIAM",    "21",              3,
  "5",      "T03",     "LPERP",    "4",               3,
  # CR
  "5",      "T01",     "LPERP",    "7",               4,
  "5",      "T02",     "LDIAM",    "0",               4,
  "5",      "T03",     "LPERP",    "3",               4,
  # BOR = PR CBOR = PR
  "6",      "T01",     "LDIAM",    "27",              1,
  "6",      "T02",     "LDIAM",    "51",              1,
  # SD
  "6",      "T01",     "LDIAM",    "24",              2,
  "6",      "T02",     "LDIAM",    "48",              2,
  # PR
  "6",      "T01",     "LDIAM",    "15",              3,
  "6",      "T02",     "LDIAM",    "23",              3,
  # NE
  "6",      "T01",     "LDIAM",    "14",              4,
  # PR
  "6",      "T01",     "LDIAM",    "14",              5,
  "6",      "T02",     "LDIAM",    "19",              5,

  # BOR = SD CBOR = SD
  "7",      "T01",     "LDIAM",    "35",              1,
  "7",      "T02",     "LDIAM",    "22",              1,
  "7",      "T03",     "LPERP",    "33",              1,
  # SD
  "7",      "T01",     "LDIAM",    "31",              2,
  "7",      "T02",     "LDIAM",    "24",              2,
  "7",      "T03",     "LPERP",    "33",              2,
  # SD
  "7",      "T01",     "LDIAM",    "37",              3,
  "7",      "T02",     "LDIAM",    "28",              3,
  "7",      "T03",     "LPERP",    "31",              3,
  # PD
  "7",      "T01",     "LDIAM",    "42",              4,
  "7",      "T02",     "LDIAM",    "39",              4,
  "7",      "T03",     "LPERP",    "43",              4,
  # BOR = SD CBOR = SD
  "8",      "T01",     "LDIAM",    "19",              1,
  "8",      "T02",     "LDIAM",    "21",              1,
  "8",      "T03",     "LDIAM",    "20",              1,
  # PR
  "8",      "T01",     "LDIAM",    "15",              2,
  "8",      "T02",     "LDIAM",    "14",              2,
  "8",      "T03",     "LDIAM",    "13",              2,
  # CR
  "8",      "T01",     "LDIAM",    "0",               3,
  "8",      "T02",     "LDIAM",    "0",               3,
  "8",      "T03",     "LDIAM",    "0",               3,
  # PD
  "8",      "T01",     "LDIAM",    "5",               4,
  "8",      "T02",     "LDIAM",    "0",               4,
  "8",      "T03",     "LDIAM",    "0",               4,
) %>%
  mutate(
    basicfl = "Y"
  )

# complete TRTESTCDs such that LDIAM and LPERP are present for all tumors
suppress_warning(
  tr_compl <- tr %>%
    mutate(
      diff_percent = (as.numeric(SUBJNR) + as.numeric(substr(TRLNKID, 3, 3)) + VISITNUM) %% 11,
      TRORRES = case_match(
        TRTESTCD,
        "LDIAM" ~ as.character(as.numeric(TRORRES) * (1 - diff_percent / 100)),
        "LPERP" ~ as.character(as.numeric(TRORRES) * (1 + diff_percent / 100)),
        .default = TRORRES
      ),
      TRTESTCD = case_match(
        TRTESTCD,
        "LDIAM" ~ "LPERP",
        "LPERP" ~ "LDIAM",
        .default = TRTESTCD
      )
    ) %>%
    select(-basicfl),
  regexpr = "NAs introduced by coercion"
)

tr <- bind_rows(tr, tr_compl)

# add results for radiologist 1
suppress_warning(
  tr_radio1 <- tr %>%
    mutate(
      diff_percent = (as.numeric(SUBJNR) + as.numeric(substr(TRLNKID, 3, 3)) + VISITNUM) %% 7 - 3,
      TRORRES = if_else(
        TRTESTCD %in% c("LDIAM", "LPERP"),
        as.character(as.numeric(TRORRES) * (1 + diff_percent / 100)),
        TRORRES
      ),
      TREVALID = "RADIOLOGIST 1"
    ),
  regexpr = "NAs introduced by coercion"
)

# add results for radiologist 2
suppress_warning(
  tr_radio2 <- tr %>%
    mutate(
      diff_percent = (as.numeric(SUBJNR) + as.numeric(substr(TRLNKID, 3, 3)) + VISITNUM + 3) %% 7 - 3,
      TRORRES = if_else(
        TRTESTCD %in% c("LDIAM", "LPERP"),
        as.character(as.numeric(TRORRES) * (1 + diff_percent / 100)),
        TRORRES
      ),
      TREVALID = "RADIOLOGIST 2"
    ),
  regexpr = "NAs introduced by coercion"
)

tr <- bind_rows(tr, tr_radio1, tr_radio2) %>%
  select(-diff_percent) %>%
  mutate(
    TRGRPID = if_else(
      substr(TRLNKID, 1, 1) == "T",
      "TARGET",
      "NON-TARGET"
    ),
    .before = TRLNKID
  ) %>%
  mutate(
    TREVAL = if_else(is.na(TREVALID), "INVESTIGATOR", "INDEPENDENT ASSESSOR"),
    .before = TREVALID,
  ) %>%
  mutate(
    best_assessor = (as.numeric(SUBJNR) + VISITNUM) %% 2 + 1,
    TRACPTFL = if_else(
      TREVALID == paste("RADIOLOGIST", best_assessor),
      "Y",
      NA_character_
    ),
    .after = TREVALID
  ) %>%
  select(-best_assessor)

# add date (TRDTC)
data("dm")
tr <- tr %>%
  mutate(
    USUBJID = case_match(
      SUBJNR,
      "1" ~ "01-701-1015",
      "2" ~ "01-701-1028",
      "3" ~ "01-701-1034",
      "4" ~ "01-701-1097",
      "5" ~ "01-701-1115",
      "6" ~ "01-701-1118",
      "7" ~ "01-701-1130",
      "8" ~ "01-701-1133"
    ),
    .before = SUBJNR
  ) %>%
  derive_vars_merged(
    dataset_add = dm,
    by_vars = exprs(USUBJID),
    new_vars = exprs(RFSTDT = convert_dtc_to_dt(RFSTDTC))
  ) %>%
  mutate(
    TRDTC = format_ISO8601(RFSTDT + 21 * (VISITNUM - 1)),
    TRDTC = if_else(
      SUBJNR == "1" & VISITNUM == 3,
      substr(TRDTC, 1, 7),
      TRDTC
    )
  )
suppress_warning(
  tr <- tr %>%
    mutate(
      DOMAIN = "TR",
      STUDYID = "CDISCPILOT01",
      .before = USUBJID
    ) %>%
    mutate(
      TRTEST = case_match(
        TRTESTCD,
        "LDIAM" ~ "Longest Diameter",
        "LPERP" ~ "Longest Perpendicular",
        "TUMSTATE" ~ "Tumor State"
      ),
      .after = TRTESTCD
    ) %>%
    mutate(
      VISIT = case_match(
        VISITNUM,
        1 ~ "SCREENING",
        2 ~ "WEEK 3",
        3 ~ "WEEK 6",
        4 ~ "WEEK 9",
        5 ~ "WEEK 12"
      ),
      .after = VISITNUM
    ) %>%
    mutate(
      TRORRESU = if_else(TRTESTCD %in% c("LDIAM", "LPERP"), "mm", NA_character_),
      TRSTRESC = TRORRES,
      TRSTRESN = as.double(TRSTRESC),
      TRSTRESU = TRORRESU,
      .after = TRORRES
    ),
  regexpr = "NAs introduced by coercion"
)

tr <- derive_var_obs_number(
  tr,
  by_vars = exprs(USUBJID),
  new_var = TRSEQ,
  order = exprs(VISITNUM, TREVAL, TREVALID)
)

# store basic tumor results for creation of TU
# (LPERP -> TULOC = "LYMPH NODE", LDIAM -> something else)

tr_screen <- tr %>%
  filter(VISITNUM == 1 & basicfl == "Y") %>%
  select(STUDYID, USUBJID, SUBJNR, TRLNKID, TRTESTCD, VISIT, VISITNUM, TREVAL, TREVALID, TRACPTFL)
saveRDS(tr_screen, file = "data-raw/tu_help_data.rds")

tr_onco_recist <- select(tr, -SUBJNR, -basicfl, -RFSTDT)

usethis::use_data(tr_onco_recist, overwrite = TRUE)
