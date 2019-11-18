
library(tidyverse)
library(RColorBrewer)
# display.brewer.all()
library(igraph)

stockdata = read_csv("stockdata_small.csv")
glimpse(stockdata)

df = stockdata %>% 
  select(Date, Ticker, PxChange) %>%
  spread(Ticker, PxChange, convert = TRUE) %>%
  arrange(desc(Date)) %>%
  head(n=5)
  
glimpse(df)
str(df)

cor_df = cor(df[,-1])
myAdjacencyMatrix <- as.matrix(cor_df)

g_df  = graph.adjacency(myAdjacencyMatrix, 
                      mode = "undirected", 
                      weighted=TRUE,
                      diag = FALSE,
                      add.colnames = NULL)

link = get.data.frame(g_df)
link$colour = ifelse(link$weight > 0, "deepskyblue4", "red")

node = tibble(name = colnames(df[,-1]))

write.csv(link, "link.csv")
write.csv(node, "node.csv")
#node_n <- read_csv("nodes.csv")
#link_n <- read_csv("links.csv")

g <- graph.data.frame(link, node, directed = F)
g

plot(g,
     layout = layout.circle, # default layout.auto, lgl)
     edge.color = E(g)$colour, 
     edge.width = abs(E(g)$weight*5),
     
     vertex.frame.color = "deepskyblue4",
     vertex.color=rgb(red=0.1,green=0.7,blue=0.8,alpha=0.5),
     vertex.label.family = "Arial",
     vertex.size = 30, #default 15
     vertex.label.font = 1, # 1: for plain text
     vertex.label.cex = 0.6 # Font size
)


# Below algorithms are applicable if we set a limit for the existence of links

igraph::degree(g)
igraph::degree.distribution(g)

##########################################################################################################################
#Kleinberg's hub and authority scores.
##########################################################################################################################

hub.score(g)$vector
authority.score(g)$vector

# clique.number calculates the size of the largest clique(s).
clique.number(g)

#cliques find all complete subgraphs in the input graph, 
#obeying the size limitations given in the min and max arguments.
cliques(g, min=6)

# How about we want to find smaller cliques
cliques(g, min=4)

#maximal.cliques finds all maximal cliques in the input graph.
#A clique in maximal if it cannot be extended to a larger clique. 
#The largest cliques (maximum cliques) are always maximal, but a maximal clique is not neccessarily the largest.
maximal.cliques(g)

# Maximum cliques: largest.cliques finds all largest cliques in the input 
# graph. A clique is largest if there is no other clique including more vertices.
largest.cliques(g)


############################################################
# spinglass.community 
# Finding communities in graphs based on statistical meachanics
# This function tries to find communities in graphs via a 
# spin-glass model and simulated annealing.
############################################################
# J. Reichardt and S. Bornholdt: Statistical Mechanics of Community Detection, Phys. Rev. E, 74,
# 016110 (2006), http://arxiv.org/abs/cond-mat/0603718
# M. E. J. Newman and M. Girvan: Finding and evaluating community structure in networks, Phys.
# Rev. E 69, 026113 (2004)
# V.A. Traag and Jeroen Bruggeman: Community detection in networks with positive and negative
# links, http://arxiv.org/abs/0811.2329 (2008).

#subgraph creates a subgraph of a graph, 
#containing only the specified vertices and all the edges among them.
g1 <- induced.subgraph(g, subcomponent(g, 1))
spinglass.community(g1, spins=2)
spinglass.community(g1, vertex=1)

