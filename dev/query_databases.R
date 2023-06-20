library(dplyr)

pregsmq <- tribble(
  ~termname, ~scope,
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
  ~termname, ~scope,
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

admiral_smq_db <- smq_db
save(admiral_smq_db, file = "data/admiral_smq_db.rda", compress = "bzip2")

sdg_db <- tribble(
  ~termname,
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

admiral_sdg_db <- sdg_db
save(admiral_sdg_db, file = "data/admiral_sdg_db.rda", compress = "bzip2")
