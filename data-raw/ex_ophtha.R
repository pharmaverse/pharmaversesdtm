library(dplyr)
library(tidyselect)
data("dm")
data("ex")

# Make ex_ophtha dataset
ex_ophtha <- dm %>%
  # Start by merging on ophtha_dm to use the SUBJID variable
  select(USUBJID, SUBJID) %>%
  right_join(ex, by = c("USUBJID"), multiple = "all") %>%
  # Create EXLOC & EXLAT, change EXROUTE & EXDOSFRM to something eye-related
  mutate(
    EXLOC = "EYE",
    EXDOSFRM = "INJECTION",
    EXDOSFRQ = "ONCE",
    EXLAT = ifelse(as.integer(SUBJID) %% 2 == 0, "LEFT", "RIGHT"),
    EXROUTE = "INTRAVITREAL"
  ) %>%
  # Drop SUBJID and reorder variables
  select(
    "USUBJID", "STUDYID", "DOMAIN", "EXSEQ", "EXTRT", "EXDOSE",
    "EXDOSU", "EXDOSFRM", "EXDOSFRQ", "EXROUTE", "EXLOC",
    "EXLAT", "VISITNUM", "VISIT", "VISITDY", "EXSTDTC",
    "EXENDTC", "EXSTDY", "EXENDY"
  )

# Label new variables
attr(ex_ophtha$EXLOC, "label") <- "Location of Dose Administration"
attr(ex_ophtha$EXLAT, "label") <- "Laterality"
attr(ex_ophtha$EXROUTE, "label") <- "Route of Administration"
attr(ex_ophtha$EXDOSFRM, "label") <- "Dose Form"
attr(ex_ophtha$EXDOSFRQ, "label") <- "Dose Frequency per Interval"

# Save Dataset
save(ex_ophtha, file = file.path("data", "ex_ophtha.rda"), compress = "bzip2")
