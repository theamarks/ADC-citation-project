## Use ADCAD ontology matches to update previous discipline classification efforts. 
# This will save time when going through manually and classifying.
# This code probably doesn't run, but can give you a sense of the process 

# key from old discipline categories to new ADCAD ontology - approved matches
themes <- read_csv(file.path("data/old_themes_ADCAD_key.csv"))

# read in csv with previous classifications
old_cat <- read.csv(file.path("data/dataset_categorization.csv"))

# replace old theme categories with new ADCAD ontology terms.
# only replacing terms that don't need review (themes df), leave the rest. 
new_cat <- old_cat %>% 
  select(url, id)

for(i in colnames(old_cat[7:11])) {
  # sequence through column names
  new_cat[[i]] <- purrr::map(old_cat[[i]], function(old_theme) {
    if (old_theme %in% themes$old) {
      # replace if old theme is listed
      new_theme <-
        themes$ADCAD[which(themes$old == old_theme)] # get corresponding new disc
      return(new_theme) # use disc ontology term to populate column
    } else{
      if (old_theme == "") {
        old_theme = NA
      }
      return(old_theme)
    } # keep old_theme if review is needed
  })
}

# unnest list columns
new_cat %<>% 
  unnest(cols = c("theme1", "theme2", "theme3", "theme4", "theme5"))

# Add re-categorization to solr query results (disc_adc_wide)
disc_adc_new <- disc_adc_wide %>% 
  left_join(new_cat, by = "id") %>% 
  mutate(url = url)

# check if there is any overlapping entries between theme1 & category_1 etc.
# overlap_cat1 <- disc_adc_new %>%
#   filter(!is.na(theme1) & !is.na(category_1))
# 
# overlap_cat2 <- disc_adc_new %>%
#   filter(!is.na(theme2) & !is.na(category_2))
# 
# overlap_cat3 <- disc_adc_new %>%
#   filter(!is.na(theme3) & !is.na(category_3))
# 
# overlap_cat4 <- disc_adc_new %>%
#   filter(!is.na(theme4) & !is.na(category_4))
# 
# overlap_cat5 <- disc_adc_new %>%
#   filter(!is.na(theme5) & !is.na(category_5))
# ^^ No overlap between two datasets

# Combine discipline category columns + DOI
disc_adc_ADCAD <- disc_adc_new %>% 
  transmute(url = url,
            id = id,
            title = title,
            disc_cat_1 = ifelse(!is.na(category_1), category_1, theme1),
            disc_cat_2 = ifelse(!is.na(category_2), category_2, theme2),
            disc_cat_3 = ifelse(!is.na(category_3), category_3, theme3),
            disc_cat_4 = ifelse(!is.na(category_4), category_4, theme4),
            disc_cat_5 = ifelse(!is.na(category_5), category_5, theme5)
  )
# Save results
# write.csv(disc_adc_ADCAD, "./output/ADC_ADCAD_disciplines.csv", row.names = F)