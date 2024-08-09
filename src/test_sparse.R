library("testthat")

test1 <- test_file("/work/src/test-estimate_ising_sparse.R")
test2 <- test_file("/work/src/test-status_network_sparse.R")
test3 <- test_file("/work/src/test-energy_barrier_sparse.R")
test4 <- test_file("/work/src/test-figures_sparse.R")

no_errors <- unlist(lapply(list(test1, test2, test3, test4), length))

target <- which(no_errors != 0)

if(length(target) != 0){
	msg <- paste0(paste(target, collapse=","), "-th tests return errors!!!!!!!")
	stop(msg)
}
