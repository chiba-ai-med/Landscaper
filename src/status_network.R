source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile1 <- args[3]
outfile2 <- args[4]
outfile3 <- args[5]
outfile4 <- args[6]
outfile5 <- args[7]
seed <- args[8]

# Load
Allstates <- as.matrix(read.table(infile1, header=FALSE))
E <- unlist(read.table(infile2, header=FALSE))

# Neighborhood Graph
G_ngh <- Allstates %*% t(Allstates)
position_1 <- which(G_ngh == (ncol(Allstates) - 2))
position_0 <- which(G_ngh != (ncol(Allstates) - 2))
G_ngh[position_1] <- 1
G_ngh[position_0] <- 0

# Adjacency Matrix
A <- t(apply(G_ngh * E, 2, function(x){
	out <- rep(0, length=length(x))
	position <- intersect(
		which(x != 0),
		which(x == min(x)))
	out[position] <- 1
	out
	}))

# Sub Graph Label
g <- graph_from_adjacency_matrix(A)
G_sub <- clusters(g)$membership
Basin <- sapply(unique(G_sub), function(x){
	which(E == min(E[which(G_sub == x)]))
})

# 2D Coordinate
lay_init <- layout_with_kk(g) # Kamada-Kawai layout
set.seed(seed)
lay <- layout_with_fr(g, coords = lay_init, niter = 1000,
                      grid = "nogrid") # FR layout with KK-initialization
Coordinate <- layout.norm(lay, -1, 1, -1, 1) # normalization

# Save
write.table(A, outfile1, quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(G_sub, outfile2, quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(Basin, outfile3, quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(Coordinate, outfile4, quote=FALSE, row.names=FALSE, col.names=FALSE)
save(g, file=outfile5)
