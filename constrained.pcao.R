# cleanup
rm(list=ls())

# load packages
require(vegan)
require(pander)
require(ggplot2)

source("constrained.pcao.functions.R")

# load distance matrix
dist <- read.table("data/TV47_Fig4/TV47_bray_curtis.txt")

# load mapping file
sample.types <- read.table("data/TV47_Fig4/TV47_mapping.txt", sep="\t", header=F)

d <- data.frame(Compartment=sample.types$V3,
                Experiment=sample.types$V3,
                Description=sample.types$V2,
                row.names=sample.types$V1)

# load grouping
sample.names <- rownames(dist)
sample.names.ordered <- sample.names[match(colnames(dist),
  as.character(as.matrix(sample.names)))]
sample.types.ordered <- sample.types[match(rownames(dist),
  sample.types$V1 ),]$V3
sample.sites.ordered <- sample.types[match(colnames(dist),
  as.character(as.matrix(sample.types$V1))),]$V3

sample.sites.ordered.cex <- rep(0, length(sample.sites.ordered))
sample.sites.ordered.cex[which(sample.sites.ordered == "B6-GNO")] <- 1
sample.sites.ordered.cex[which(sample.sites.ordered == "OligoMM")] <- 2
sample.sites.ordered.cex[which(sample.sites.ordered == "SPF")] <- 0

# run capscale
cap <- capscale(as.dist(dist) ~ sample.sites.ordered, add=T, sqrt.dist=T)
permanova <- anova.cca(cap)


# generate variability tables and calculate confidence intervals for the variance
cap.tbl <- variability_table(cap)
cap.var <- cap_var_props(cap)
cap.ci <-  cca_ci(cap) # get confidence interval vrom CAA object
print(cap.var)
print(cap.ci)

cap.wa <- cap$CCA$wa # extract the weighted average (sample) scores
# extract centroids of constrained factor
cap.centroids <- cap$CCA$centroids[, 1:2]


# prepare df
df <- as.data.frame(cbind(sample=rownames(dist),cap$CCA$wa[,1:2])) # plot pcoa
constraint <- "Bray-Curtis - constrained by Genotype"

type.names  <- sample.sites.ordered
colorvalues <- c("#f35f67ff", "#42ba43ff", "#6a8ed1ff")

# plot
g <- ggplot(df, aes(x=as.numeric(as.matrix(CAP1)),
    y=as.numeric(as.matrix(CAP2))), color=type.names)
g <- g + geom_point(size= 4, alpha = 0.8, aes(color= type.names))
g <- g + scale_color_manual(values = colorvalues)
g <- g + theme_bw() + geom_hline(yintercept = 0,linetype = 3)
g <- g + geom_vline(xintercept = 0,linetype = 3)
g <- g + ggtitle(paste(constraint, ": [", format(cap.tbl["constrained", "proportion"]*100, digits=2),
          "% of variance; \n P < ", format(permanova[1,4], digits=2),
                  "; 95% CI = ", format(cap.ci[1]*100, digits=2),
          "%, ", format(cap.ci[2]*100, digits=2), "%]", sep="") )
g <- g + xlab(paste("Constrained PCoA 1 (", format(cap.var[1]*100, digits=4), " %)", sep=""))
g <- g + ylab(paste("Constrained PCoA 2 (", format(cap.var[2]*100, digits=4), " %)", sep=""))
g <- g + theme(plot.title = element_text(size = 8),
          axis.title.x = element_text(size = 8),
          axis.title.y = element_text(size = 8))
g
# save as pdf
pdf("results/constrained_pcoa.pdf", width=6, height=4)
g
dev.off()
