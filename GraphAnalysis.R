library(tidyverse)
library(RColorBrewer)
# display.brewer.all()
library(igraph)


#install.packages("AzureStor")
library(AzureStor)


# get the storage account object
#stor <- AzureRMR::az_rm$
#  new()$
#  get_subscription("884859e2-5bb7-43d3-b147-5d0deda10bc0")$
#  get_resource_group("Sparkling")$
#  get_storage_account("bigdata1hdistorage")

#stor$get_blob_endpoint()
# Azure blob storage endpoint
# URL: https://mynewstorage.blob.core.windows.net/
# Access key: <hidden>
# Account shared access signature: <none supplied>
# Storage API version: 2018-03-28


## Download files directly from Azure Blob Storages based on supplied URL into your working directory
# nodes.csv
download_from_url(
  "https://bigdataissstorageasia.blob.core.windows.net/graphnodes/nodes.csv",
  "nodes.csv",
  key="zm5Yr4YadxB/ZEvhyOISOw9hh5MCeVUA07A76EsBVBpX/jP6aDtHRBUCGIE5cp1mMMyzQQ2A7DCOz632hLa59A==", 
  overwrite=T)

# edges.csv
download_from_url(
  "https://bigdataissstorageasia.blob.core.windows.net/graphedges/edges.csv",
  "edges.csv",
  key="zm5Yr4YadxB/ZEvhyOISOw9hh5MCeVUA07A76EsBVBpX/jP6aDtHRBUCGIE5cp1mMMyzQQ2A7DCOz632hLa59A==", 
  overwrite=T)


node <- read.csv("nodes.csv", header = TRUE, sep = ",")
link <- read.csv("edges.csv", header = TRUE)
link$direction = if_else(link$weight > 0,1,-1)
link$weight = abs(link$weight)

## filter off edges with correlation < 0.6
link <- link %>%
  filter(abs_weight > 0.6)

Questions = c("Find out basket of stocks which are highly correlated to each other across sectors/regions",
              "Find out highly influential stocks",
              "Find out most stable stocks (possibly alpha stocks) with least correlation to other stocks",
              "Stocks which are more representative of broader market(possibly index stocks)",
              "How connected a region/sector is?")

g <- graph.data.frame(link, node, directed = F)
g

plot(g,
     layout = layout.circle, # default layout.auto, lgl)
     edge.color = E(g)$Color, 
     edge.width = E(g)$abs_weight*2,
     edge.curved = 0.5,
     
     vertex.frame.color = "deepskyblue4",
     vertex.color=rgb(red=0.1,green=0.6,blue=0.8,alpha=0.8),
     vertex.label.family = "Arial",
     vertex.size = 1, #default 15
     vertex.label.font = 1, # 1: for plain text
     vertex.label.cex = 0.8 # Font size
)

# 1. Maximal Clique
lc23 = largest_cliques(g)
lc23
lc22 = "clique_1 = 1398.HK   000333.SZ 000651.SZ 0386.HK    and    clique_2 = 000002.SZ 000651.SZ 0883.HK   2628.HK"
#[[1]]
#+ 4/30 vertices, named, from eb5624a:
#  [1] 0386.HK   000651.SZ 1398.HK   000333.SZ

#[[2]]
#+ 4/30 vertices, named, from eb5624a:
#  [1] 000002.SZ 000651.SZ 2628.HK   0883.HK
lc21 = "clique_1 = 0386.HK   000651.SZ 1398.HK   000333.SZ    and    clique_2 = 000002.SZ 000651.SZ 2628.HK   0883.HK"

#2&3. Vertices with highest degree and lowest degree
highest_degree23 = V(g)$name[degree(g)==max(degree(g))] # [1] "000002.SZ"
lowest_degree23 = V(g)$name[degree(g)==min(degree(g))] # [1] "RDSA.L"
highest_degree23
lowest_degree23

highest_degree22 = "000002.SZ"
lowest_degree22 = "RDSA.L"

highest_degree21 = "000002.SZ"
lowest_degree21 = "RDSA.L"

#4. Vertices with highest centrality
degree.cent <- centr_degree(g, mode = "all")
degree.cent$res
#[1]  2  5  7  9  2  4  5  9  5  3  4  7 10  7  3  9  5  7  3  3  3  8  8  4  7  1  9  3  6  2

# Highest and lowest closeness 
highest_closeness23 = V(g)$name[closeness(g, mode="all")==max(closeness(g, mode="all"))] # [1] "6098.T"
lowest_closeness23 = V(g)$name[closeness(g, mode="all")==min(closeness(g, mode="all"))] # [1] "RDSA.L"
highest_closeness23
lowest_closeness23

highest_closeness22 = "6098.T" 
lowest_closeness22 = "RDSA.L"

highest_closeness21 = "6098.T" 
lowest_closeness21 = "RDSA.L"
  
# Highest and lowest betweenness
highest_betweenness23 = V(g)$name[betweenness(g)==max(betweenness(g))] # [1] "6098.T"
lowest_betweenness23 = V(g)$name[betweenness(g)==min(betweenness(g))] # [1] "TSCO.L"  "9984.T"  "SIRI"    "RDSA.L"  "1093.HK"
highest_betweenness23
lowest_betweenness23

highest_betweenness22 = "6098.T"
lowest_betweenness22 = "SIRI, RDSA.L, 1093.HK, 9984.T, TSCO.L"

highest_betweenness21 = "6098.T"
lowest_betweenness21 =  "TSCO.L, 9984.T, SIRI, RDSA.L" 

maximum_betweenness23 = V(g)$name[edge_betweenness(g)==max(edge_betweenness(g))] # [1] "CMCSA"
minimum_betweenness23 = V(g)$name[edge_betweenness(g)==min(edge_betweenness(g))] # [1] NA
maximum_betweenness23
minimum_betweenness23

maximum_betweenness22 = "CMCSA"
minimum_betweenness22 = NA

maximum_betweenness21 = "CMCSA"
minimum_betweenness21 = NA

#5. Density of a graph
edge_density23 = edge_density(g, loops=TRUE) # [1] 0.172043
edge_density23
edge_density22 = "0.172043"
edge_density21 = "0.172043"

Response_21_Nov = c(lc21,highest_degree21,lowest_degree21,highest_closeness21,edge_density21)
Response_22_Nov = c(lc22,highest_degree22,lowest_degree22,highest_closeness22,edge_density22)

business <- data.frame(Questions,Response_21_Nov,Response_22_Nov)
name <- c("Business Queries", "21st Nov Response", "22nd Nov Response")
colnames(business) <- name
write.csv(business, "business.csv", row.names=FALSE, col.names = TRUE)
















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
cliques(g, min=3)

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
