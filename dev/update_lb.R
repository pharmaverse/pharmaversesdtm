# Update LB by adding percentage differential lab test rows

library(dplyr)

data("raw_lb")
lb <- raw_lb

# Subset on differential lab tests
lb_diff_abs <- lb %>%
  filter(LBTESTCD %in% c("BASO", "EOS", "LYM", "MONO", "NEUT"))

# Subset on a few patients and visits
subject_sub <- lb_diff_abs %>%
  distinct(USUBJID) %>%
  head()

lb_sub <- lb_diff_abs %>%
  filter(
    USUBJID %in% subject_sub$USUBJID,
    VISIT %in% c("SCREENING 1", "WEEK 2")
  )

# Create dummy differential lab tests
set.seed(1)
rand_diff <- sample(seq(0, 0.5, by = 0.05), replace = T, nrow(lb_sub))

lb_diff <- lb_sub %>%
  mutate(
    LBTESTCD = case_when(
      LBTESTCD == "BASO" ~ "BASOLE",
      LBTESTCD == "EOS" ~ "EOSLE",
      LBTESTCD == "LYM" ~ "LYMLE",
      LBTESTCD == "MONO" ~ "MONOLE",
      LBTESTCD == "NEUT" ~ "NEUTLE"
    ),
    LBTEST = case_when(
      LBTESTCD == "BASOLE" ~ "Basophils/Leukocytes",
      LBTESTCD == "EOSLE" ~ "Eosinophils/Leukocytes",
      LBTESTCD == "LYMLE" ~ "Lymphocytes/Leukocytes",
      LBTESTCD == "MONOLE" ~ "Monocytes/Leukocytes",
      LBTESTCD == "NEUTLE" ~ "Neutrophils/Leukocytes"
    ),
    LBSTNRLO = case_when(
      LBTESTCD == "BASOLE" ~ 0.00,
      LBTESTCD == "EOSLE" ~ 0.00,
      LBTESTCD == "LYMLE" ~ 0.22,
      LBTESTCD == "MONOLE" ~ 0.00,
      LBTESTCD == "NEUTLE" ~ 0.40
    ),
    LBSTNRHI = case_when(
      LBTESTCD == "BASOLE" ~ 0.02,
      LBTESTCD == "EOSLE" ~ 0.04,
      LBTESTCD == "LYMLE" ~ 0.44,
      LBTESTCD == "MONOLE" ~ 0.07,
      LBTESTCD == "NEUTLE" ~ 0.70
    ),
    LBSTRESN = rand_diff,
    LBSTRESU = "FRACTION",
    LBSTRESC = as.character(LBSTRESN),
    LBORRES = LBSTRESC,
    LBORRESU = LBSTRESU,
    LBORNRLO = LBSTNRLO,
    LBORNRHI = LBSTNRHI,
    LBNRIND = case_when(
      LBSTRESN < LBSTNRLO ~ "LOW",
      LBSTRESN > LBSTNRHI ~ "HIGH",
      TRUE ~ "NORMAL"
    )
  )


# Replace original rows with new records
admiral_lb <- lb %>%
  anti_join(lb_diff, by = c("USUBJID", "VISIT", "LBSEQ")) %>%
  rbind(lb_diff)

attr(admiral_lb, "label") <- "Laboratory Test Results"

save(admiral_lb, file = "data/admiral_lb.rda", compress = "bzip2")
