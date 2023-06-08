setwd("../")

#######################################
# EnergyBarrier.tsv
#######################################
EnergyBarrier <- as.matrix(read.table("output/EnergyBarrier.tsv", header=FALSE))
# Size: Basins × Basins
expect_true(nrow(EnergyBarrier) == ncol(EnergyBarrier))
expect_true(nrow(EnergyBarrier) <= 2^7)
# Value: NA in Diagonal
expect_true(all(is.na(diag(EnergyBarrier))))
