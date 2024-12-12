generate_datasets <- function(exclusion_list = c("generate_datasets.R")) {
  # Define the folder containing the scripts
  data_raw_folder <- "data-raw"

  # List all R script files in the folder
  all_scripts <- list.files(data_raw_folder, pattern = "\\.R$", full.names = TRUE)

  # Get the base names of the scripts (to match against the exclusion list)
  script_names <- basename(all_scripts)

  # Filter out the excluded scripts
  scripts_to_run <- all_scripts[!(script_names %in% exclusion_list)]

  # Initialize an error counter and error log
  error_count <- 0
  error_log <- list()

  # Run each script
  for (script in scripts_to_run) {
    tryCatch({
      message(paste("Running:", script))
      source(script)
    }, error = function(e) {
      message(paste("Error running script:", script, "-", e$message))
      # Increment the error counter
      error_count <<- error_count + 1
      # Add to the error log
      error_log[[script]] <<- e$message
    })
  }

  # Summary message
  message("All eligible scripts have been run.")
  if (error_count > 0) {
    message(paste("Number of scripts with errors:", error_count))
    message("Summary of failed scripts:")
    for (script in names(error_log)) {
      message(paste("-", script, ":", error_log[[script]]))
    }
  } else {
    message("No errors encountered.")
  }
}

generate_datasets()
