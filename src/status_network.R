source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
outfile1 <- args[4]
outfile2 <- args[5]
outfile3 <- args[6]
outfile4 <- args[7]
outfile5 <- args[8]
seed <- args[9]
coordinate_file <- args[10]

# Load
Allstates <- as.matrix(read.table(infile1, header=FALSE))
E <- unlist(read.table(infile2, header=FALSE))
if(file.size(infile3) != 0){
	Group <- read.table(infile3, header=FALSE)
}else{
	Group <- NULL
}

# Neighborhood Graph
G_ngh <- Allstates %*% t(Allstates)
position_1 <- which(G_ngh == (ncol(Allstates) - 2))
position_0 <- which(G_ngh != (ncol(Allstates) - 2))
G_ngh[position_1] <- 1
G_ngh[position_0] <- 0

# Adjacency Matrix (steepest descent): a state that has a strictly lower neighbor
# descends to its lowest-energy neighbor; a state at the bottom (no strictly lower
# neighbor) links to its equal-energy neighbors instead, so that a flat plateau of
# equal-energy minima stays a single connected basin rather than being split.
#
# Three bugs were fixed here:
#  (1) Non-neighbors used to be left as 0 (G_ngh * E) and included in min().
#      Because the energy E takes both signs, that 0 was wrongly selected as the
#      minimum whenever every neighbor had a positive energy, so the state lost
#      its descent edge. Non-neighbors are now masked with Inf.
#  (2) Every state (including local minima) used to be forced to point to its
#      lowest neighbor, even uphill. A shallow minimum was therefore merged into
#      a deeper neighboring basin instead of forming its own. A bottom state is
#      now never made to point uphill, so each basin keeps its bottom.
#  (3) A flat minimum (several adjacent states of exactly equal, locally minimal
#      energy) was missed entirely by the strict "lower than all neighbors" test.
#      Such a plateau is now kept connected and reported as one basin.
M <- G_ngh * E
M[G_ngh == 0] <- Inf
neighbor_min <- apply(M, 2, min)          # lowest neighbor energy of each state
has_lower <- neighbor_min < E             # has a strictly lower neighbor (on a slope)
A <- matrix(0, nrow=length(E), ncol=length(E))
for(j in seq_along(E)){
	if(has_lower[j]){
		A[j, which.min(M[, j])] <- 1                    # descend to lowest neighbor
	}else{
		A[j, which(G_ngh[j, ] == 1 & E == E[j])] <- 1   # link equal-energy plateau
	}
}
if(!is.null(Group)){
	rownames(A) <- Group[, ncol(Group)]
	colnames(A) <- Group[, ncol(Group)]
}

# Sub Graph Label (basins of attraction = weakly connected components)
g <- graph_from_adjacency_matrix(A)
G_sub <- clusters(g)$membership

# Basins = local minima. Each weakly connected component bottoms out at one
# minimum (a single state, or a flat equal-energy plateau); report one
# representative per component (the lowest-index bottom state) so that a plateau
# yields exactly one basin and no two basins are ever adjacent.
Basin <- sapply(sort(unique(G_sub)), function(cl){
	members <- which(G_sub == cl)
	bottoms <- members[!has_lower[members]]
	min(bottoms)
})

if(coordinate_file != "None"){
	Coordinate <- read.table(coordinate_file, header=FALSE)
}else{
	# 2D Coordinate
	lay_init <- layout_with_kk(g) # Kamada-Kawai layout
	set.seed(seed)
	lay <- layout_with_fr(g, coords = lay_init, niter = 1000,
	                      grid = "nogrid") # FR layout with KK-initialization
	Coordinate <- layout.norm(lay, -1, 1, -1, 1) # normalization
}

# Save
write.table(A, outfile1, quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(G_sub, outfile2, quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(Basin, outfile3, quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(Coordinate, outfile4, quote=FALSE, row.names=FALSE, col.names=FALSE)
save(g, file=outfile5)
