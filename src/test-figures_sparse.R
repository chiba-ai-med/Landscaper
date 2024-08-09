setwd("../")

#######################################
# Non-empty Figures
#######################################
expect_false(file.size("output_sparse/plot/J.png") == 0)
expect_false(file.size("output_sparse/plot/h.png") == 0)
expect_false(file.size("output_sparse/plot/Freq_Prob_Energy.png") == 0)
expect_false(file.size("output_sparse/plot/Allstates.png") == 0)
expect_false(file.size("output_sparse/plot/StatusNetwork_Subgraph.png") == 0)
expect_false(file.size("output_sparse/plot/StatusNetwork_Energy.png") == 0)
expect_false(file.size("output_sparse/plot/Landscape.png") == 0)
expect_false(file.size("output_sparse/plot/Basin.png") == 0)
