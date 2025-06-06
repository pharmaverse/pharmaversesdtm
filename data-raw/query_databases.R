# Dataset: sdg_db, smq_db
# Description: Create example SDG, SMQ dataset

# Load libraries ----
library(dplyr)
library(metatools)

# Create smq dataset ----
pregsmq <- tribble(
  ~termchar, ~scope,
  "Achromotrichia congenital", "narrow",
  "Craniosynostosis", "narrow",
  "Hypophosphatasia", "narrow",
  "Congenital pyelocaliectasis", "narrow",
  "Uterine contractions during pregnancy", "narrow",
  "Uterine contractions during pregnancy", "broad",
  "Ductus arteriosus premature closure", "narrow",
  "Pseudotruncus arteriosus", "narrow",
  "Lipomeningocele", "narrow",
  "Macrocephaly", "narrow",
  "Carnitine palmitoyltransferase deficiency", "narrow",
  "Congenital labia pudendi adhesions", "narrow",
  "Beckwith-Wiedemann syndrome", "narrow",
  "Wolf-Hirschhorn syndrome", "narrow",
  "Holt-Oram syndrome", "narrow",
  "Langer-Giedion syndrome", "narrow",
  "Congenital scoliosis", "narrow",
  "Exophthalmos congenital", "narrow",
  "Congenital pulmonary hypertension", "narrow",
  "Retinopathy congenital", "narrow",
  "Congenital acrochordon", "narrow",
  "Bartter's syndrome", "narrow"
) %>%
  mutate(
    smq_name = "Pregnancy and neonatal topics (SMQ)",
    smq_id = 20000185L
  )

bilismq <- tribble(
  ~termchar, ~scope,
  "Bile duct cancer recurrent", "narrow",
  "Bile duct cancer recurrent", "broad",
  "Bile duct squamous cell carcinoma", "narrow",
  "Bile duct squamous cell carcinoma", "broad",
  "Biliary neoplasm", "narrow",
  "Biliary neoplasm", "broad",
  "Cholangioadenoma", "narrow",
  "Cholangioadenoma", "broad",
  "Cholangiocarcinoma", "narrow",
  "Cholangiocarcinoma", "broad",
  "Choledochal cyst", "narrow",
  "Choledochal cyst", "broad",
  "Gallbladder cancer", "narrow",
  "Gallbladder cancer", "broad",
  "Gallbladder cancer recurrent", "narrow",
  "Gallbladder cancer recurrent", "broad",
  "Malignant neoplasm of ampulla of Vater", "narrow",
  "Malignant neoplasm of ampulla of Vater", "broad",
  "Mixed hepatocellular cholangiocarcinoma", "narrow",
  "Mixed hepatocellular cholangiocarcinoma", "broad",
  "Biliary adenoma", "narrow",
  "Biliary adenoma", "broad",
) %>%
  mutate(
    smq_name = "Biliary neoplasms (SMQ)",
    smq_id = 20000121L
  )
smq_db <- bind_rows(pregsmq, bilismq) %>%
  mutate(
    version = "20.1",
    termvar = "AEDECOD"
  )

# Label variables ----
smq_db <- smq_db %>%
  add_labels(
    termchar = "Reported Term",
    scope = "Scope",
    smq_name = "Name",
    smq_id = "Name ID",
    version = "Version",
    termvar = "Variable"
  )

# Label dataset ----
attr(smq_db, "label") <- "SMQ"

# Save smq dataset ----
usethis::use_data(smq_db, overwrite = TRUE)

# Create sdg dataset ----
sdg_db <- tribble(
  ~termchar,
  "AMINOSALICYLIC ACID",
  "AMINOSALICYLATE CALCIUM",
  "AMINOSALICYLATE CALCIUM ALUMINIUM",
  "AMINOSALICYLATE SODIUM",
  "SODIUM AMINOSALICYLATE DIHYDRATE",
  "AMINOSALICYLATE SODIUM;AMINOSALICYLIC ACID",
  "SULFASALAZINE",
  "CALCIUM BENZAMIDOSALICYLATE",
  "OLSALAZINE",
  "OLSALAZINE SODIUM",
  "MESALAZINE",
  "BALSALAZIDE",
  "BALSALAZIDE SODIUM",
  "BALSALAZIDE DISODIUM DIHYDRATE",
  "DERSALAZINE",
  "DERSALAZINE SODIUM"
) %>%
  mutate(
    sdg_name = "5-aminosalicylates for ulcerative colitis",
    sdg_id = 220L,
    termvar = "CMDECOD",
    version = "2019-09"
  )

# Label variables ----
sdg_db <- sdg_db %>%
  add_labels(
    termchar = "Reported Term",
    sdg_name = "Name",
    sdg_id = "Name ID",
    termvar = "Variable",
    version = "Version"
  )

# Label dataset ----
attr(sdg_db, "label") <- "SDG"

# Save sdg dataset ----
usethis::use_data(sdg_db, overwrite = TRUE)
