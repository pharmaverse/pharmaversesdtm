# Update AE by adding AELAT variable for admiraloptha package

library(dplyr)
library(admiral)
library(metatools)

data("raw_ae")
ae <- convert_blanks_to_na(raw_ae)

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
save(admiral_ae, file = "data/admiral_ae.rda", compress = "bzip2")
