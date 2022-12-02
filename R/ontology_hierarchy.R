# Academic Discipline Dataset Classification Analysis


## Organize discipline in heirarchtical structure (network)

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

# add new leaves for hydrology - remove old structure - edge df
new_leaves <- data.frame("from" = "Geoscience","to" = c("Cryology", "Glaciology"))
dead_leaves <- edges_name[-which(edges_name$to == c("Cryology", "Glaciology")),]
hydro_leaves <- rbind(dead_leaves, new_leaves)


# create dataframe of node/vertices information
my_vertices <- disc_id[,"label"]
names(my_vertices)[1] <- "name"


# create vertices df - describes values for leaves (end points)
my_vertices$size <- cit_disc$n_cit[match(my_vertices$name, cit_disc$value)]
my_vertices <- na.omit(my_vertices)

all_vert <- union(unique(edges_name$from), unique(edges_name$to))
all_vert <- data.frame(name = all_vert)
new_vert <- all_vert %>% 
  left_join(my_vertices)
new_vert[is.na(new_vert$size), "size"] <- 0

