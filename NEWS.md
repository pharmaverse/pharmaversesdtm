# pharmaversesdtm 1.3.0

## New Features

- Units for `eg` dataset were updated to be consistent with SDTM guidelines. (#129)  

- Added following Metabolic specific SDTM datasets: (#136, #139)

    - `dm_metabolic`
    - `qs_metabolic`
    - `vs_metabolic`
    - `lb_metabolic`.

- Updated `oe_ophtha` to include both pre and post-dose IOP. (#134)

- Updated `ex_vaccine` dataset to remove the non-standard CDISC SDTM variables. (#170)

- Oncology response data for PCWG3 criteria (`rs_onco_pcwg3`) was added. (#143)

## Documentation

- Removed outdated references to `{renv}` in the package README. (#113)

- Added test short names and test names (`xxTESTCD`/`xxTEST`) description in the "Details" section, when available. (#145)

<details>
<summary>Developer Notes</summary>

-  Ungrouped `lb_metabolic` prior to export (#152)
-  Added `metatools` as a dependency needed for development tasks (#153)
-  Removed namespaces from function calls in `lb_metabolic.R`
-  Removed unnecessary "Documentation Process" section from `README.md` (#156)
-  Harmonized code to load the SDTMs using `pharmaversesdtm::xx` (#157)
-  Harmonized code using `magrittr` pipe (#158)
-  Added back pharmaversesdtm Hex and corresponding alternative text (#159)
-  Ensured all datasets have populated variables labels (#162)
-  Changed units of insulin and triglycerides in `lb_metabolic` (#167)
-  Fixed typo in `tu_onco_recist` dataset (#171)
-  Ensured R files generated by `create_sdtms_data.R` are compliant with `{styler}` (#179)

</details>

# pharmaversesdtm 1.2.0

## New Features

- Oncology response data for GCIG criteria (`rs_onco_ca125` and
`supprs_onco_ca125`) was added. (#124)

- Added variable-by-variable breakdown of dataset within reference pages. (#111)

<details>
<summary>Developer Notes</summary>

- Internally re-worked the way reference pages are constructed to automate the process. (#111)

</details>

# pharmaversesdtm 1.1.0

## New Features

- Pediatrics data for anthropometric measures (`dm_peds` and `vs_peds`) was added. (#88)

- `CMENRTPT` variable was added to the `cm` dataset. (#120)

- `AELOC` variable was added to the `ae_ophtha` dataset. (#110)

<details>
<summary>Developer Notes</summary>

- Activated automatic version bumping CICD workflow. (#122)

</details>

# pharmaversesdtm 1.0.0

## New Features

- Add URINE records to `pc` and `pp`. (#90)

- Update `PPCAT` so that it corresponds to `PCTEST`. (#91)

- Oncology response data for IMWG criteria (`rs_onco_imwg` and `supprs_onco_imwg`)
was added. (#86)

- Update `PPSTRESC` and `PPORRES` so they are character. (#102)

# pharmaversesdtm 0.2.0

## New Features

- Following Vaccine Specific SDTM datasets have been added. (#4)

    - `ce_vaccine`
    - `dm_vaccine`
    - `ex_vaccine`
    - `face_vaccine`
    - `is_vaccine`
    - `vs_vaccine`
    - `suppce_vaccine`
    - `suppdm_vaccine`
    - `suppex_vaccine`
    - `suppface_vaccine`
 
- Oncology response data for iRECIST criteria (`rs_onco_irecist`) was added. (#32)

- `get_terms()` now expects `TERMCHAR` instead of `TERMNAME` in alignment with [this](https://github.com/pharmaverse/admiral/issues/2186) `{admiral}` issue. (#76)

# pharmaversesdtm 0.1.1

## Documentation

 - Fixed redirected links on website for CRAN release. 

# pharmaversesdtm 0.1.0

## New Features

 - Ophthalmology variants of `ex` and `qs` SDTM datasets added. (#15)
 - Migrate data and function `get_terms()` from `admiral.test`. (#1, #49)
 - Oncology datasets `tu_onco_recist`, `tr_onco_recist`, and `rs_onco_recist`
 using RECIST 1.1 response criteria. The datasets contain just a few patients.
 They are intended for vignettes and examples of ADaM datasets creation. (#33)

