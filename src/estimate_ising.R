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
covfile <- args[9]

# Load
data <- read.table(infile, header=FALSE)

if(covfile == "None"){
	# Fitting
	res <- EstimateIsing(data, method="uni")
	# {h,J} Parameter
	h <- res$thresholds
	J <- res$graph
}else{
	# Load
	cov_data <- read.table(covfile, header=FALSE)
	# {-1,1} => {0,1}
	data[which(data == -1)] <- 0
	# Fitting
	res <- runSA(
		ocmat=as.matri(data), enmat=as.matrix(cov_data),
		threads=1, qth=10^-3)
	# {h*,J*} Parameter
	h_ <- res[[1]][, 1]
	g_ <- res[[1]][, 2:(ncol(cov_data)+1)]
	J_ <- res[[1]][, (ncol(cov_data)+1):ncol(res$[[1]])]
	# {0,1} => {-1,1}
	res2 <- LinTransform(
		graph=J_, thresholds=h_,
		from=c(0,1), to=c(-1,1))
	# {h,J} Parameter
	h <- res2$thresholds
	J <- res2$graph
}

# Allstates
Allstates <- do.call(expand.grid,
	lapply(1:ncol(data), function(x)c(-1,1)))

# Frequency
Freq <- apply(Allstates, 1, function(x){
	apply(data, 1, function(xx){
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
