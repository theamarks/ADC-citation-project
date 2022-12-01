# Sunburst visualization

# create dataframe of discipline levels starting from origin reaching out to leaves
circ_levels <- new_vert
circ_levels$level_1 <- hydro_leaves$from[match(circ_levels$name, hydro_leaves$to)]
circ_levels$level_2 <- hydro_leaves$from[match(circ_levels$level_1, hydro_leaves$to)]
circ_levels$level_3 <- hydro_leaves$from[match(circ_levels$level_2, hydro_leaves$to)]
circ_levels$level_4 <- hydro_leaves$from[match(circ_levels$level_3, hydro_leaves$to)] 

circ_levels %<>%
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
# remove rows representing origin and second level branches
circ_levels %<>% 
  mutate(branch_3 = ifelse(branch_2 == branch_3, NA, branch_3),
         branch_4 = ifelse(branch_3 == branch_4, NA, branch_4),
         branch_5 = ifelse(branch_4 == branch_5, NA, branch_5)) %>% 
  select(branch_1, branch_2, branch_3, branch_4, branch_5, size) %>% 
  filter(!is.na(branch_3))

### Sun burst

sun_levels <- circ_levels %>% 
  group_by(branch_2, branch_3) %>% 
  summarize("n_cit" = sum(size)) %>% 
  mutate(path = paste(branch_2, branch_3, sep = "-")) %>% 
  ungroup() %>% 
  select(path, n_cit)

sun_levels_all <- circ_levels %>% 
  mutate(branch_4 = ifelse(is.na(branch_4), "", branch_4),
         branch_5 = ifelse(is.na(branch_5), "", branch_5)) %>% 
  mutate(path = paste(branch_2, branch_3, branch_4, branch_5, sep = "-")) %>% 
  select(path, size)


