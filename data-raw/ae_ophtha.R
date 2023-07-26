# Update AE by adding AELAT variable for admiralophtha package
library(dplyr)
library(admiral)
library(metatools)
library(haven)

# Start from standard AE dataset from this package - this should be
# in the environment already if devtools::load_all() has been run
ae_ophtha <- ae

# create possible AELAT values - as collected on CRF ----
lat <- c("LEFT", "RIGHT", "BOTH")

# create AELAT variable ----
# with random assignment of lat values where AESOC is "EYE DISORDERS"
# Set seed so that result stays the same for each run
set.seed(1)

ae_ophtha$AELAT <- if_else(ae_ophtha$AESOC == "EYE DISORDERS",
                           apply(ae_ophtha, 1, function(x) sample(lat, 1)),
                           NA_character_
)

ae_ophtha <- ae_ophtha %>%
  add_labels(AELAT = "Laterality")

attr(ae_ophtha, "label") <- "Adverse Events"

# Save dataset ----
save(ae_ophtha, file = "data/ae_ophtha.rda", compress = "bzip2")


