args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Loading
binmat_1 <- as.matrix(read.table(infile, header=FALSE))

# {?,?} => {-1,1}
uniq_val <- sort(unique(as.vector(binmat_1)))
binmat_2 <- matrix(0, nrow=nrow(binmat_1), ncol=ncol(binmat_1))
binmat_2[which(binmat_1 == uniq_val[1])] <- -1
binmat_2[which(binmat_1 == uniq_val[2])] <- 1

# Save
write.table(binmat_2, outfile, row.names=FALSE, col.names=FALSE, quote=FALSE)
