source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]
outfile3 <- args[4]
outfile4 <- args[5]
outfile5 <- args[6]
outfile6 <- args[7]
outfile7 <- args[8]

# Load
data <- read.table(infile, header=FALSE)

# Fitting
res <- EstimateIsing(data, method="uni")

# Allstates
Allstates <- do.call(expand.grid, lapply(1:ncol(data), function(x)c(-1,1)))

# Frequency
Freq <- apply(Allstates, 1, function(x){
	apply(data, 1, function(xx){
		all(x == xx)
	}) |> which() |> length()
})

# Empirical Probability
P_emp <- Freq / sum(Freq)

# h
h <- res$thresholds

# J
J <- res$graph

# E
E <- apply(Allstates, 1, function(s){IsingSampler:::H(J,s,h)})

# Estimated Probability
P_est <- exp(- E) / sum(exp(- E))

# Save
write.table(Allstates, outfile1, quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(Freq, outfile2, quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(P_emp, outfile3, quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(h, outfile4, quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(J, outfile5, quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(E, outfile6, quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(P_est, outfile7, quote=FALSE, row.names=FALSE, col.names=FALSE)
