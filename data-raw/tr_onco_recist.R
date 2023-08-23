
library(tibble)
library(dplyr)

tr <- tribble(
  ~USUBJID, ~TRLINKID, ~TRTESTCD,  ~TRORRES,  ~VISITNUM,
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
  "7",      "T03",     "LPERP",    "43",              4
)

tr_onco_recist <- tr %>%
  mutate(
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
    )
  ) %>%
  mutate(
    TRORRESU = if_else(TRTESTCD %in% c("LDIAM", "LPERP"), "mm", NA_character_),
    TRSTRESC = TRORRES,
    TRSTRESN = as.double(TRSTRESC),
    TRSTRESU = TRORRESU,
    .after = TRORRES
  )

usethis::use_data(tr_onco_recist, overwrite = TRUE)
