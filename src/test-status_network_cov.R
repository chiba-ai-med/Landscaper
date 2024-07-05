setwd("../")

#######################################
# StatusNetwork.tsv
#######################################
A <- as.matrix(read.table("output_cov/StatusNetwork.tsv", header=FALSE))
# Size: States × States
expect_equal(dim(A), c(2^7, 2^7))
# Value: Binary
expect_equal(length(unique(as.vector(A))), 2)

#######################################
# SubGraph.tsv
#######################################
G_sub <- read.table("output_cov/SubGraph.tsv", header=FALSE)
# Size: States
expect_equal(dim(G_sub), c(2^7, 1))
# Value: 1 to States
expect_true(min(G_sub) > 0)
expect_true(max(G_sub) < 2^7)

#######################################
# Basin.tsv
#######################################
Basin <- read.table("output_cov/Basin.tsv", header=FALSE)
# Size: 1 to States
expect_true(nrow(Basin) < 2^7)
# Value: 1 to States
expect_true(min(Basin) > 0)
expect_true(max(Basin) < 2^7)

#######################################
# Coordinate.tsv
#######################################
Coordinate <- read.table("output_cov/Coordinate.tsv", header=FALSE)
# Size: States × 2
expect_equal(dim(Coordinate), c(2^7, 2))

#######################################
# igraph.RData
#######################################
load("output_cov/igraph.RData")
# Type: igraph object
expect_true("igraph" %in% is(g))
