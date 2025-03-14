#' Dataset: qs_metabolic
#' Description: Create QS test SDTM dataset for metabolic studies,
#' containing COEQ data (Control of Eating Questionnaire)
#' Note: the University of Leeds are the copyright holders of the CoEQ and the test data included within`{admiralmetabolic}`
#' is for not-for-profit use only within `{admiralmetabolic}` and `pharmaverse`-related examples/documentation. Any persons
#' or companies wanting to use the CoEQ should request a license to do so from the following
#' [link](https://licensing.leeds.ac.uk/product/control-of-eating-questionnaire-coeq).

# Load libraries ----

library(tibble)
library(dplyr)
library(stringr)

# Set seed for random data generation ----
set.seed(3.14159265)

# Read input data ----

vs_metabolic <- pharmaversesdtm::vs_metabolic

# Set up questions, codes and categories ----
coeq_structure <- tibble::tribble(
  ~QSCAT, ~QSTESTCD, ~QSTEST,
  "COEQ", "COEQ01", "How hungry have you felt?",
  "COEQ", "COEQ02", "How full have you felt?",
  "COEQ", "COEQ03", "How strong was your desire to eat sweet foods?",
  "COEQ", "COEQ04", "How strong was your desire to eat savoury foods?",
  "COEQ", "COEQ05", "How happy have you felt?",
  "COEQ", "COEQ06", "How anxious have you felt?",
  "COEQ", "COEQ07", "How alert have you felt?",
  "COEQ", "COEQ08", "How contented have you felt?",
  "COEQ", "COEQ09", "During the last 7 days how often have you had food cravings?",
  "COEQ", "COEQ10", "How strong have any food cravings been?",
  "COEQ", "COEQ11", "How difficult has it been to resist any food cravings?",
  "COEQ", "COEQ12", "How often have you eaten in response to food cravings?",
  "COEQ", "COEQ13", "Chocolate or chocolate flavoured foods",
  "COEQ", "COEQ14", "Other sweet foods (cakes, pastries, biscuits, etc)",
  "COEQ", "COEQ15", "Fruit or fruit juice",
  "COEQ", "COEQ16", "Dairy foods (cheese, yoghurts, milk, etc)",
  "COEQ", "COEQ17", "Starchy foods (bread, rice, pasta, etc)",
  "COEQ", "COEQ18", "Savoury foods (french fries, crisps, burgers, pizza, etc)",
  "COEQ", "COEQ19", "Generally, how difficult has it been to control your eating?",
  "COEQ", "COEQ20", "Which one food makes it most difficult for you to control eating?",
  "COEQ", "COEQ21", "How difficult has it been to resist eating this food during the last 7 days?",
)

# Use visit schedule and days from VS ----
visit_schedule <- vs_metabolic %>%
  select(STUDYID, USUBJID, VISIT, VISITNUM, VISITDY, VSDTC, VSDY) %>%
  filter(str_detect(VISIT, "AMBUL|RETRIEVAL", negate = TRUE)) %>%
  rename(QSDTC = VSDTC, QSDY = VSDY) %>%
  distinct()

# Cross join to get questions at each visit ----
qs_metabolic_shell <- visit_schedule %>%
  cross_join(coeq_structure)

# Simulate question answers ----
qs_metabolic_results <- qs_metabolic_shell %>%
  mutate(
    DOMAIN = "QS",
    QSORRES = as.character(round(runif(n(), min = 0, max = 100))),
    QSORRESU = "mm",
    QSSTRESU = "mm",
    QSSTRESN = as.numeric(QSORRES),
    QSSTRESC = QSORRES,
    QSBLFL = if_else(VISIT == "BASELINE", "Y", NA_character_)
  ) %>%
  # Update the free text question (COEQ20)
  mutate(
    QSSTRESC = case_when(
      QSTESTCD == "COEQ20" & QSSTRESN < 33 ~ "Ice Cream",
      QSTESTCD == "COEQ20" & QSSTRESN < 66 ~ "Pizza",
      QSTESTCD == "COEQ20" ~ "Pasta",
      TRUE ~ QSSTRESC
    )
  ) %>%
  mutate(
    QSSTRESN = if_else(QSTESTCD == "COEQ20", NA, QSSTRESN),
    QSORRES = if_else(QSTESTCD == "COEQ20", QSSTRESC, QSORRES),
    QSORRESU = if_else(QSTESTCD == "COEQ20", NA_character_, QSORRESU),
    QSSTRESU = if_else(QSTESTCD == "COEQ20", NA_character_, QSSTRESU),
  )

# Order variables, sort and add sequence number ----
qs_metabolic_seq <- qs_metabolic_results %>%
  select(
    STUDYID, USUBJID, DOMAIN, VISIT, VISITNUM, VISITDY, QSBLFL, QSDTC, QSDY,
    QSCAT, QSTEST, QSTESTCD, QSORRES, QSORRESU, QSSTRESC, QSSTRESN, QSSTRESU
  ) %>%
  arrange(STUDYID, USUBJID, VISITNUM, QSTESTCD) %>%
  group_by(USUBJID) %>%
  mutate(QSSEQ = row_number()) %>%
  ungroup()

# Add labels to variables that don't have them yet ----
labels <- list(
  DOMAIN = "Domain Abbreviation",
  QSBLFL = "Baseline Flag",
  QSCAT = "Category for Questionnaire",
  QSTEST = "Questionnaire Test Name",
  QSTESTCD = "Questionnaire Test Short Name",
  QSORRES = "Result or Finding in Original Units",
  QSORRESU = "Original Units",
  QSSTRESC = "Character Result/Finding in Std Format",
  QSSTRESN = "Numeric Result/Finding in Standard Units",
  QSSTRESU = "Standard Units",
  QSSEQ = "Sequence Number"
)

for (var in names(labels)) {
  attr(qs_metabolic_seq[[var]], "label") <- labels[[var]]
}

# Label QS dataset ----
attr(qs_metabolic_seq, "label") <- "Questionnaires"

# Final dataset ----
qs_metabolic <- qs_metabolic_seq

# Save dataset ----
usethis::use_data(qs_metabolic, overwrite = TRUE)
