#' An example function as expected by the `get_terms_fun` parameter of
#' `admiral::create_query_data()`
#'
#' @param basket_select A basket_select object defining the terms
#'
#' @param version MedDRA version
#'
#' @param keep_id Should `GRPID` be included in the output?
#'
#' @param temp_env Temporary environment
get_terms <- function(basket_select,
                      version,
                      keep_id,
                      temp_env) {
  if (basket_select$type == "smq") {
    if (is.null(temp_env$smq_db)) {
      data("smq_db", envir = temp_env)
    }
    if (!is.null(basket_select$name)) {
      is_in_smq <- temp_env$smq_db$smq_name == basket_select$name
    } else {
      is_in_smq <- temp_env$smq_db$smq_id == basket_select$id
    }
    if (basket_select$scope == "NARROW") {
      is_in_scope <- temp_env$smq_db$scope == "narrow"
    } else {
      is_in_scope <- rep(TRUE, nrow(temp_env$smq_db))
    }
    if (keep_id) {
      select_id <- c(GRPID = "smq_id")
    } else {
      select_id <- NULL
    }
    keep_cols <- c(
      TERMNAME = "termname",
      SRCVAR = "termvar",
      GRPNAME = "smq_name",
      select_id
    )

    structure(
      temp_env$smq_db[is_in_smq & is_in_scope, keep_cols],
      names = names(keep_cols)
    )
  } else if (basket_select$type == "sdg") {
    if (is.null(temp_env$sdg_db)) {
      data("sdg_db", envir = temp_env)
    }
    if (!is.null(basket_select$name)) {
      is_in_sdq <- temp_env$sdg_db$sdg_name == basket_select$name
    } else {
      is_in_sdq <- temp_env$sdg_db$sdg_id == basket_select$id
    }
    if (keep_id) {
      select_id <- c(GRPID = "sdg_id")
    } else {
      select_id <- NULL
    }
    keep_cols <- c(
      TERMNAME = "termname",
      SRCVAR = "termvar",
      GRPNAME = "sdg_name",
      select_id
    )

    structure(
      temp_env$sdg_db[is_in_sdq, keep_cols],
      names = names(keep_cols)
    )
  }
}
