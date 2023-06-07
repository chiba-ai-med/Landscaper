library("dcTensor")
library("IsingSampler")
library("igraph")
library("tagcloud")
library("tidyverse")
library("RColorBrewer")
library("akima")
library("spatstat")
library("magick")
library("cowplot")
library("dendextend")
library("Rcpp")

#################################################
# Disconnectivity graph
#################################################
# a helper function to find route for each leaf, and apply it to all leaves.
pathRoutes <- function(leaf, subtrees) {
  which(sapply(subtrees, function(x) leaf %in% x))
}
