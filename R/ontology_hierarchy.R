## Build hierarchtical dataframe

# Libraries
library(ggraph)
library(igraph)
library(viridis)

# read in child parent relationship from ontology
adcad <- read_csv("./data/ADCAD.csv")
# transform url descriptions to codes
adcad <- adcad %>% 
  rename("class_id" = "Class ID",
         "label" = "Preferred Label",
         "parents" = "Parents") %>% 
  select(class_id, label, parents) 

from_to <- adcad %>% 
  mutate(class_id = substr(x = adcad$class_id, start = 36, stop = 40),
         parents = ifelse(grepl(".Thing$", adcad$parents), "origin", 
                            substr(x = adcad$parents, start = 36, stop = 40)))

disc_id <- from_to %>% 
  select(-parents) %>% 
  rename("parents" = class_id)

my_vertices <- disc_id[,"label"]
names(my_vertices)[1] <- "name"
#my_vertices[nrow(my_vertices) + 1,] = "origin"
my_vertices$size <- cit_disc$n_cit[match(my_vertices$name, cit_disc$value)]
my_vertices %<>%
  mutate(size = ifelse(is.na(size), 1, size +1))

from_to_labels <- from_to %>% 
  left_join(disc_id, by = "parents") 

edges_num <- from_to[,c(1,3)] %>% 
  rename("from" = "parents",
         "to" = "class_id") %>% 
  select(from, to) %>% 
  na.omit() %>% 
  arrange(from) #%>% 
  #mutate(from = ifelse(from == "00000", "origin", from))

edges_name <- edges_num
edges_name$to <- disc_id$label[match(edges_name$to, disc_id$parents)]
edges_name$from <- disc_id$label[match(edges_name$from, disc_id$parents)]
edges_name <- na.omit(edges_name)
#edges_name %<>%
#  mutate(from = ifelse(is.na(from), "origin", from))
