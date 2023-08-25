source("src/Functions.R")
sourceCpp('src/widest_paths.cpp')

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
outfile <- args[4]

# Loading
Allstates <- as.matrix(read.table(infile1, header=FALSE))
E <- unlist(read.table(infile2, header=FALSE))
Basin <- unlist(read.table(infile3, header=FALSE))

# Adjacent Graph
E_max <- max(E)
nparam <- ncol(Allstates)
state_energy <- data.frame(state=seq_along(E)-1, E=E)

expand.grid(from = 1:2^nparam, to = 1:2^nparam) |>
  rowwise() |>
  mutate(hamming = sum(Allstates[from, ] != Allstates[to, ])) |>
  filter(hamming == 1) |>
  arrange(from, to) |>
  mutate(from = from - 1,
         to = to - 1) |>
  select(from, to) |>
  left_join(state_energy, by = c("from" = "state")) |>
  dplyr::rename(E_from = E) |>
  left_join(state_energy, by = c("to" = "state")) |>
  dplyr::rename(E_to = E) |>
  mutate(weight = E_max - max(E_from, E_to)) |>
  select(from, to, weight) -> adjacent_graph

# Energy Barrier
Basin_0 <- Basin - 1
n_Basin <- length(Basin_0)
EnergyBarrier <- matrix(nrow = n_Basin, ncol = n_Basin)
if(n_Basin != 1){
  for(i in 1:(n_Basin - 1)){
    tmp <- widest_paths(adjacent_graph, Basin_0[i])
    for(j in (i + 1):n_Basin){
      EnergyBarrier[i, j] <- E_max - tmp[Basin_0[j] + 1][[1]]$weight
      EnergyBarrier[j, i] <- EnergyBarrier[i, j]
    }
  }
}

# Save
write.table(EnergyBarrier, outfile, quote=FALSE, row.names=FALSE, col.names=FALSE)
