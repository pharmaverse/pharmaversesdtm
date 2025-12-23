# source in temporary environment to avoid changing the global environment
temp_env <- new.env(parent = globalenv())

source(system.file("lintr/linters.R", package = "admiraldev"), local = temp_env)

linters <- temp_env$admiral_linters()

# remove temporary environment to avoid lintr warning regarding "unused settings"
rm(temp_env)

exclusions <- list(
  "R/" = Inf,
  "inst" = list(undesirable_function_linter = Inf),
  "vignettes" = list(undesirable_function_linter = Inf),
  "data-raw" = list(
    undesirable_function_linter = Inf,
    line_length_linter = Inf
  )
)
