# Dataset: lb_metabolic
# Description: Create LB test SDTM dataset for metabolic studies

# Load libraries ----
library(dplyr)
library(admiral)
library(purrr)

# Read input data ----
lb <- pharmaversesdtm::lb

# Subset participants (based on admiralmetabolic_dm) ----
lb_metabolic_1 <- lb %>%
  filter(USUBJID %in% c(
    "01-701-1015", "01-701-1023", "01-701-1028",
    "01-701-1033", "01-701-1034"
  ))

# Keep only metabolically relevant parameters ----
lb_metabolic_2 <- lb_metabolic_1 %>%
  filter(LBTESTCD %in% c("ALB", "ALP", "AST", "CHOL", "GLUC", "GGT"))

# Define new parameters ----
# Setup data
visits <- c(
  "SCREENING 1", "WEEK 2", "WEEK 6", "WEEK 8",
  "WEEK 12", "WEEK 16", "WEEK 20", "WEEK 24", "WEEK 26"
)
subject_ids <- c(
  "01-701-1015", "01-701-1023", "01-701-1028", "01-701-1033",
  "01-701-1034"
)
visit_subject_grid <- expand.grid(
  VISIT = visits,
  USUBJID = subject_ids,
  stringsAsFactors = FALSE
)

# Generate data
set.seed(123)
metabolic_data_1 <- map2(
  .x = visit_subject_grid$VISIT,
  .y = visit_subject_grid$USUBJID,
  .f = function(x, y) {
    tibble::tribble(
      ~VISIT, ~USUBJID, ~LBTESTCD, ~LBTEST, ~LBORNRLO, ~LBORNRHI, ~LBORRES, ~LBORRESU,
      x, y, "INSULIN", "Insulin", "18", "173", round(runif(1, min = 35, max = 350), 1), "pmol/L",
      x, y, "HBA1CHGB", "Hemoglobin A1C/Hemoglobin", "4.0", "5.7", round(runif(1, min = 4.0, max = 9.0), 1), "%",
      x, y, "TRIG", "Triglycerides", "0.0", "2.0", round(runif(1, min = 0.8, max = 4.0), 1), "mmol/L"
    )
  }
) %>%
  list_rbind() %>%
  mutate(LBORRES = as.character(LBORRES))

# Join and filter based on variables from lb
lb_metabolic_2_subset <- lb_metabolic_2 %>%
  dplyr::select(
    USUBJID, VISIT, STUDYID, VISITDY, LBDTC,
    LBDY, LBBLFL, DOMAIN, VISITNUM
  ) %>%
  dplyr::distinct()

metabolic_data_2 <- metabolic_data_1 %>%
  dplyr::inner_join(lb_metabolic_2_subset,
    by = c("USUBJID", "VISIT")
  )

# Set additional variables
metabolic_data_3 <- metabolic_data_2 %>%
  mutate(
    LBCAT = "CHEMISTRY",
    LBSTRESC = LBORRES,
    LBSTRESN = as.numeric(LBORRES),
    LBSTRESU = LBORRESU,
    LBSTNRLO = as.numeric(LBORNRLO),
    LBSTNRHI = as.numeric(LBORNRHI),
    LBNRIND = dplyr::case_when(
      LBSTRESN < LBORNRLO ~ "LOW",
      LBSTRESN > LBORNRHI ~ "HIGH",
      TRUE ~ "NORMAL"
    )
  )

# Bind metabolic parameters with lb ----
lb_metabolic_3 <- lb_metabolic_2 %>%
  bind_rows(metabolic_data_3)

# Re-assign labels
walk(
  .x = colnames(lb_metabolic_3),
  .f = \(x) attr(lb_metabolic_3[[x]], "label") <<- attr(lb_metabolic_2[[x]], "label")
)

# Define analysis sequence number ----
lb_metabolic_4 <- lb_metabolic_3 %>%
  dplyr::group_by(USUBJID) %>%
  dplyr::arrange(VISIT, LBTESTCD) %>%
  dplyr::mutate(LBSEQ = row_number())

# Save dataset ----
lb_metabolic <- lb_metabolic_4
attr(lb_metabolic, "label") <- "Laboratory Test Results"
usethis::use_data(lb_metabolic, overwrite = TRUE)
