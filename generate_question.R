library(dplyr)
library(readxl)
library(stringr)

# Charger le fichier Excel
df <- read_excel(file_path, guess_max = 1000) %>%
  mutate(across(everything(), ~iconv(.x, from = "latin1", to = "UTF-8")))


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

# Nombre total de questions
total_questions <- nrow(questions_list)

# Générer un fichier .qmd pour chaque question
for (i in seq_along(questions_list$Questions)) {
  question <- str_remove(questions_list$Questions[i], "Q\\d+\\s*/\\s*")
  
  options <- questions_list$options[[i]]
  
  # Définir les pages de navigation
  prev_page <- ifelse(i > 1, paste0("question_", questions_list$Numero[i - 1], ".html"), "#")
  next_page <- ifelse(i < total_questions, paste0("question_", questions_list$Numero[i + 1], ".html"), "#")
  
  qmd_content <- paste0(
    "---\n",
    #"title: \"", question, "\"\n",
    "format: html\n",
    "---\n\n",
    
    # Nouvelle ligne pour le bouton précédent
    "<div style='text-align: left; margin-bottom: 20px;'>\n",
    ifelse(i > 1, paste0(
      "<button onclick=\"window.location.href='", prev_page, "'\" ",
      "style='background-color: red; color: white; border: none; padding: 10px; ",
      "border-radius: 5px; cursor: pointer;'>Précédent</button>\n"
    ), ""),
    "</div>\n\n",
    
    "## ", question, "\n\n",
    "### Sélectionnez votre réponse :\n\n"
  )
  
  for (opt in options) {
    qmd_content <- paste0(qmd_content, 
                          "- [ ] ", opt, "\n\n")
  }
  
  # Ajouter les boutons de navigation
  qmd_content <- paste0(qmd_content,
                        "<br>\n",
                        
                        # Bouton "Continuer plus tard"
                        "<button id='continuer' onclick='sauvegarderReponses()' ",
                        "style='background-color: #2c3771; color: white; border: none; padding: 10px; ",
                        "border-radius: 5px; cursor: pointer; margin-right: 10px;'>📌 Continuer plus tard</button>\n",
                        
                        "<button onclick=\"window.location.href='", next_page, "'\" ",
                        "style='background-color: red; color: white; border: none; padding: 10px; ",
                        "border-radius: 5px; cursor: pointer;' ",
                        ifelse(i == total_questions, "disabled", ""), ">Suivant</button>\n"
  )
  
  # Ajouter un script JS pour enregistrer les réponses
  qmd_content <- paste0(qmd_content, "\n\n",
                        "<script>\n",
                        "document.getElementById('quiz-form').addEventListener('submit', function(event) {\n",
                        "  event.preventDefault();\n",
                        "  let responses = [];\n",
                        "  document.querySelectorAll('input[type=checkbox]:checked').forEach((checkbox) => {\n",
                        "    responses.push(checkbox.value);\n",
                        "  });\n",
                        "  localStorage.setItem('reponses_q", i, "', JSON.stringify(responses));\n",
                        "  alert('Réponse enregistrée !');\n",
                        "});\n",
                        "</script>\n",
                        "<script>\n",
                        "function sauvegarderReponses() {\n",
                        "  let responses = [];\n",
                        "  document.querySelectorAll('input[type=checkbox]:checked').forEach((checkbox) => {\n",
                        "    responses.push(checkbox.value);\n",
                        "  });\n",
                        "  localStorage.setItem('reponses_q", i, "', JSON.stringify(responses));\n",
                        "  alert('✔ Réponses enregistrées ! Vous pouvez revenir plus tard.');\n",
                        "}\n",
                        "</script>\n"
  )
  
  # Écrire le fichier .qmd
  file_name <- paste0("question_", questions_list$Numero[i], ".qmd")
  writeLines(qmd_content, file_name)
}

print("✅ Fichiers générés avec navigation et formulaire !")
