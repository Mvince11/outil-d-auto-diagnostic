library(dplyr)
library(readxl)
library(stringr)

# Charger le fichier Excel
file_path <- "data/Pilotage_RSE_nettoye.xlsx"
df <- read_excel(file_path)

# Nettoyage des NA
df <- df %>% filter(!is.na(Questions), !is.na(Reponses))

# Extraire le numéro de question et trier
df <- df %>%
  mutate(Numero = as.integer(str_extract(Questions, "\\d+"))) %>%
  arrange(Numero, Questions)

# Regrouper les réponses par question
questions_list <- df %>%
  group_by(Numero, Questions) %>%
  summarise(options = list(Reponses), .groups = "drop") %>%
  arrange(Numero)

# Générer un fichier .qmd pour chaque question
for (i in seq_along(questions_list$Questions)) {
  question <- questions_list$Questions[i]
  options <- questions_list$options[[i]]
  
  qmd_content <- paste0(
    "---\n",
    "title: \"", question, "\"\n",
    "format: html\n",
    "---\n\n",
    "## ", question, "\n\n",
    "### Sélectionnez votre réponse :\n\n"
  )
  
  for (opt in options) {
    qmd_content <- paste0(qmd_content, 
                          "- [ ] ", opt, "\n\n")
  }
  
  # Écrire le fichier .qmd
  file_name <- paste0("question_", questions_list$Numero[i], ".qmd")
  writeLines(qmd_content, file_name)
}

print("✅ Fichiers générés avec succès !")

