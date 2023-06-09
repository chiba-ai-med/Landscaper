library("testthat")

test1 <- test_file("/work/src/test-estimate_ising.R")
test2 <- test_file("/work/src/test-status_network.R")
test3 <- test_file("/work/src/test-energy_barrier.R")
test4 <- test_file("/work/src/test-dendrogram.R")
test5 <- test_file("/work/src/test-figures.R")

no_errors <- unlist(lapply(list(test1, test2, test3, test4, test5), length))

target <- which(no_errors != 0)

if(length(target) != 0){
	msg <- paste0(paste(target, collapse=","), "-th tests return errors!!!!!!!")
	stop(msg)
}
