source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
infile4 <- args[4]
infile5 <- args[5]
outfile1 <- args[6]
outfile2 <- args[7]

# Load
E <- unlist(read.table(infile1, header=FALSE))
G_sub <- unlist(read.table(infile2, header=FALSE))
Basin <- unlist(read.table(infile3, header=FALSE))
Coordinate <- as.matrix(read.table(infile4, header=FALSE))
load(infile5)

# 2D Network (Sub graph label)
if(length(E) < 1024){
	png(file=outfile1, width=1000, height=1000)
	plot(g, layout=Coordinate,
		vertex.size=3,
		vertex.color=G_sub,
		vertex.label.color="black",
		vertex.label.cex=1.5,
		edge.arrow.size = 0.5)
	dev.off()
}else{
	png(file=outfile1, width=1500, height=1500)
	plot(g, layout=Coordinate,
		vertex.size=1,
		vertex.color=G_sub,
		vertex.label.color="black",
		vertex.label.cex=1.2,
		edge.arrow.size = 0.5)
	dev.off()
}

# 2D Network (Energy label)
colE <- smoothPalette(-E,
	palfunc=colorRampPalette(brewer.pal(9, "YlGnBu")[1:6]))
if(length(E) < 1024){
	png(file=outfile2, width=1000, height=1000)
	plot(g, layout=Coordinate,
		vertex.size=3,
		vertex.color=colE,
		vertex.label.color="black",
		vertex.label.cex=1.5,
		edge.arrow.size = 0.5)
	dev.off()
}else{
	png(file=outfile2, width=1500, height=1500)
	plot(g, layout=Coordinate,
		vertex.size=1,
		vertex.color=colE,
		vertex.label.color="black",
		vertex.label.cex=1.2,
		edge.arrow.size = 0.5)
	dev.off()
}
