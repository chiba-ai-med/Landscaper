source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile1 <- args[3]
outfile2 <- args[4]

# Load
Allstates <- unlist(read.delim(infile1, header=FALSE, sep="X"))
Allstates <- gsub(" ", "\t", Allstates)

if(file.info(infile2)$size != 0){
    # Load
    xtable <- read.table(infile2, sep=" ", header=TRUE)
    out1 <- .major_group(xtable)
    out2 <- .assign_major_group(out1, Allstates)
    # Save
    write.table(out1, outfile1, row.names=FALSE, col.names=FALSE, quote=FALSE)
    write.table(out2, outfile2, row.names=FALSE, col.names=FALSE, quote=FALSE)
}else{
    # Empty file
    file.create(outfile1)
    file.create(outfile2)
}
