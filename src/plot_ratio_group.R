source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]

if(file.size(infile) != 0){
	# Load
	data <- read.delim(infile, header=TRUE, sep=" ")
	data <- data.frame(state=rownames(data), data)
	gdata <- melt(data)
	gdata$state <- gsub("\t", "", gdata$state)
	# Freq => Percent
	gdata %>%
		group_by(variable, state) %>%
		summarise(cnt = sum(value)) %>%
		mutate(percent = round(cnt / sum(cnt), 3)) %>%
		ungroup() -> gdata
	# ggplot2
	g <- ggplot(gdata, aes(x=1, y=percent, fill=state))
	g <- g + geom_bar(stat="identity")
	g <- g + coord_polar(theta = "y")
	g <- g + theme(axis.text.x=element_blank())
	g <- g + theme(axis.text.y=element_blank())
	g <- g + labs(x = NULL, y=NULL)
	g <- g + facet_wrap(~variable)
	g <- g + scale_fill_manual(values=.mycolor2(length(unique(gdata$state))))
	g1 <- g + theme(legend.position = "none")
	g2 <- gtable::gtable_filter(ggplotGrob(g_tmp), pattern = "guide-box")
	# Save
	ggsave(outfile1, plot=g1, width=15, height=20)
	ggsave(outfile2, plot=g2, width=15, height=20)
}else{
	file.create(outfile1)
	file.create(outfile2)
}