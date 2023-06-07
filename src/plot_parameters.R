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
infile1 = 'output/Allstates.tsv'
infile2 = 'output/Freq.tsv'
infile3 = 'output/P_emp.tsv'
infile4 = 'output/h.tsv'
infile5 = 'output/J.tsv'
infile6 = 'output/E.tsv'
infile7 = 'output/P_est.tsv'

# 128*7
Allstates <- as.matrix(read.table(infile1, header=FALSE))
# 128
Freq <- as.matrix(read.table(infile2, header=FALSE))
# 128
P_emp <- as.matrix(read.table(infile3, header=FALSE))
# 7
h <- as.matrix(read.table(infile4, header=FALSE))
# 7*7
J <- as.matrix(read.table(infile5, header=FALSE))
# 128
E <- as.matrix(read.table(infile6, header=FALSE))
# 128
P_est <- as.matrix(read.table(infile7, header=FALSE))

# Allstates
png(file=outfile1, width=750, height=750)
image(Allstates)
dev.off()

# 128
png(file=outfile2, width=750, height=750)
pairs(cbind(Freq, P_emp, P_est, E), label=c("Freq", "P_emp", "P_est", "E"))
dev.off()

# 7
png(file=outfile3, width=750, height=750)
plot(h, type="b")
dev.off()

# 7*7
png(file=outfile4, width=750, height=750)
image(J)
dev.off()
