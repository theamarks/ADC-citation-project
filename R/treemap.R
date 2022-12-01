# Tree Map

library(treemap)

# cit_disc & my_vertices = same data
# hydro_leaves provides path for levels

# create dataframe of discipline levels starting from origin reaching out to leaves
tree_levels <- my_vertices
tree_levels$level_1 <- hydro_leaves$from[match(tree_levels$name, hydro_leaves$to)]
tree_levels$level_2 <- hydro_leaves$from[match(tree_levels$level_1, hydro_leaves$to)]
tree_levels$level_3 <- hydro_leaves$from[match(tree_levels$level_2, hydro_leaves$to)]
tree_levels$level_4 <- hydro_leaves$from[match(tree_levels$level_3, hydro_leaves$to)] 

tree_levels %<>%
  mutate(l_4 = ifelse(level_4 == "origin", TRUE, FALSE),
         l_3 = ifelse(level_3 == "origin", TRUE, FALSE),
         l_2 = ifelse(level_2 == "origin", TRUE, FALSE),
         l_1 = ifelse(level_1 == "origin", TRUE, FALSE)) %>% 
  replace_na(list(l_4 = FALSE, l_3 =  FALSE, l_2 =  FALSE, l_1 = FALSE)) %>% 
  mutate(branch_1 = ifelse(l_4 == TRUE, level_4,
                           ifelse(l_3 == TRUE, level_3,
                                  ifelse(l_2 == TRUE, level_2,
                                         ifelse(l_1 == TRUE, level_1, name))))) %>% 
  mutate(branch_2 = ifelse(l_4 == TRUE, level_3, 
                           ifelse(l_3 == TRUE, level_2,
                                  ifelse(l_2 == TRUE, level_1, name)))) %>% 
  mutate(branch_3 = ifelse(l_4 == TRUE, level_2,
                         ifelse(l_3 == TRUE, level_1, name))) %>% 
  mutate(branch_4 = ifelse(l_4 == TRUE, level_1, name)) %>% 
  mutate(branch_5 = name) 

# correct for duplicate leaves pulled into multiple columns
tree_levels %<>% 
  mutate(branch_3 = ifelse(branch_2 == branch_3, NA, branch_3),
         branch_4 = ifelse(branch_3 == branch_4, NA, branch_4),
         branch_5 = ifelse(branch_4 == branch_5, NA, branch_5)) %>% 
  select(branch_1, branch_2, branch_3, branch_4, branch_5, size)

