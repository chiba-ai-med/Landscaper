setwd("../")

#######################################
# dendrogram.RData
#######################################
load("output/dendrogram.RData")
# Topology: Basin Tree
expect_true(length(subtrees[[1]]) == 4)
expect_true(length(subtrees[[2]]) == 1)
expect_true(length(subtrees[[3]]) == 3)
expect_true(length(subtrees[[4]]) == 1)
expect_true(length(subtrees[[5]]) == 2)
expect_true(length(subtrees[[6]]) == 1)
expect_true(length(subtrees[[7]]) == 1)
