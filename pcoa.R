
# code adapted from http://enterotype.embl.de/enterotypes.html

# cleanup
rm(list=ls())

# load libs
require(phyloseq)
require(cluster)
require(clusterSim)
require(ade4)
require(ggplot2)
require(RColorBrewer)
require(ape)
require(ellipse)


# load functions
source("pcoa.functions.R")


# load distance matrix
dist <- read.table("data/TV47_Fig4/TV47_bray_curtis.txt")

# read mapping
mapping <- read.table("data/TV47_Fig4/TV47_mapping.txt", sep="\t", header=F)

# get sample types from mapping file
mapping.names.ordered <- mapping[match(rownames(dist), mapping$V1),]$V1
mapping.types.ordered <- mapping[match(rownames(dist), mapping$V1),]$V3

# unconstrained pcoa
#obs.pcoa <- dudi.pco(as.dist(dist), scannf=F, nf=3)
obs.pcoa <- pcoa(as.dist(dist))

# prepare df
types.ordered <- mapping[match(rownames(obs.pcoa$vectors), mapping$V1),]$V3
colorvalues <- c("#f35f67ff", "#42ba43ff", "#6a8ed1ff")
df <- data.frame(MDS1=obs.pcoa$vectors[,1], MDS2=obs.pcoa$vectors[,2], genotype=types.ordered)

# plot


c <- drawPcoa(obs.pcoa, df, sample.names= mapping.types.ordered, colorvalues=colorvalues)

pdf("results/pcoa.pdf", width=6, height=4)
c
dev.off()









##
#pdf("results/biplot_pcoa.pdf")
#biplot(obs.pcoa)
#dev.off()


### cluster stuff ###
#k <- 3# number of clusters

# find clusters
#clusters <- pam.clustering(as.dist(dist), k) # define clustes
#obs.bet <- bca(obs.pcoa, fac=as.factor(clusters), scannf=F, nf=k-1)
#obs.silhouette <- mean(silhouette(clusters, dist)[,3])

# generate data frame for plotting
#df <- data.frame(cluster=factor(clusters), x=obs.pcoa$li$A1, y=obs.pcoa$li$A2, site=mapping.types.ordered)
# get centroids
#centroids <- aggregate(cbind(x,y)~cluster,data=df,mean)
#df <- merge(df,centroids,by="cluster",suffixes=c("",".centroid"))
#conf.rgn  <- do.call(rbind,lapply(1:k,function(i)
 # cbind(cluster=i,ellipse(cov(df[df$cluster==i,2:3]),centre=as.matrix(centroids[i,2:3])))))
#conf.rgn  <- data.frame(conf.rgn)
#conf.rgn$cluster <- factor(conf.rgn$cluster)
#centroids <- aggregate(cbind(MDS1,MDS2)~Treatment,sc,mean)
#conf.rgn  <- do.call(rbind,lapply(unique(sc$Treatment),function(t)
 # data.frame(Treatment=as.character(t),
 #            ellipse(cov(sc[sc$Treatment==t,1:2]),
  #                   centre=as.matrix(centroids[t,2:3]),
   #                  level=0.95),
    #         stringsAsFactors=FALSE)))


#s.class(obs.pcoa$li, fac=as.factor(clusters), grid=F)
#s.class(obs.bet$ls, fac=as.factor(clusters), grid=F)



#ggplot(data=df,(aes(x=MDS1,y=MDS2, color=genotype)))+
#  geom_point(size=3)#+
#  geom_path(data=conf.rgn)+
#  ggtitle(paste("PCoA of samples at 'class' level(method='Bray')\n",sep=''))+
#  theme_bw()+
#  guides(colour = guide_legend(override.aes = list(size=3)))

