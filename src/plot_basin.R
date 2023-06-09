source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]
varnames_file <- args[4]

# Load
Allstates <- as.matrix(read.table(infile1, header=FALSE))
Basin <- unlist(read.table(infile2, header=FALSE))

if(varnames_file != "None"){
	varnames <- unlist(read.delim(varnames_file, header=FALSE))
	colnames(Allstates) <- varnames
}

# Basin (e.g., 4*7)
colnames_Allstates <- colnames(Allstates)
Allstates[] <- as.character(Allstates)
if(length(Basin) == 1){
	Allstates <- data.frame(id=factor(Basin, levels=Basin), t(Allstates[Basin, ]))
}else{
	Allstates <- data.frame(id=factor(Basin, levels=Basin), Allstates[Basin, ])
}
colnames(Allstates)[2:ncol(Allstates)] <- colnames_Allstates
data <- pivot_longer(Allstates, !id)
data$name <- factor(data$name, levels=unique(data$name))
g <- ggplot(data, aes(x=id, y=name, fill=value))
g <- g + geom_tile()
g <- g + labs(x="Basins/Local mimima", y="Variable")
g <- g + scale_fill_manual(values=c("black", "white"))
g <- g + theme_bw()
ggsave(outfile, g, width=7, height=7)
