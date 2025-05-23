#' Script to Automatically Generate R Documentation Files for Datasets
#'
#' This script generates R documentation files for datasets in the 'pharmaversesdtm' package.
#' It reads metadata from a JSON file ('inst/extdata/sdtms-specs.json') to create properly formatted
#' documentation. The script ensures consistency and reduces manual intervention by automating the process.
#'
#' ## Key Features
#' - Reads metadata from a structured JSON file.
#' - Automatically generates `.R` documentation files in the 'R' directory.
#' - Handles missing or incomplete metadata with sensible defaults.
#' - Provides hyperlinks to dataset sources in the documentation.
#'
#' ## Dependencies
#' - `jsonlite`: For reading JSON metadata.
#' - `roxygen2`: For generating the final documentation from `.R` files.
#'
#' ## Usage Notes
#' - Do not manually edit the generated files, as they are subject to automatic regeneration.
#' - Update the JSON metadata file for changes and rerun this script.

# Load required library
library(jsonlite)

# Load metadata from JSON file
specs <- fromJSON("inst/extdata/sdtms-specs.json")$`sdtms-specs`

# Helper function to retrieve the label attribute for a column
#' @description Retrieve column label attribute or return a default.
#' @param data The dataset containing the column.
#' @param col_name The name of the column.
#' @return A string containing the label attribute or "undocumented field".
get_attr <- function(data, col_name) {
  att <- attr(data[[col_name]], "label")
  if (is.null(att) || att == "null") {
    att <- "undocumented field"
  }
  return(att)
}

#' @description Create an HTML hyperlink for use in documentation, return plain text if the source is text,
#' or a default message if the URL is invalid.
#' @param url The URL to link to or plain text if the source is not a URL.
#' @param link_text Optional text for the hyperlink. Defaults to an empty string.
#' @return A string containing the HTML anchor tag, plain text if the source is text, or a default message for invalid URLs.
generate_hyperlink <- function(url, link_text = "") {
  # Define a basic regular expression for URL validation
  url_pattern <- "^(https?://)"

  # Check if the input is a valid URL
  if (!nzchar(url) || is.null(url)) {
    return("The source is inaccessible.")
  } else if (!grepl(url_pattern, url)) {
    # If the source is plain text (not a URL), return it as-is
    return(url)
  }

  # Generate and return the hyperlink if the URL is valid
  paste0("[Access the source of the ", link_text, " dataset.](", url, ")")
}


# Main function to write documentation for a dataset
#' @description Generate R documentation for a dataset.
#' @param data The dataset object.
#' @param dataset_name The name of the dataset.
#' @param dataset_label The label for the dataset. Defaults to "No label available".
#' @param dataset_description A description of the dataset. Defaults to "No description available".
#' @param dataset_author The author of the dataset. Defaults to NULL if not available.
#' @param dataset_source The source of the dataset, as a URL or text. Defaults to "No source available".
write_doc <- function(data, dataset_name, dataset_label = "No label available",
                      dataset_description = "No description available", dataset_author = NULL,
                      dataset_source = "No source available") {
  dataset_source <- generate_hyperlink(dataset_source, dataset_label)
  doc_string <- paste(
    "# This file is automatically generated by data-raw/create_sdtms_data.R.",
    "# For updating it please edit inst/extdata/sdtms-specs.json and rerun create_sdtms_data.R.",
    "# Manual edits are not recommended, as changes may be overwritten.",
    sprintf("#' %s", dataset_label),
    "#'",
    sprintf("#' %s", dataset_description),
    "#'",
    sprintf("#' @name %s", dataset_name),
    sprintf("#' @title %s", dataset_label),
    sprintf("#' @keywords dataset"),
    sprintf("#' @description %s", dataset_description),
    "#' @docType data",
    sprintf("#' @format A data frame with %s columns:", ncol(data)),
    "#'   \\describe{",
    paste(sapply(names(data), function(col_name) {
      paste(sprintf("#'     \\item{%s}{%s}", col_name, get_attr(data, col_name)))
    }, USE.NAMES = FALSE), collapse = "\n"),
    "#'   }",
    "#'",
    sprintf("#' @source %s", dataset_source),
    sep = "\n"
  )

  if (!is.null(dataset_author) && dataset_author != "") {
    doc_string <- paste(doc_string, sprintf("#' @author %s", dataset_author), sep = "\n")
  }
  doc_string <- paste(doc_string, sprintf("\"%s\"", dataset_name), sep = "\n")
  writeLines(doc_string, con = file.path("R", paste0(dataset_name, ".R")))
}

# List datasets and generate documentation
datasets <- data(package = "pharmaversesdtm")$results[, "Item"]
for (dataset_name in datasets) {
  data(list = dataset_name, package = "pharmaversesdtm")
  dataset <- get(dataset_name)
  metadata <- specs[specs$name == dataset_name, ]

  if (nrow(metadata) == 0) {
    warning(sprintf("No metadata found for %s - using default values.", dataset_name), call. = FALSE)
    dataset_label <- "No label available"
    dataset_description <- "No description available"
    dataset_author <- NULL
    dataset_source <- "No source available"
  } else {
    dataset_label <- ifelse(!is.na(metadata$label), metadata$label, "No label available")
    dataset_description <- ifelse(!is.na(metadata$description), metadata$description, "No description available")
    dataset_author <- if (!is.na(metadata$author) && metadata$author != "") metadata$author else NULL
    dataset_source <- ifelse(!is.na(metadata$source), metadata$source, "No source available")
  }

  write_doc(dataset, dataset_name, dataset_label, dataset_description, dataset_author, dataset_source)
}

# Finalize the documentation
roxygen2::roxygenize(".", roclets = c("rd", "collate", "namespace"))
