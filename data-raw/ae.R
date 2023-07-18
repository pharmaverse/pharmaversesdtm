# Update AE by adding AELAT variable for admiraloptha package

library(dplyr)
library(admiral)
library(metatools)
library(haven)

raw_ae <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/ae.xpt?raw=true") # nolint
raw_suppae <- read_xpt("https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/suppae.xpt?raw=true") # nolint
ae <- convert_blanks_to_na(raw_ae)
suppae <- convert_blanks_to_na(raw_suppae)

# create possible AELAT values - as collected on CRF ----
lat <- c("LEFT", "RIGHT", "BOTH")

# create AELAT variable ----
# with random assignment of lat values where AESOC is "EYE DISORDERS"
# Set seed so that result stays the same for each run
set.seed(1)
ae$AELAT <- if_else(ae$AESOC == "EYE DISORDERS",
  apply(ae, 1, function(x) sample(lat, 1)),
  NA_character_
)
admiral_ae <- ae %>%
  add_labels(AELAT = "Laterality")

attr(admiral_ae, "label") <- "Adverse Events"

# Save dataset ----
ae <- admiral_ae
save(ae, file = "data/ae.rda", compress = "bzip2")
usethis::use_data(suppae, overwrite = TRUE)
