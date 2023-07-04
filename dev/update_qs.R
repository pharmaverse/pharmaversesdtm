#' Description : create VFQ questionnaire test data for ADMIRAL Ophtha

library(metatools)
library(dplyr)

# take qs test data from previous ADMIRAL project ====
data("raw_qs")

# create new QS data - keep standard variables from previous ADMIRAL project's QS ====
qs1 <- raw_qs %>%
  # select standard variables
  select(STUDYID, DOMAIN, USUBJID, QSBLFL, VISITNUM, VISIT, VISITDY, QSDTC, QSDY) %>%
  # keep unique subjects and visits per subject
  group_by(USUBJID, VISITDY) %>%
  unique() %>%
  ungroup()

dummy_param <- tibble(tribble(
  ~QSTEST,                                 ~QSSTRESC,            ~QSSTRESN,
  "Your Overall Health Is",                "GOOD",                       1,
  "Eyesight Using Both Eyes Is",           "FAIR",                       3,
  "How Often You Worry About Eyesight",    "RARELY",                     4,
  "How Much Pain in and Around Eyes",      "NO",                         3,
  "Difficulty Reading Newspapers",         "SOME DIFFICULTY",            2,
  "Difficulty Doing Work/Hobbies",         "NO DIFFICULTY",              1,
  "Difficulty Finding on Crowded Shelf",   "NO DIFFICULTY",              1,
  "Difficulty Reading Street Signs",       "SOME DIFFICULTY",            2,
  "Difficulty Going Down Step at Night",   "SOME DIFFICULTY",            2,
  "Difficulty Noticing Objects to Side",   "SOME DIFFICULTY",            2,
  "Difficulty Seeing How People React",    "SOME DIFFICULTY",            2,
  "Difficulty Picking Out Own Clothes",    "NO DIFFICULTY",              1,
  "Difficulty Visiting With People",       "NO DIFFICULTY",              1,
  "Difficulty Going Out to See Movies",    "SOME DIFFICULTY",            2,
  "Are You Currently Driving",             "YES",                        1,
  "Never Driven or Given Up Driving",      "NO",                         3,
  "Main Reason You Gave Up Driving",       "NO",                         3,
  "Difficulty Driving During Daytime",     "NO",                         3,
  "Difficulty Driving at Night",           "YES",                        1,
  "Driving in Difficult Conditions",       "YES",                        1,
  "Eye Pain Keep From Doing What Like",    "YES",                        1,
  "I Stay Home Most of the Time",          "NO",                         3,
  "I Feel Frustrated a Lot of the Time",   "SOMETIMES",                  2,
  "I Need a Lot of Help From Others",      "SOMETIMES",                  2,
  "Worry I'll Do Embarrassing Things",     "YES",                        1,
  "Difficulty Reading Small Print",        "VERY DIFFICULT",             3,
  "Difficulty Figure Out Bill Accuracy",   "SOME DIFFICULTY",            2,
  "Difficulty Shaving or Styling Hair",    "NO DIFFICULTY",              1,
  "Difficulty Recognizing People",         "NO DIFFICULTY",              1,
  "Difficulty Taking Part in Sports",      "SOME DIFFICULTY",            2,
  "Difficulty Seeing Programs on TV",      "NO DIFFICULTY",              1,
))

# create dummy qs ====
dummy_qs <- dummy_param %>%
  mutate(
    QSORRES = QSSTRESC,
    QSTESTCD = paste0("VFQ", row_number()),
    QSCAT = "NEI VFQ-25",
    QSSCAT = "Original Response"
  )

# merge standard QS with parameters and result variables from temp QS data
ophtha_qs <- merge(qs1, dummy_qs) %>%
  group_by(USUBJID) %>%
  # create QSSEQ based on VFQ QS parameters
  mutate(QSSEQ = row_number()) %>%
  arrange(USUBJID, QSSEQ) %>%
  select(
    STUDYID, DOMAIN, USUBJID, QSSEQ, QSTESTCD, QSTEST, QSCAT, QSSCAT,
    QSORRES, QSSTRESC, QSSTRESN, QSBLFL, VISITNUM,
    VISIT, VISITDY, QSDTC, QSDY
  ) %>%
  ungroup()

# Add Ophthamology questionnaire to CDISC to questionnaire
admiral_qs <- raw_qs %>%
  bind_rows(ophtha_qs) %>%
  add_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    QSSEQ = "Sequence Number",
    QSTESTCD = "Question Short Name",
    QSTEST = "Question Name",
    QSCAT = "Category of Question",
    QSSCAT = "Subcategory for Question",
    QSORRES = "Findings in Original Units",
    QSORRESU = "Original Units",
    QSSTRESC = "Character Result/Finding in Std Format",
    QSSTRESN = "Numeric Result/Finding in Standard Units",
    QSSTRESU = "Standard Units",
    QSBLFL = "Baseline Flag",
    QSDRVFL = "Derived Flag",
    VISITNUM = "Visit Number",
    VISIT = "Visit Name",
    VISITDY = "Planned Study Day of Visit",
    QSDTC = "Date/Time of Finding",
    QSDY = "Study Day of Finding"
  )

save(admiral_qs, file = "data/admiral_qs.rda", compress = "bzip2")
