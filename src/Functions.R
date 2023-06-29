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
library("viridis")
library("GGally")
library("mclust")

#################################################
# GMM-based Binarization
#################################################
.mygmm <- function(x){
    out <- Mclust(x, 2)
    label <- out$classification
    if(out$parameters$mean[1] > out$parameters$mean[2]){
        label[which(label == 1)] <- 1
        label[which(label == 2)] <- -1
    }else{
        label[which(label == 1)] <- -1
        label[which(label == 2)] <- 1
    }
    label
}

#################################################
# Disconnectivity graph
#################################################
# a helper function to find route for each leaf, and apply it to all leaves.
pathRoutes <- function(leaf, subtrees) {
  which(sapply(subtrees, function(x) leaf %in% x))
}
