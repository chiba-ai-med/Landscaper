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
png(file=outfile1, width=750, height=750)
plot(g, layout=Coordinate,
	vertex.size=3,
	vertex.color=G_sub,
	vertex.label.color="black",
	vertex.label.cex=1.5,
	edge.arrow.size = 0.5)
dev.off()

# 2D Network (Energy label)
colE <- smoothPalette(-E,
	palfunc=colorRampPalette(brewer.pal(9, "YlGnBu")[1:6]))
png(file=outfile2, width=750, height=750)
plot(g, layout=Coordinate,
	vertex.size=3,
	vertex.color=colE,
	vertex.label.color="black",
	vertex.label.cex=1.5,
	edge.arrow.size = 0.5)
dev.off()
