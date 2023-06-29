setwd("../")

#######################################
# Allstates.tsv
#######################################
Allstates <- as.matrix(read.table("output_01/Allstates.tsv", header=FALSE))
# Size: States × Variables
expect_equal(dim(Allstates), c(2^7, 7))
# Value: Binary
expect_equal(length(unique(as.vector(Allstates))), 2)

#######################################
# Freq.tsv
#######################################
Freq <- read.table("output_01/Freq.tsv", header=FALSE)
# Size: States
expect_equal(dim(Freq), c(2^7, 1))
# Value: 0 to 2^7
expect_equal(length(which(Freq < 0)), 0)
expect_equal(length(which(Freq > 2^7)), 0)

#######################################
# P_emp.tsv
#######################################
P_emp <- as.matrix(read.table("output_01/P_emp.tsv", header=FALSE))
# Size: States
expect_equal(dim(P_emp), c(2^7, 1))
# Value: 0 to 1
expect_equal(length(which(P_emp < 0)), 0)
expect_equal(length(which(P_emp > 1)), 0)

#######################################
# P_est.tsv
#######################################
P_est <- as.matrix(read.table("output_01/P_est.tsv", header=FALSE))
# Size: States
expect_equal(dim(P_est), c(2^7, 1))
# Value: 0 to 1
expect_equal(length(which(P_est < 0)), 0)
expect_equal(length(which(P_est > 1)), 0)

#######################################
# h.tsv
#######################################
h <- as.matrix(read.table("output_01/h.tsv", header=FALSE))
# Size: Variables
expect_true(length(h) > 0)
expect_true(length(h) < 2^7)
# Correlation with ELAT h
h_elat <- c(-0.2883, 0.1487, 0.3819, -0.2553, 0.3017, 0.3719, -0.0774)
expect_true(cor(h, h_elat) > 0.95)
# Correlation with Ground Truth h
h_true <- c(-0.3, 0.1, 0.4, -0.2, 0.3, 0.4, -0.1)
expect_true(cor(h, h_true) > 0.95)

#######################################
# J.tsv
#######################################
J <- as.matrix(read.table("output_01/J.tsv", header=FALSE))
# Size: Variables × Variables
expect_equal(nrow(J), length(h))
expect_equal(ncol(J), length(h))
# Ground Truth with Ground Truth J
set.seed(1234)
J_true <- matrix(sample(-2:2, 7^2, TRUE, prob = c(0.1, 0.2, 0.4, 0.2, 0.1)), 7, 7)
expect_true(cor(as.vector(J), as.vector(J_true)) > 0.7)
# Ground Truth with ELAT J
J_elat <- c(0.2457, 0.2291, 0.1638, 1.0304, 0.4687, -0.0628,
0.2188, 0.3067, -0.2931, 0.0631, -0.2346,
-0.0243, -0.2648, -0.0229, -0.0454,
0.5257, -0.7398, -0.7019,
0.3073, 0.2760,
-0.0299)
expect_true(cor(J[lower.tri(J)], J_elat) > 0.95)

#######################################
# E.tsv
#######################################
E <- as.matrix(read.table("output_01/E.tsv", header=FALSE))
# Size: States
expect_equal(length(E), 2^7)
