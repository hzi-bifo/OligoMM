# cleanup
rm(list=ls())

# load packages
require(ggplot2) 
require(labdsv)
require(vegan)
require(MASS)

# load function file
source("permanova.functions.R")

# load distance informations
dist <- read.table("data/TV47_Fig4/TV47_unweighted_unifrac.txt")

# load mapping file
mapping <- read.table("data/TV47_Fig4/TV47_mapping.txt", sep="\t")

# create stressplots
# see http://cc.oulu.fi/~jarioksa/opetus/metodi/vegantutor.pdf
stressplot(isoMDS(as.dist(dist)), as.dist(dist))

# run permanova on dist matrix
permanova.result <- pairwisePermanova(dist, as.matrix(mapping$V3))

# run cap on dist matrix
cap.result <- pairwiseCap(dist, as.matrix(mapping$V3))

# export table
write.table(permanova.result, file="results/permanova_unweighted_unifrac", sep="\t", row.names=F, quote=F)
write.table(cap.result, file="results/cap_unweighted_unifrac.txt", sep="\t", row.names=F, quote=F)