## Build hierarchtical dataframe

# read in child parent relationship from ontology
adcad <- read_csv("./data/ADCAD.csv")
# transform url descriptions to codes
adcad <- adcad %>% 
  rename("class_id" = "Class ID",
         "label" = "Preferred Label",
         "parents" = "Parents") %>% 
  select(class_id, label, parents) 

# remove mess from IDs
adcad_num <- adcad %>% 
  mutate(class_id = substr(x = adcad$class_id, start = 36, stop = 40),
         parents = ifelse(grepl(".Thing$", adcad$parents), "origin", 
                            substr(x = adcad$parents, start = 36, stop = 40)))

# Discipline ID dataframe
disc_id <- adcad_num %>% 
  select(-parents) %>% 
  rename("parents" = class_id)

# create dataframe of node/vertices information
my_vertices <- disc_id[,"label"]
names(my_vertices)[1] <- "name"
my_vertices$size <- cit_disc$n_cit[match(my_vertices$name, cit_disc$value)]
#my_vertices %<>%
  # mutate(size = ifelse(is.na(size), 1, size +1)) # this doesn't make sense, need to back calculate
  #filter(size > 0)

# create dataframe with edge/connector info
edges_num <- adcad_num[,c(1,3)] %>% 
  rename("from" = "parents",
         "to" = "class_id") %>% 
  select(from, to) %>% 
  na.omit() %>% 
  arrange(from) #%>% 
  #mutate(from = ifelse(from == "00000", "origin", from))

# match disc id numbers with names
edges_name <- edges_num
edges_name$to <- disc_id$label[match(edges_name$to, disc_id$parents)]
edges_name$from <- disc_id$label[match(edges_name$from, disc_id$parents)]
edges_name %<>%
  na.omit() %>% 
  mutate(from = ifelse(from == "Academic Discipline", "origin", from)) # %>% 

