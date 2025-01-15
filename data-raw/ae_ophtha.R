# Dataset: ae_ophtha
# Description: Add ophtha-specific AELAT variable to existing AE dataset

# Load libraries -----
library(dplyr)
library(admiral)
library(metatools)
library(haven)

# Create ae_ophtha ----
# Start from standard AE dataset from this package - this should be
# in the environment already if devtools::load_all() has been run
ae_ophtha <- ae

## Create possible AELAT values - as collected on CRF ----
lat <- c("LEFT", "RIGHT", "BOTH")

## Create AELAT, AELOC variable ----
# Use random assignment of lat values where AESOC is "EYE DISORDERS"
# Set seed so that result stays the same for each run
set.seed(1)

ae_ophtha$AELAT <- if_else(ae_ophtha$AESOC == "EYE DISORDERS",
  apply(ae_ophtha, 1, function(x) sample(lat, 1)),
  NA_character_
)

ae_ophtha <- ae_ophtha %>%
  mutate(AELOC = if_else(AESOC == "EYE DISORDERS", "EYE", NA_character_))

ae_ophtha <- ae_ophtha %>%
  add_labels(AELAT = "Laterality") %>%
  add_labels(AELOC = "Location")

# Label dataset ----
attr(ae_ophtha, "label") <- "Adverse Events"

# Save dataset ----
usethis::use_data(ae_ophtha, overwrite = TRUE)
