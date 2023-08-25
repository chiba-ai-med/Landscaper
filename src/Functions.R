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
library("reshape")

#################################################
# Group Information
#################################################
.mycolor1 <- rep(c(
    brewer.pal(8, "Dark2"),
    brewer.pal(9, "Set1"),
    brewer.pal(8, "Set2"),
    brewer.pal(12, "Set3"),
    brewer.pal(9, "Pastel1"),
    brewer.pal(8, "Pastel2"),
    brewer.pal(8, "Accent"),
    brewer.pal(12, "Paired"),
    brewer.pal(11, "Spectral"),
    "#000000"), 100)

.mycolor2 <- function(n){
    set.seed(123456)
    out <- sapply(seq(n), function(x){
        rgb(sample(0:255, 1)/255,
            sample(0:255, 1)/255,
            sample(0:255, 1)/255)
    })
    set.seed(NULL)
    out
}

.ratio_group <- function(data, group){
    data.frame(state=data, group=group) %>%
        xtabs(data=.)
}

.major_group <- function(xtable, thr=0.5){
    xtable2 <- apply(xtable, 1, function(x){
        if(sum(x) != 0){
            max_value <- max(x)
            max_index <- which(x == max_value)[1]
            max_ratio <- max_value / sum(x)
        }else{
            max_ratio <- 0
        }
        if(max_ratio > thr){
            tmp <- colnames(xtable)[max_index]
        }else{
            tmp <- "Unknown"
        }
        tmp
    })
    out <- data.frame(rownames(xtable), xtable2)
    rownames(out) <- NULL
    colnames(out) <- NULL
    out[,2] <- make.unique(out[,2])
    out
}

.assign_major_group <- function(major_group, Allstates){
    out <- cbind(Allstates, seq(length(Allstates)), "Unknown")
    for(i in seq_len(nrow(major_group))){
        target <- which(as.character(major_group[i,1]) == out[,1])
        out[target, 3] <- as.character(major_group[i,2])
    }
    rownames(out) <- NULL
    colnames(out) <- NULL
    out
}

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
