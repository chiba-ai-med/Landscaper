source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
outfile <- args[4]

# Load
Allstates <- as.matrix(read.table(infile1, header=FALSE))
E <- unlist(read.table(infile2, header=FALSE))
Basin <- unlist(read.table(infile3, header=FALSE))

# Preprocess
# Weighted Graph between Basins
BasinPairs <- expand.grid(Basin, Basin)
g_basin <- graph.data.frame(BasinPairs)
E(g_basin)$weight <- apply(BasinPairs, 1, function(Allstates, x){
	InterMax(Allstates, x[1], x[2]) - E[x[1]]
	}, Allstates=Allstates)

# Shortest paths
energy_barrier <- lapply(Basin, function(x){
	shortest.paths(g_basin,
	v=as.character(x),
	to=V(g_basin),
	algorithm="dijkstra")
})
energy_barrier <- do.call("rbind", energy_barrier)
hc <- hclust(as.dist(energy_barrier), method = "single")




mfunc_DisconnectivityGraph <- function(E, LocalMinIndex, AdjacentList) {
  # Set adjacency matrix（ここはAとするだけで良い）
  sy <- nrow(AdjacentList)
  sx <- ncol(AdjacentList)
  AdjacencyMatrix <- matrix(FALSE, sy, sy)
  tmp1 <- matrix(rep(1:sy, sx), nrow = sx)
  tmp2 <- t(AdjacentList)
  AdjacencyMatrix[cbind(tmp1, tmp2)] <- TRUE
  AdjacencyMatrix <- as(AdjacencyMatrix, "sparseMatrix")

  # Set weight matrix（ここがわからない）
  Weight <- matrix(0, sy, sy)
  tmp3 <- matrix(0, sy, sx)
  for (i in 2:sx) {
    tmp3[, i] <- pmax(E[AdjacentList[, 1]], E[AdjacentList[, i]])
  }
  tmp3 <- t(tmp3)
  Weight[cbind(tmp1, tmp2)] <- tmp3
  Weight <- as(Weight, "sparseMatrix")

  # Set start and end point
  StartPos <- LocalMinIndex
  EndPos <- LocalMinIndex

  # Dijkstra
  # shortest.paths(G, v=1, to=V(G), algorithm="dijkstra")に書き換え
  fShowFigure <- TRUE
  result <- dijkstra(AdjacencyMatrix, Weight, StartPos, EndPos, fShowFigure)
  Cost <- result$Cost
  Path <- result$Path

  # Show dendrogram
  Y <- nonzeros(tril(Cost))
  Z <- hclust(dist(Y))
  dendrogram(Z, distfun = function(x) x, hang = -1, main = "Disconnectivity Graph")
}

# Ref
# https://github.com/tkEzaki/energy-landscape-analysis/blob/master/mfunc_DisconnectivityGraph.m