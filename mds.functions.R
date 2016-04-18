plotMds <- function(dist){
	mds.coor <- cmdscale(as.dist(1-dist))
	plot(mds.coor[,1], mds.coor[,2], type="n", xlab="", ylab="")
	text(jitter(mds.coor[,1]), jitter(mds.coor[,2]),
	     rownames(mds.coor), cex=0.8)
	abline(h=0,v=0,col="gray75")
	plot(hclust(dist(as.dist(1-dist)), method="single"))
}