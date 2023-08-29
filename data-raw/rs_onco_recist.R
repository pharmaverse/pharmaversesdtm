# ATTENTION: tr_onco_recist.R and tu_onco_recist.R must be run before this script
library(admiral)

data("tu_onco_recist")
data("tr_onco_recist")

tu <- tu_onco_recist

# add location to tr
tr <- derive_vars_merged(
  tr_onco_recist,
  dataset_add = tu,
  by_vars = exprs(USUBJID, TREVAL = TUEVAL, TREVALID = TUEVALID, TRLINKID = TULINKID),
  new_vars = exprs(TRLOC = TULOC)
)

# select tr results to consider:
tr <- tr %>%
  filter(
    TRTESTCD == "LDIAM" & TRLOC != "LYMPH NODE" |
      TRTESTCD == "LPERP" & TRLOC == "LYMPH NODE" |
      TRTESTCD == "TUMSTATE"
  ) %>%
  # flag complete response by tumor
  mutate(
    CRFL = if_else(
      TRTESTCD == "LDIAM" & TRSTRESN == 0 |
        TRTESTCD == "LPERP" & TRSTRESN < 10 |
        TRTESTCD == "TUMSTATE" & TRSTRESC == "ABSENT",
      TRUE,
      FALSE
    )
  )

# derive sums of diameters
sums <- tr %>%
  group_by(STUDYID, USUBJID, TREVAL, TREVALID, TRACPTFL, VISITNUM, VISIT, TRDTC) %>%
  summarise(
    TRSTRESN = sum(TRSTRESN),
    CRFL = all(CRFL),
    IDS = paste(sort(TRLINKID), collapse = ", "),
    NTFL = all(substr(TRLINKID, 1, 1) == "N")
  ) %>%
  mutate(TRTESTCD = "SUMDIAM") %>%
  ungroup()

sums <- derive_vars_merged(
  sums,
  dataset_add = sums,
  filter_add = VISIT == "SCREENING",
  by_vars = exprs(USUBJID, TREVAL, TREVALID),
  new_vars = exprs(BASE = TRSTRESN, BASEIDS = IDS)
)
sums <- derive_vars_joined(
  sums,
  dataset_add = sums,
  by_vars = exprs(USUBJID),
  order = exprs(TRSTRESN),
  new_vars = exprs(NADIR = TRSTRESN),
  join_vars = exprs(VISITNUM),
  filter_add = BASEIDS == IDS,
  filter_join = VISITNUM > VISITNUM.join,
  mode = "first",
  check_type = "none"
)

# derive responses
rs_onco_recist <- sums %>%
  mutate(
    DOMAIN = "RS",
    .before = STUDYID
  ) %>%
  mutate(
    RSTESTCD = "OVRLRESP",
    RSTEST = "Overall Response",
    RSORRES = case_when(
      CRFL & IDS == BASEIDS ~ "CR",
      TRSTRESN - NADIR >= 5 & TRSTRESN / NADIR >= 1.2 ~ "PD",
      TRSTRESN / BASE <= 0.7 & IDS == BASEIDS ~ "PR",
      !is.na(TRSTRESN) & IDS == BASEIDS ~ "SD",
      NTFL ~ "NON-CR/NON-PD",
      TRUE ~ "NE"
    ),
    RSSTRESC = RSORRES,
    RSEVAL = TREVAL,
    RSEVALID = TREVALID,
    RSACPTFL = TRACPTFL,
    RSDTC = TRDTC
  ) %>%
  select(-starts_with("TR"), -BASE, -BASEIDS, -NADIR, -IDS, -CRFL, -NTFL) %>%
  filter(VISIT != "SCREENING") %>%
  derive_var_obs_number(
    by_vars = exprs(USUBJID),
    new_var = RSSEQ,
    order = exprs(VISITNUM, RSEVAL, RSEVALID)
  )

usethis::use_data(rs_onco_recist, overwrite = TRUE)
