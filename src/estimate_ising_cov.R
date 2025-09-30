source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]
outfile3 <- args[4]
outfile4 <- args[5]
outfile5 <- args[6]
outfile6 <- args[7]
outfile7 <- args[8]
covfile <- args[9]

# Load
data_original <- as.matrix(read.table(infile, header=FALSE))
cov_data <- as.matrix(read.table(covfile, header=FALSE))

# {-1,1} => {0,1}
data_bin <- data_original
data_bin[which(data_bin == -1)] <- 0

# Fitting
res <- runSA(ocmat=data_bin, enmat=cov_data, threads=1, qth=10^-3)

# {h*,J*} Parameter
h_ <- res[[1]][, 1]
g_ <- res[[1]][, 2:(ncol(cov_data)+1)]
J_ <- res[[1]][, (ncol(cov_data)+2):ncol(res[[1]])]

# {0,1} => {-1,1}
res2 <- LinTransform(graph=J_, thresholds=h_, from=c(0,1), to=c(-1,1))
h <- res2$thresholds
g <- g_ / 2
J <- res2$graph

# Allstates
Allstates <- do.call(expand.grid,
	lapply(1:ncol(data_original), function(x)c(-1,1)))

# Frequency
Freq <- apply(Allstates, 1, function(x){
	apply(data_original, 1, function(xx){
		all(x == xx)
	}) |> which() |> length()
})

# Empirical Probability
P_emp <- Freq / sum(Freq)

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
write.table(g, file.path(dirname(outfile1), "g.txt"), quote=FALSE, row.names=FALSE, col.names=FALSE)
