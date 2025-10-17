# Datasets: dm, suppdm
# Description: Standard DM, SUPPDM datasets from CDISC pilot study

# Load libraries -----
library(haven)
library(admiral)
library(dplyr) # <- make sure this is loaded for mutate, coalesce, left_join
library(purrr) # <- for reduce
library(lubridate) # <- for ymd/ymd_hms/years

# Create dm, suppdm ----
sdtm_path <- "https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/" # nolint
raw_dm <- read_xpt(paste0(sdtm_path, "dm", ".xpt?raw=true"))
raw_suppdm <- read_xpt(paste0(sdtm_path, "suppdm", ".xpt?raw=true"))
dm <- convert_blanks_to_na(raw_dm)
suppdm <- convert_blanks_to_na(raw_suppdm)

# Helper: robust ISO date/datetime parse (returns POSIXct or NA)
safe_parse_datetime <- function(x) {
  # try several lubridate parsers
  out <- suppressWarnings(ymd_hms(x, quiet = TRUE, tz = "UTC"))
  na_idx <- is.na(out) & !is.na(x)
  if (any(na_idx)) out[na_idx] <- suppressWarnings(ymd(x[na_idx], quiet = TRUE, tz = "UTC"))
  na_idx <- is.na(out) & !is.na(x)
  if (any(na_idx)) out[na_idx] <- suppressWarnings(ymd_hm(x[na_idx], quiet = TRUE, tz = "UTC"))
  na_idx <- is.na(out) & !is.na(x)
  if (any(na_idx)) out[na_idx] <- suppressWarnings(parse_date_time(x[na_idx], orders = c("Y-m-dTH:M:S", "Y-m-d H:M:S", "Ymd"), tz = "UTC"))
  out
}

# Add BRTHDTC to dm when missing ----
# 1. Prefer existing BRTHDTC if present in raw_dm or dm.
# 2. If missing, attempt to compute approximate birth date = anchor_date - AGE (when AGEU indicates years).
#    anchor_date chosen from DMDTC, RFSTDTC, RFICDTC, RFXSTDTC (in that order).
# 3. If still missing, set a fallback dummy value (configurable below).
fallback_dummy_brthdtc <- "1900-01-01" # dummy date

if (!"BRTHDTC" %in% names(dm)) {
  # If raw_dm had BRTHDTC but conversion lost it, bring it in
  if ("BRTHDTC" %in% names(raw_dm)) {
    dm <- dm %>% mutate(BRTHDTC = as.character(raw_dm$BRTHDTC))
  } else {
    # compute from SUPPDM if present (QNAM == "BRTHDTC")
    if ("QNAM" %in% names(suppdm) && any(suppdm$QNAM == "BRTHDTC")) {
      birth_supp <- suppdm %>%
        filter(QNAM == "BRTHDTC") %>%
        select(USUBJID, QVAL) %>%
        rename(BRTHDTC = QVAL)
      if ("USUBJID" %in% names(dm) && "USUBJID" %in% names(birth_supp)) {
        dm <- dm %>% left_join(birth_supp, by = "USUBJID")
      } else {
        # if join key missing, proceed to compute fallback
        dm <- dm %>% mutate(BRTHDTC = NA_character_)
      }
    } else {
      dm <- dm %>% mutate(BRTHDTC = NA_character_)
    }

    # For any still-missing BRTHDTC, attempt computation from AGE + anchor date
    anchor_cols <- c("DMDTC", "RFSTDTC", "RFICDTC", "RFXSTDTC")
    # create anchor vector (first non-NA in the anchor_cols)
    anchor <- reduce(anchor_cols[anchor_cols %in% names(dm)],
      function(acc, col) coalesce(acc, dm[[col]]),
      .init = NA_character_
    )

    parsed_anchor <- safe_parse_datetime(anchor)

    # compute approximate birth date where possible
    compute_idx <- is.na(dm$BRTHDTC) & !is.na(parsed_anchor) & !is.na(dm$AGE) & dm$AGE > 0
    # consider AGEU indicating years
    ageu_ok <- tolower(coalesce(dm$AGEU, "")) %in% c("years", "year", "yrs", "yrs.", "y", "yr")
    compute_idx <- compute_idx & ageu_ok

    if (any(compute_idx)) {
      approx_birth <- as.Date(parsed_anchor[compute_idx]) - years(floor(dm$AGE[compute_idx]))
      dm$BRTHDTC[compute_idx] <- format(approx_birth, "%Y-%m-%d")
    }

    # Final fallback: fill remaining NAs with fallback_dummy_brthdtc
    dm <- dm %>% mutate(BRTHDTC = coalesce(BRTHDTC, as.character(NA)))
    if (any(is.na(dm$BRTHDTC))) {
      dm$BRTHDTC[is.na(dm$BRTHDTC)] <- fallback_dummy_brthdtc
    }
  }
} else {
  # Ensure character type for consistency
  dm <- dm %>% mutate(BRTHDTC = as.character(BRTHDTC))
}

# Label dataset ----
attr(dm, "label") <- "Demographics"
attr(dm$BRTHDTC, "label") <- "Date/Time of Birth"
attr(suppdm, "label") <- "Supplemental Qualifiers for DM"

# Save datasets ----
usethis::use_data(dm, overwrite = TRUE)
usethis::use_data(suppdm, overwrite = TRUE)
