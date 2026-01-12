# Neurological Assessment Dataset-neuro

A SDTM NV dataset containing neurological assessments or test results

## Usage

``` r
nv_neuro
```

## Format

A data frame with 21 columns:

- STUDYID:

  Study Identifier

- DOMAIN:

  Domain Abbreviation

- USUBJID:

  Unique Subject Identifier

- NVSEQ:

  Sequence Number

- NVLNKID:

  Link ID

- NVTESTCD:

  Short Name of Nervous System Test

- NVTEST:

  Name of Nervous System Test

- NVCAT:

  Category for Nervous System Test

- NVLOC:

  Location Used for the Measurement

- NVMETHOD:

  Method of Test or Examination

- NVNAM:

  Vendor Name

- NVORRES:

  Result or Finding in Original Units

- NVORRESU:

  Original Units

- NVSTRESC:

  Character Result/Finding in Std Format

- NVSTRESN:

  Numeric Result/Finding in Standard Units

- NVSTRESU:

  Standard Units

- VISITNUM:

  Visit Number

- VISIT:

  Visit Name

- NVDTC:

  Date/Time of Collection

- NVDY:

  Study Day of Collection

- NVLOBXFL:

  Last Observation Before Exposure Flag

## Source

Constructed by admiralneuro developers

## Details

Neurological Assessment Dataset-neuro

A SDTM NV dataset containing neurological assessments or test results

Contains a set of 3 unique Test Short Names and Test Names:

|              |                                                      |
|--------------|------------------------------------------------------|
| **NVTESTCD** | **NVTEST**                                           |
| SUVR         | Standardized Uptake Value Ratio                      |
| UPSIT        | University of Pennsylvania Smell Identification Test |
| VR           | Qualitative Visual Classification                    |
