# ATTENTION: tr_onco_recist.R and tu_onco_recist.R must be run before this script
library(admiral)

data("tu_onco_recist")
data("tr_onco_recist")

# add location to tr
tr <- derive_vars_merged(
  tr_onco_recist,
  dataset_add = tu,
  by_vars = exprs(TRLINKID = TULINKID),
  new_vars = exprs(TRLOC = TULOC)
)

# select tr results to consider:
tr <- tr %>%
  filter(
  TRTESTCD == "LDIAM" & TRLOC == "LYMPH NODE" |
    TRTESTCD == "LPERP" & TRLOC != "LYMPH NODE" |
    TRTESTCD == "TUMSTATE"
) %>%
# flag complete response by tumor
mutate(
  CRFL = if_else(
    TRTESTCD == "LDIAM" & TRSTRESN == 0 ||
      TRTESTCD == "LPERP" & TRSTRESN < 10 ||
      TRTESTCD == "TUMSTATE" & TRSTRESC == "ABSENT",
    TRUE,
    FALSE
  )
)

# derive sums of diameters
sums <- tr %>%
  group_by(USUBJID, VISIT) %>%
  summarise(
    TRSTRESN = sum(TRSTRESN),
    CRFL = all(CRFL)) %>%
  mutate(TRTESTCD = "SUMDIAM") %>%
  ungroup()

sums <- sums %>%
  derive_vars_merge(
    dataset_add = sums,
    filter_add = VISIT == "SCREENING",
    by_vars = exprs(USUBJID, VISIT),
    new_vars = exprs(BASE = TRSTRESN)
  ) %>%
  derive_vars_joined(
    dataset_add =sums,
    by_vars = exprs(USUBJID),
    order = exprs(TRSTRESN),
    new_vars = exprs(NADIR = TRSTRESN),
    join_vars = exprs(VISITNUM),
    filter_join = VISITNUM > VISITNUM.join,
    mode = first
  )
