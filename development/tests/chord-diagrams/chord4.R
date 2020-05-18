#!/usr/bin/Rscrip
library(igraph)

x <- pairs %>% 
  arrange(id) %>%
  select(a1, a2) %>%
  as.matrix()
gg7 <- graph.edgelist(x,directed=F)  

