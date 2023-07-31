library(dplyr)
library(stringr)
library(metatools)
library(haven)
library(admiral)


# from CDISC pilot study ----
sdtm_path <- "https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/" # nolint
raw_qs <- read_xpt(paste0(sdtm_path, "qs", ".xpt?raw=true")) %>%
  convert_blanks_to_na()


# set seed to get same results each run
set.seed(999)

# add vfq data
# create new QS data - keep standard variables from previous ADMIRAL project's QS ====
qs1 <- raw_qs %>%
  # select standard variables
  select(STUDYID, DOMAIN, USUBJID, QSBLFL, VISITNUM, VISIT, VISITDY, QSDTC, QSDY) %>%
  # keep unique subjects and visits per subject
  group_by(USUBJID, VISITDY) %>%
  unique()

# create dummy parameters and results ====
dummy_param <- data.frame(QSTEST = c(
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
)) %>%
  mutate(
    QSTESTCD = paste0("VFQ", row_number()),
    QSCAT = "NEI VFQ-25",
    QSSCAT = "Original Response"
  )

# dummy answers

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

# assign answers to questions randomly for each subjects

# take unique subjects
subjects <- qs1 %>%
  ungroup() %>%
  select(USUBJID) %>%
  distinct()

dummy_param_res_by_subj <- merge(subjects, dummy_param) %>%
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

# merge standard QS with parameters and result variables from temp QS data

qs2 <- merge(qs1, dummy_param_res_by_subj, by = "USUBJID") %>%
  group_by(USUBJID) %>%
  # create QSSEQ based on VFQ QS parameters
  mutate(QSSEQ = row_number()) %>%
  arrange(USUBJID, QSSEQ)

qs3 <- qs2 %>%
  group_by(QSTEST) %>%
  # create numeric var for std result
  mutate(QSSTRESN = as.numeric(factor(QSSTRESC))) %>%
  select(
    STUDYID, DOMAIN, USUBJID, QSSEQ, QSTESTCD, QSTEST, QSCAT, QSSCAT, QSORRES, QSORRESU, QSSTRESC, QSSTRESN, QSSTRESU,
    QSBLFL, QSDRVFL, VISITNUM, VISIT, VISITDY, QSDTC, QSDY
  ) %>%
  ungroup()

# NOTE: the QS2 dataset made above should be stacked below the qs dataset.
# output qs_ophtha.RDS
# remove the original vfq part from admiral_qs
admiral_qs_novfq <- raw_qs %>% filter(QSCAT != "NEI VFQ-25")

qs_ophtha1 <- rbind(admiral_qs_novfq, qs3)

# --SEQ and keep relevant variables;
qs_ophtha2 <- qs_ophtha1 %>%
  select(-QSSEQ) %>%
  arrange(STUDYID, USUBJID, QSCAT, QSTESTCD, QSDTC, VISITNUM)

qs_ophtha3 <- qs_ophtha2 %>%
  group_by(STUDYID, USUBJID) %>%
  mutate(QSSEQ = row_number()) %>%
  select(
    STUDYID, DOMAIN, USUBJID, QSSEQ, QSTESTCD, QSTEST, QSCAT, QSSCAT, QSORRES, QSORRESU, QSSTRESC, QSSTRESN, QSSTRESU,
    QSBLFL, QSDRVFL, VISITNUM, VISIT, VISITDY, QSDTC, QSDY
  ) %>%
  ungroup()

qs_ophtha <- qs_ophtha3

# assign dataset label
attr(qs_ophtha, "label") <- "Questionnaires"

# ---- Save output for temporary usage ----
# save(qs_ophtha, file = "data/qs_ophtha.rda", compress = "bzip2")
usethis::use_data(qs_ophtha, overwrite = TRUE)
