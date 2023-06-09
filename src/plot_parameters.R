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
varnames_file <- args[12]

# Load
Allstates <- as.matrix(read.table(infile1, header=FALSE))
Freq <- as.matrix(read.table(infile2, header=FALSE))
P_emp <- as.matrix(read.table(infile3, header=FALSE))
h <- as.matrix(read.table(infile4, header=FALSE))
J <- as.matrix(read.table(infile5, header=FALSE))
rownames(J) <- paste0("V", seq_len(nrow(J)))
E <- as.matrix(read.table(infile6, header=FALSE))
P_est <- as.matrix(read.table(infile7, header=FALSE))

if(varnames_file != "None"){
	varnames <- unlist(read.delim(varnames_file, header=FALSE))
	colnames(Allstates) <- varnames
	rownames(h) <- varnames
	rownames(J) <- varnames
	colnames(J) <- varnames
}

# Allstates (e.g., 128*7)
colnames_Allstates <- colnames(Allstates)
Allstates[] <- as.character(Allstates)
Allstates <- data.frame(id=seq_len(nrow(Allstates)), Allstates)
colnames(Allstates)[2:ncol(Allstates)] <- colnames_Allstates
data1 <- pivot_longer(Allstates, !id)
g1 <- ggplot(data1, aes(x=id, y=name, fill=value))
g1 <- g1 + geom_tile()
g1 <- g1 + labs(x="All States", y="Variable")
g1 <- g1 + scale_fill_manual(values=c("black", "white"))
g1 <- g1 + theme_bw()
ggsave(outfile1, g1, width=7, height=7)

# Freq, P_emp, E_est, E (e.g., 2^7)
data2 <- cbind(Freq, P_emp, P_est, E)
data2 <- as.data.frame(data2)
colnames(data2) <- c("Freq", "P_emp", "P_est", "E")
g2 <- ggpairs(data2)
ggsave(outfile2, g2, width=8, height=7)

# h (e.g., 7)
colnames(h) <- "h"
data3 <- data.frame(Variable=seq_len(nrow(h)), h=h)
g3 <- ggplot(data3, aes(x=Variable, y=h))
g3 <- g3 + geom_line(linewidth=2)
g3 <- g3 + geom_point(aes(size=2))
g3 <- g3 + theme(legend.position = "none")
ggsave(outfile3, g3, width=7, height=7)

# J (e.g., 7*7)
colnames_J <- colnames(J)
J <- data.frame(Var1=rownames(J), J)
colnames(J)[2:ncol(J)] <- colnames_J
data4 <- pivot_longer(J, names_to = "Var2", values_to = "value", !Var1)
g4 <- ggplot(data4, aes(x=Var1, y=Var2, fill=value))
g4 <- g4 + geom_tile()
g4 <- g4 + labs(x="Variable", y="Variable")
g4 <- g4 + scale_fill_viridis()
g4 <- g4 + theme_bw()

ggsave(outfile4, g4, width=7, height=7)
