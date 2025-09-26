# Dataset: qs_ophtha
# Description: NEI Visual Functioning Questionnaire 25 (VFQ) test SDTM data
# for ophthalmology studies, based on QS dataset from CDISC pilot study

# Load libraries -----
library(haven)
library(admiral)
library(dplyr)
library(stringr)
library(metatools)

# Make qs_ophtha dataset ----

# Get CDISC qs dataset so that we have the right structure ----
raw_qs <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/qs.xpt?raw=true") # nolint
qs <- convert_blanks_to_na(raw_qs)

## set seed to get same results each run
set.seed(999)

## create new QS data - keep standard variables from QS ----
qs1 <- qs %>%
  # select standard variables
  select(STUDYID, DOMAIN, USUBJID, QSBLFL, VISITNUM, VISIT, VISITDY, QSDTC, QSDY) %>%
  # keep unique subjects and visits per subject
  group_by(USUBJID, VISITDY) %>%
  unique()

## create dummy parameters and results ----
dummy_param <- data.frame(
  QSTEST = c(
    "Your Overall Health Is",
    "Eyesight Using Both Eyes Is",
    "How Often You Worry About Eyesight",
    "How Often Pain in and Around Eyes",
    "Difficulty Reading Newspapers",
    "Difficulty Doing Work/Hobbies",
    "Difficulty Finding on Crowded Shelf",
    "Difficulty Reading Street Signs",
    "Difficulty Going Down Step at Night",
    "Difficulty Noticing Objects to Side",
    "Difficulty Seeing How People React",
    "Difficulty Picking Out Own Clothes",
    "Difficulty Visiting With People",
    "Difficulty Going Out to See Movies",
    "Are You Currently Driving",
    "Difficulty Driving During Daytime",
    "Difficulty Driving at Night",
    "Driving in Difficult Conditions",
    "Eye Pain Keep You From Doing What You Like",
    "I Stay Home Most of the Time",
    "I Feel Frustrated a Lot of the Time",
    "I Need a Lot of Help From Others",
    "Worry I'll Do Embarrassing Things",
    "Difficulty Reading Small Print",
    "Difficulty Figure Out Bill Accuracy",
    "Difficulty Shaving or Styling Hair",
    "Difficulty Recognizing People",
    "Difficulty Taking Part in Sports",
    "Difficulty Seeing Programs on TV"
  ),
  QSTESTCD = c(
    "VFQ101", "VFQ102", "VFQ103", "VFQ104", "VFQ105", "VFQ106", "VFQ107", "VFQ108", "VFQ109", "VFQ110", "VFQ111",
    "VFQ112", "VFQ113", "VFQ114", "VFQ115", "VFQ115C", "VFQ116", "VFQ116A", "VFQ119", "VFQ120", "VFQ121", "VFQ124",
    "VFQ125", "VFQ1A03", "VFQ1A04", "VFQ1A05", "VFQ1A06", "VFQ1A07", "VFQ1A08"
  )
) %>%
  mutate(
    QSCAT = "NEI VFQ-25",
    QSSCAT = "Original Response"
  )

## dummy answers ----

# difficulty in performing tasks
difficulty_res <- c(
  "SOME DIFFICULTY",
  "NO DIFFICULTY",
  "VERY DIFFICULT"
)
difficulty_resn <- c(1:3)
difficulty <- setNames(difficulty_res, difficulty_resn)

# frequency answers
freq_res <- c("SOMETIMES", "FREQUENTLY", "RARELY", "NEVER")
freq_resn <- c(1:4)
frequency <- setNames(freq_res, freq_resn)

# quality answers
qual_res <- c("VERY GOOD", "GOOD", "FAIR", "POOR", "VERY POOR")
qual_resn <- c(1:5)
quality <- setNames(qual_res, qual_resn)

# yesno answers
yn_res <- c("YES", "NO")
yn_resn <- c(1:2)
yesno <- setNames(yn_res, yn_resn)

answers <- c(difficulty_res, freq_res, qual_res, yn_res)
answersn <- c(difficulty_resn, freq_resn, qual_resn, yn_resn)

## assign answers to questions randomly for each subjects ----

# take unique subject/visit combinations
subjects_visits <- qs1 %>%
  ungroup() %>%
  select(USUBJID, VISIT) %>%
  distinct()

dummy_param_res_by_subj_visit <- merge(subjects_visits, dummy_param) %>%
  mutate(QSORRES = case_when(
    str_detect(QSTEST, "Difficult") ~ sample(difficulty, size = nrow(.), replace = T),
    str_detect(QSTEST, "How") ~ sample(frequency, size = nrow(.), replace = T),
    str_detect(QSTEST, "Are You") ~ sample(yesno, size = nrow(.), replace = T),
    str_detect(QSTEST, "Overall Health") ~ sample(quality, size = nrow(.), replace = T),
    str_detect(QSTEST, "Eyesight") ~ sample(quality, size = nrow(.), replace = T),
    TRUE ~ sample(frequency, size = nrow(.), replace = T)
  )) %>%
  mutate(
    QSSTRESC = QSORRES,
    QSORRESU = "",
    QSSTRESU = "",
    QSDRVFL = ""
  )

## merge standard QS with parameters and result variables from temp QS data ----
qs2 <- merge(qs1, dummy_param_res_by_subj_visit, by = c("USUBJID", "VISIT")) %>%
  group_by(USUBJID) %>%
  # create QSSEQ based on VFQ QS parameters
  mutate(QSSEQ = row_number()) %>%
  arrange(USUBJID, QSSEQ)

## create QSSTRESN ----
qs3 <- qs2 %>%
  group_by(QSTEST) %>%
  # create numeric var for std result
  mutate(QSSTRESN = as.numeric(factor(QSSTRESC))) %>%
  select(
    STUDYID, DOMAIN, USUBJID, QSSEQ, QSTESTCD, QSTEST, QSCAT, QSSCAT, QSORRES, QSORRESU, QSSTRESC, QSSTRESN, QSSTRESU,
    QSBLFL, QSDRVFL, VISITNUM, VISIT, VISITDY, QSDTC, QSDY
  ) %>%
  ungroup()

# Label variables ----
qs3 <- qs3 %>%
  add_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    QSSEQ = "Sequence Number",
    QSTESTCD = "Question Short Name",
    QSTEST = "Question Name",
    QSCAT = "Category of Question",
    QSSCAT = "Subcategory for Question",
    QSORRES = "Finding in Original Units",
    QSORRESU = "Original Units",
    QSSTRESC = "Character Result/Finding in Std Format",
    QSSTRESN = "Numeric Finding in Standard Units",
    QSSTRESU = "Standard Units",
    QSBLFL = "Baseline Flag",
    QSDRVFL = "Derived Flag",
    VISITNUM = "Visit Number",
    VISIT = "Visit Name",
    VISITDY = "Planned Study Day of Visit",
    QSDTC = "Date/Time of Finding",
    QSDY = "Study Day of Finding"
  )

qs_ophtha <- qs3

# Save dataset ----
usethis::use_data(qs_ophtha, overwrite = TRUE)
