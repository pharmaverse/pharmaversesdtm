#!/bin/bash
# direct copy from CDISC pilot
Rscript data-raw/ex.R
Rscript data-raw/cm.R
Rscript data-raw/sv.R
Rscript data-raw/ts.R
Rscript data-raw/vs.R
Rscript data-raw/dm.R

# Update from CDISC pilot
Rscript data-raw/ae.R
Rscript data-raw/ds.R
Rscript data-raw/lb.R
Rscript data-raw/mh.R
Rscript data-raw/qs.R

# build from program
Rscript data-raw/pc.R
Rscript data-raw/pp.R
Rscript data-raw/query_databases.R # sdg_db, smq_db


# admiralophtha
Rscript data-raw/ex_ophtha.R
Rscript data-raw/qs_ophtha.R
# admiralophtha build from program
Rscript data-raw/oe_ophtha.R
Rscript data-raw/sc_ophtha.R


# admiralonco build from program
Rscript data-raw/tr_onco.R
Rscript data-raw/tu_onco.R
Rscript data-raw/rs_onco.R

# admiralpeds build from program
Rscript data-raw/dm_peds.R
Rscript data-raw/vs_peds.R

# admiralmetabolic build from program
Rscript data-raw/dm_metabolic.R
Rscript data-raw/vs_metabolic.R
Rscript data-raw/qs_metabolic.R

