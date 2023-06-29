source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Loading
mat <- as.matrix(read.table(infile, header=FALSE))

# GMM
out <- apply(mat, 2, .mygmm)

# Save
write.table(out, outfile, col.names=FALSE, row.names=FALSE, quote=FALSE)
