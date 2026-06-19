setwd("../")

#######################################
# StatusNetwork.tsv
#######################################
A <- as.matrix(read.table("output_cont/StatusNetwork.tsv", header=FALSE))
# Size: States × States
expect_equal(dim(A), c(2^7, 2^7))
# Value: Binary
expect_equal(length(unique(as.vector(A))), 2)

#######################################
# SubGraph.tsv
#######################################
G_sub <- read.table("output_cont/SubGraph.tsv", header=FALSE)
# Size: States
expect_equal(dim(G_sub), c(2^7, 1))
# Value: 1 to States
expect_true(min(G_sub) > 0)
expect_true(max(G_sub) < 2^7)

#######################################
# Basin.tsv
#######################################
Basin <- read.table("output_cont/Basin.tsv", header=FALSE)
# Size: 1 to States
expect_true(nrow(Basin) < 2^7)
# Value: 1 to States
expect_true(min(Basin) > 0)
expect_true(max(Basin) < 2^7)

#######################################
# Coordinate.tsv
#######################################
Coordinate <- read.table("output_cont/Coordinate.tsv", header=FALSE)
# Size: States × 2
expect_equal(dim(Coordinate), c(2^7, 2))

#######################################
# igraph.RData
#######################################
load("output_cont/igraph.RData")
# Type: igraph object
expect_true("igraph" %in% is(g))

#######################################
# Basins are valid local minima (regression test for the steepest-descent
# zero/sign bug in status_network.R). Each basin must be strictly lower than all
# its Hamming-1 neighbors; this also guarantees no two basins are adjacent.
#######################################
Allstates <- as.matrix(read.table("output_cont/Allstates.tsv", header=FALSE))
E <- unlist(read.table("output_cont/E.tsv", header=FALSE))
Basin_idx <- unlist(read.table("output_cont/Basin.tsv", header=FALSE))
G_ngh <- (Allstates %*% t(Allstates)) == (ncol(Allstates) - 2)
for(b in Basin_idx){
	expect_true(all(E[which(G_ngh[b, ])] >= E[b]))
}
if(length(Basin_idx) > 1){
	pairs <- combn(Basin_idx, 2)
	for(k in seq_len(ncol(pairs))){
		expect_false(G_ngh[pairs[1, k], pairs[2, k]])
	}
}
