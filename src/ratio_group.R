source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]
group_file <- args[4]
# infile1 = "output_seurat_beta0/Allstates.tsv"
# infile2 = "output_seurat_beta0/BIN_DATA.tsv"
# group_file = "output_seurat_beta0/group.tsv"

# Load
Allstates <- read.delim(infile1, header=FALSE, sep="X")
data <- unlist(read.delim(infile2, header=FALSE, sep="X"))

# Preprocess
# Non-tab delimited file
if(length(grep("\t", data)) == 0){
    data <- gsub(" ", "\t", data)
}
Allstates <- data.frame(state=apply(Allstates, 1, function(x){gsub(" ", "\t", x)}))

if(group_file != "None"){
    group <- unlist(read.delim(group_file, header=FALSE))
    out <- merge(Allstates, as.data.frame(.ratio_group(data, group)),
        by="state", all=TRUE)
    out <- pivot_wider(out, names_from=group, values_from=Freq)
    out <- as.data.frame(out)
    rownames(out) <- out[,1]
    out <- out[,2:(ncol(out)-1)]
    out <- as.matrix(out)
    out[which(is.na(out))] <- 0
    out <- out[Allstates$state, ]
    out <- out[, sort(colnames(out))]
    # Save
    write.table(out, outfile, quote=FALSE)
}else{
    # Empty file
    file.create(outfile)
}
