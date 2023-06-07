source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Load
Allstates <- as.matrix(read.table(infile1, header=FALSE))
Basin <- unlist(read.table(infile2, header=FALSE))

# Plot
png(file=outfile, width=750, height=750)
image(Allstates[Basin,])
dev.off()
