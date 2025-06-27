# pharmaversesdtm <img src="man/figures/logo.png" align="right" width="200" style="margin-left:50px;" alt="pharmaverse sdtm hex"/>

<!-- badges: start -->

[![pharmaverse sdtm Badge](http://pharmaverse.org/shields/pharmaversesdtm.svg)](https://pharmaverse.org)
[![CRAN status](https://www.r-pkg.org/badges/version/pharmaversesdtm)](https://CRAN.R-project.org/package=pharmaversesdtm)

<!-- badges: end -->

Test data (SDTM) for the pharmaverse family of packages

-   [Purpose](#purpose)
-   [Installation](#installation)
-   [Data Sources](#data-sources)
-   [Naming Conventions](#naming)
-   [How To Update](#how-to-update)

# Purpose {#purpose}

To provide a one-stop-shop for SDTM test data in the pharmaverse family of packages. This includes datasets that are therapeutic area (TA)-agnostic (`DM`, `VS`, `EG`, etc.) as well TA-specific ones (`RS`, `TR`, `OE`, etc.).

# Installation {#installation}

The package is available from CRAN and can be installed by running `install.packages("pharmaversesdtm")`. To install the latest development version of the package directly from GitHub use the following code:

``` r
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

remotes::install_github("pharmaverse/pharmaversesdtm", ref = "main") # This command installs the latest development version directly from GitHub.
```

# Data Sources {#data-sources}

Some test datasets have been sourced from the [CDISC pilot project](https://github.com/cdisc-org/sdtm-adam-pilot-project), while other datasets have been constructed ad-hoc by the {admiral} team. Please check the [Reference page](https://pharmaverse.github.io/pharmaversesdtm/reference/index.html) for detailed information regarding the source of specific datasets.

# Naming Conventions {#naming}

-   Datasets that are TA-agnostic: same as SDTM domain name (e.g., `dm`, `rs`).
-   Datasets that are TA-specific: domain_TA_others, others go from broader categories to more specific ones (e.g., `oe_ophtha`, `rs_onco`, `rs_onco_irecist`).

**Note**: *If an SDTM domain is used by multiple TAs, `{pharmaversesdtm}` may provide multiple versions of the corresponding test dataset. For instance, the package contains `ex` and `ex_ophtha` as the latter contains ophthalmology-specific variables such as `EXLAT` and `EXLOC`, and `EXROUTE` is exchanged for a plausible ophthalmology value.*

# How To Update {#how-to-update}

Firstly, make a GitHub issue in [`{pharmaversesdtm}`](https://github.com/pharmaverse/pharmaversesdtm) with the planned updates and tag `@pharmaverse/admiral` so that one of the development core team can sanity check the request. Then there are two main ways to extend the test data: either by adding new datasets or extending existing datasets with new records/variables. Whichever method you choose, it is worth noting the following:

-   Programs that generate test data are stored in the `data-raw/` folder.
-   Each of these programs is written as a standalone R script: if any packages need to be loaded for a given program, then call `library()` at the start of the program (but please do **not** call `library(pharmaversesdtm)`).
-   When you have created a program in the `data-raw/` folder, you need to run it as a standalone R script, in order to generate a test dataset that will become part of the `{pharmaversesdtm}` package, but you do not need to build the package.
-   Following [best practice](https://r-pkgs.org/data.html#sec-data-data), each dataset is stored as a `.rda` file whose name is consistent with the name of the dataset, e.g., dataset `xx` is stored as `xx.rda`. The easiest way to achieve this is to use `usethis::use_data(xx)`
-   The programs in `data-raw/` are stored within the `{pharmaversesdtm}` GitHub repository, but they are **not** part of the `{pharmaversesdtm}` package--the `data-raw/` folder is specified in `.Rbuildignore`.
-   When you run a program that is in the `data-raw/` folder, you generate a dataset that is written to the `data/` folder, which will become part of the `{pharmaversesdtm}` package.
-   The names and sources of test datasets are specified in `R/*.R`, for the purpose of generating documentation in the `man/` folder.

**Note:** The documentation process in `{pharmaversesdtm}` is automated for consistency and ease of maintenance. Metadata for each dataset, such as names, labels, descriptions, authors, and sources, is managed in a centralized JSON file (`inst/extdata/sdtms-specs.json`) and used to generate `.R` documentation files. This streamlined approach aligns with best practices for efficient package development.

### Adding New SDTM Datasets

-   Create a program in the `data-raw/` folder, named `<name>.R`, where `<name>` should follow the [naming convention](#naming), to generate the test data and output `<name>.rda` to the `data/` folder.
    -   Use CDISC pilot data such as `dm` as input in this program in order to create realistic synthetic data that remains consistent with other domains (not mandatory).
    -   Note that **no personal data should be used** as part of this package, even if anonymized.
-   Run the program.
-   Reflect this update by adding the relevant information to the `inst/extdata/sdtms-specs.json` file.
-   Run `data-raw/create_sdtms_data.R` in order to update `NAMESPACE` and update the `.Rd` files in `man/`.
-   Add your GitHub handle to `.github/CODEOWNERS`.
-   Update `NEWS.md`.

### Updating Existing SDTM Datasets

-   Locate the existing program `<name>.R` in the `data-raw/` folder, update it accordingly.
-   Reflect this update by adding the relevant information to the `inst/extdata/sdtms-specs.json` file.
-   Run the program, and output updated `<name>.rda` to the `data/` folder.
-   Run `data-raw/create_sdtms_data.R` in order to update `NAMESPACE` and update the `.Rd` files in `man/`.
-   Add your GitHub handle to `.github/CODEOWNERS`.
-   Update `NEWS.md`.
