## Build hierarchtical dataframe

# Libraries
library(ggraph)
library(igraph)

# create a data frame giving the hierarchical structure of your individuals. 
# Origin on top, then groups, then subgroups
d1 <- data.frame(from="origin", to=paste("group", seq(1,10), sep=""))
d2 <- data.frame(from=rep(d1$to, each=10), to=paste("subgroup", seq(1,100), sep="_"))
hierarchy <- rbind(d1, d2)

# create a vertices data.frame. One line per object of our hierarchy, giving features of nodes.
vertices <- data.frame(name = unique(c(as.character(hierarchy$from), as.character(hierarchy$to))) ) 

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
         parents = ifelse(grepl(".Thing$", adcad$parents), NA, 
                            substr(x = adcad$parents, start = 36, stop = 40)))

disc_id <- from_to %>% 
  select(-parents) %>% 
  rename("parents" = class_id)

vertices <- disc_id[,"parents"] %>% 
  mutate(parents = ifelse(parents == "00000", "origin", parents))

from_to_labels <- from_to %>% 
  left_join(disc_id, by = "parents") 

hier <- from_to[,c(1,3)] %>% 
  rename("from" = "parents",
         "to" = "class_id") %>% 
  select(from, to) %>% 
  na.omit() %>% 
  arrange(from) %>% 
  mutate(from = ifelse(from == "00000", "origin", from))

mygraph <- graph_from_data_frame(hier, vertices=vertices)

ggraph(mygraph, layout = 'circlepack') + 
  geom_node_circle() +
  theme_void()
