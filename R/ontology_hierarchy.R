## Build hierarchical dataframe

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
my_vertices <- na.omit(my_vertices)

all_vert <- union(unique(edges_name$from), unique(edges_name$to))
all_vert <- data.frame(name = all_vert)
new_vert <- all_vert %>% 
  left_join(my_vertices)
new_vert[is.na(new_vert$size), "size"] <- 0

# Leafs must have a weight
vert_hydro_leaves <- new_vert %>% 
  filter(size > 0)



# this works in circle packing with edges_hydro
# hydro <- new_vert %>% 
#   filter(name %in% c("Hydrology", "Cryology", "Glaciology")) 
# hydro_combine <- data.frame("name" = "Hydrology", "size" = sum(hydro$size))

# hydro_vert <- new_vert %>% 
#   filter(!(name %in% c("Hydrology", "Cryology", "Glaciology")),
#          size > 0) 
# hydro_vert <- rbind(hydro_vert, hydro_combine)

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

# combines hydrology categories all under hydrology - works for circle packing
# edges_hydro <- edges_name %>% 
#   filter(!(to %in% c("Cryology", "Glaciology")),
#          to %in% c(hydro_vert$name))

# add new leaves for hydrology - remove old structure
new_leaves <- data.frame("from" = "Geoscience","to" = c("Cryology", "Glaciology"))
dead_leaves <- edges_name[-which(edges_name$to == c("Cryology", "Glaciology")),]
edges_hydro_leaves <- rbind(dead_leaves, new_leaves)

edges_hydro_leaves %<>%
  filter(to %in% c(vert_hydro_leaves$name))

add_mid_nodes <- data.frame(name = unique(edges_hydro_leaves$from), size = 0)
vert_hydro_leaves <- rbind(vert_hydro_leaves, add_mid_nodes)

# part of working circle packing - combine hydrology 
# high_nodes <- data.frame("name" = unique(edges_hydro$from), "size" = 0)
# hydro_vert <- rbind(hydro_vert, high_nodes)
