source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
infile4 <- args[4]
infile5 <- args[5]
outfile <- args[6]

# Load
E <- unlist(read.table(infile1, header=FALSE))
G_sub <- unlist(read.table(infile2, header=FALSE))
Basin <- unlist(read.table(infile3, header=FALSE))
Coordinate <- as.matrix(read.table(infile4, header=FALSE))
load(infile5)

# Preprocess
tmp <- interp(Coordinate[, 1], Coordinate[, 2], E, nx = 200, ny = 200)
zlim <- tmp$z |> as.vector() |> na.omit() |> range()

# Plot
png(file=outfile, width=1000, height=1000)
filled.contour(tmp, color.palette = colorRampPalette(topo.colors(11, alpha = 1)), xlim = c(-1, 1), ylim = c(-1, 1), zlim = zlim, asp = 1, nlevels = 24,
	key.title = title(main="Energy"),
	axes = FALSE,
	plot.axes = {
	contour(tmp$x, tmp$y, tmp$z, add = TRUE,
		levels = seq(-10, 10, by=1), col = "gray75")
	plot(g, layout=Coordinate,
		vertex.label.color = "black",
		vertex.label.cex = 1.6,
		vertex.size = 1.0,
		vertex.color = factor(G_sub),
		edge.arrow.size = 0.1, add = TRUE, axes=FALSE)
	})
dev.off()
