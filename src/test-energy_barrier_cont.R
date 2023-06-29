setwd("../")

#######################################
# EnergyBarrier.tsv
#######################################
EnergyBarrier <- as.matrix(read.table("output_cont/EnergyBarrier.tsv", header=FALSE))
# Size: Basins × Basins
expect_true(nrow(EnergyBarrier) == ncol(EnergyBarrier))
expect_true(nrow(EnergyBarrier) <= 2^7)
# Value: NA in Diagonal
expect_true(all(is.na(diag(EnergyBarrier))))
