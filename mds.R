# cleanup
rm(list=ls())	

# load functions 
source("mds.functions.R")

# load distance matrix
dist <- read.table("data/TV47_Fig4/TV47_bray_curtis.txt")

# generate pdf 
pdf("results/mds.pdf", width = 5, height = 5)
plotMds(dist)
dev.off()