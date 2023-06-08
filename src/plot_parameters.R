source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
infile4 <- args[4]
infile5 <- args[5]
infile6 <- args[6]
infile7 <- args[7]
outfile1 <- args[8]
outfile2 <- args[9]
outfile3 <- args[10]
outfile4 <- args[11]

# Load
Allstates <- as.matrix(read.table(infile1, header=FALSE))
Freq <- as.matrix(read.table(infile2, header=FALSE))
P_emp <- as.matrix(read.table(infile3, header=FALSE))
h <- as.matrix(read.table(infile4, header=FALSE))
J <- as.matrix(read.table(infile5, header=FALSE))
E <- as.matrix(read.table(infile6, header=FALSE))
P_est <- as.matrix(read.table(infile7, header=FALSE))

# Allstates (128*7)
png(file=outfile1, width=750, height=750)
image(Allstates)
dev.off()

# Freq, P_emp, E_est, E (2^7)
png(file=outfile2, width=750, height=750)
pairs(cbind(Freq, P_emp, P_est, E), label=c("Freq", "P_emp", "P_est", "E"))
dev.off()

# h (7)
png(file=outfile3, width=750, height=750)
plot(h, type="b")
dev.off()

# J (7*7)
png(file=outfile4, width=750, height=750)
image(J)
dev.off()
