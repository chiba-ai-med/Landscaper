source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Loading
mat <- read.table(infile, header=FALSE)

# k-means
out <- apply(mat, 2, .mykmeans)

# Save
write.table(out, outfile, col.names=FALSE, row.names=FALSE, quote=FALSE)
