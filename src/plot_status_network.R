source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
infile4 <- args[4]
infile5 <- args[5]
infile6 <- args[6]
infile7 <- args[7]
outfile1 <- args[8]
outfile2 <- args[9]
outfile3 <- args[10]
outfile4 <- args[11]
outfile5 <- args[12]
outfile6 <- args[13]
outfile7 <- args[14]
outfile8 <- args[15]

# Load
E <- unlist(read.table(infile1, header=FALSE))
G_sub <- unlist(read.table(infile2, header=FALSE))
Basin <- unlist(read.table(infile3, header=FALSE))
Coordinate <- as.matrix(read.table(infile4, header=FALSE))
load(infile5)
if(file.size(infile6) != 0){
    data <- read.delim(infile6, header=TRUE, sep=" ")
}else{
    data <- NULL
}
if(file.size(infile7) != 0){
    Group <- read.delim(infile7, header=FALSE, sep=" ")
}else{
    Group <- NULL
}

# 2D Network (Sub graph label)
if(length(E) < 1024){
	png(file=outfile1, width=1000, height=1000)
	plot(g, layout=Coordinate,
		vertex.size=3,
		vertex.color=.mycolor1[G_sub],
		vertex.label.color="black",
		vertex.label.cex=0.5,
		edge.arrow.size = 0.5)
	dev.off()
}else{
	png(file=outfile1, width=1500, height=1500)
	plot(g, layout=Coordinate,
		vertex.size=1,
		vertex.color=.mycolor1[G_sub],
		vertex.label.color="black",
		vertex.label.cex=0.5,
		edge.arrow.size = 0.5)
	dev.off()
}

# Legend
num_group <- length(unique(G_sub))
png(file=outfile2, width=2000, height=1000)
plot(seq(num_group), col=.mycolor1[seq(num_group)],
	pch=16, cex=10, ylab="Sub group", xlab="", bty="n")
dev.off()

# 2D Network (Energy label)
colE <- smoothPalette(E, palfunc=colorRampPalette(viridis(100)))
if(length(E) < 1024){
	png(file=outfile3, width=1000, height=1000)
	plot(g, layout=Coordinate,
		vertex.size=3,
		vertex.color=colE,
		vertex.label.color="black",
		vertex.label.cex=0.5,
		edge.arrow.size = 0.5)
	dev.off()
}else{
	png(file=outfile3, width=1500, height=1500)
	plot(g, layout=Coordinate,
		vertex.size=1,
		vertex.color=colE,
		vertex.label.color="black",
		vertex.label.cex=0.5,
		edge.arrow.size = 0.5)
	dev.off()
}

# Legend
colE2 <- smoothPalette(sort(E), palfunc=colorRampPalette(viridis(100)))
png(file=outfile4, width=2000, height=1000)
plot(seq(length(E)), sort(E), col=colE2,
	pch=16, cex=2, ylab="Energy", xlab="", bty="n")
dev.off()

# 2D Network (Group Ratio label)
if(!is.null(data)){
	# Set color
	V(g)$pie.color <- list(.mycolor1[seq(ncol(data))])
	values <- lapply(seq_along(V(g)), function(x){
		rep(1, length=ncol(data))
	})
	mask_color <- rep(rgb(1,1,1), length=length(g))
	for(i in seq_len(length(g))){
		if(sum(data[i,]) != 0){
			values[[i]] <- unlist(data[i,])
			mask_color[i] <- rgb(0,0,0,0)
		}
	}
	if(length(E) < 1024){
		png(file=outfile5, width=1000, height=1000)
		plot(g, layout=Coordinate,
			vertex.size=3,
			vertex.shape="pie",
			vertex.pie=values,
			vertex.pie.lty=0,
			vertex.label=NA,
			edge.arrow.size = 0.5)
		par(new=TRUE)
		plot(g, layout=Coordinate,
			vertex.size=3,
			vertex.color=mask_color,
			vertex.label=NA,
			edge.arrow.size = 0)
		dev.off()
	}else{
		png(file=outfile5, width=1500, height=1500)
		plot(g, layout=Coordinate,
			vertex.size=1,
			vertex.shape="pie",
			vertex.pie=values,
			vertex.pie.lty=0,
			vertex.label=NA,
			edge.arrow.size = 0.5)
		par(new=TRUE)
		plot(g, layout=Coordinate,
			vertex.size=1,
			vertex.color=mask_color,
			vertex.label=NA,
			edge.arrow.size = 0)
		dev.off()
	}
	# Legend
	mylegend <- colnames(data)
	mycolor <- .mycolor1[seq(ncol(data))]
	png(file=outfile6, width=2000, height=1000)
	plot.new()
	legend("center", legend=mylegend, col=mycolor,
		pch=16, cex=2, ncol=8)
	dev.off()
}else{
	file.create(outfile5)
	file.create(outfile6)
}

# State
if(length(E) < 1024){
	png(file=outfile7, width=1000, height=1000)
	plot(g, layout=Coordinate,
		vertex.size=3,
		vertex.color=.mycolor2(length(V(g))),
		vertex.label.color="black",
		vertex.label.cex=0.5,
		edge.arrow.size = 0.5)
	dev.off()
}else{
	png(file=outfile7, width=1500, height=1500)
	plot(g, layout=Coordinate,
		vertex.size=1,
		vertex.color=.mycolor2(length(V(g))),
		vertex.label.color="black",
		vertex.label.cex=0.5,
		edge.arrow.size = 0.5)
	dev.off()
}

# Legend
num_state <- length(V(g))
png(file=outfile8, width=2000, height=1000)
plot(seq(num_state), col=.mycolor2(num_state),
	pch=16, cex=10, ylab="Sub group", xlab="", bty="n")
dev.off()
