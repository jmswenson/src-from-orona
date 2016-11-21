### This create a pretty arcplot using the packages network and arcdiagram
### Data is in the following format sep by tabs:Gene1, Gene2, Enrichment, Edge1, Edge2, Group



library(network);
library(arcdiagram); 

ip<-read.table("joels_test.txt",header=T);

arcplot(as.matrix(ip[,1:2]), lwd.arcs=c(ip[,3]/5), col.nodes=4,show.nodes=TRUE)

######## Different way to do it
glab = graph.edgelist(as.matrix(ip[,1:2]), directed = TRUE)
#plot(glab);
lab_degree = degree(glab);
#gclus = clusters(glab);
#blues = c("#adccff","#4272bf");
#cols = blues[gclus$membership];

arcplot(as.matrix(ip[,1:2]), lwd.arcs = c(ip[,3])/10, cex.nodes = lab_degree, col.nodes = c(ip[,6]), bg.nodes = c(ip[,6]), show.nodes = TRUE);
### lwd.arc is the thickness of the arc, cex.nodes = lab_degree is the connectivity of protein, col.nodes is the color of the node


What I want is the size of the node to be

############ below code is a network map using code from: http://www.r-bloggers.com/network-visualization-in-r-with-the-igraph-package/

require(igraph)
ip.network<-graph.data.frame(ip,directed=T)
V(ip.network)
E(ip.network)
plot(ip.network)
dev.off()
bad.vs<-V(ip.network)[degree(ip.network)<3]
ip.network<-delete.vertices(ip.network, bad.vs)
V(ip.network)$size<-degree(ip.network)/10
par(mai=c(0,0,1,0))
plot(ip.network, layout=layout.fruchterman.reingold, main = "Buttload of IPs", vertex.label.dist=0.5, vertex.frame.color='blue',vertex.label.color='black',vertex.label.font=2,vertex.label=V(ip.network)$name, vertex.label.cex=1)

####### Below is how to get an adjacency matrix and export to gml

require(igraph)
ip<-read.table("joels_test.txt",header=T);
ip.network<-graph.data.frame(ip,directed=F); #NOT DIRECTED
ip.adj<-get.adjacency(ip.network,type="both",sparse=FALSE) ; # SPARSE setting is so a matrix is returned
write.graph(ip.network,file="ip.network.gml",format = "gml");
###or
write.table(ip.adj,file="ip.network.adjacency.tab.txt",sep="\t");
ip.adj<-read.table("ip.network.adjacency.tab.txt",header=T);
freq<-apply(ip.adj,2,sum);
### One can then filter this matrix by the number of connections
lose<-which(freq<4);
ip.adj.trim<-ip.adj[-lose,-lose];



######## Once you have it in gml format then you can make an arc diagram by following: http://gastonsanchez.wordpress.com/2013/02/03/arc-diagrams-in-r-les-miserables/

library(devtools)
library(arcdiagram)
mis_graph = read.graph("ip.network.gml", format="gml")
# get edgelist
edgelist = get.edgelist(mis_graph)
 
# get vertex labels
vlabels = get.vertex.attribute(mis_graph, "label")
 
# get vertex groups
vgroups = get.vertex.attribute(mis_graph, "group")
 
# get vertex fill color
vfill = get.vertex.attribute(mis_graph, "fill")
 
# get vertex border color
vborders = get.vertex.attribute(mis_graph, "border")
 
# get vertex degree
degrees = degree(mis_graph)
 
# get edges value
values = get.edge.attribute(mis_graph, "value")

library(reshape)
 
# data frame with vgroups, degree, vlabels and ind
x = data.frame(vgroups, degrees, vlabels, ind=1:vcount(mis_graph))
 
# arranging by vgroups and degrees
y = arrange(x, desc(vgroups), desc(degrees))
 
# get ordering 'ind'
new_ord = y$ind

arcplot(edgelist, ordering=new_ord, labels=vlabels, cex.labels=0.8, show.nodes=TRUE, col.nodes=vborders, bg.nodes=vfill,cex.nodes = log(degrees)+0.5, pch.nodes=21, lwd.nodes = 2, line=-0.5,col.arcs = hsv(0, 0, 0.2, 0.25), lwd.arcs = 1.5 * values)




