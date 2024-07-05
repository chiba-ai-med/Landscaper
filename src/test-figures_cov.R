setwd("../")

#######################################
# Non-empty Figures
#######################################
expect_false(file.size("output_cov/plot/J.png") == 0)
expect_false(file.size("output_cov/plot/h.png") == 0)
expect_false(file.size("output_cov/plot/Freq_Prob_Energy.png") == 0)
expect_false(file.size("output_cov/plot/Allstates.png") == 0)
expect_false(file.size("output_cov/plot/StatusNetwork_Subgraph.png") == 0)
expect_false(file.size("output_cov/plot/StatusNetwork_Energy.png") == 0)
expect_false(file.size("output_cov/plot/Landscape.png") == 0)
expect_false(file.size("output_cov/plot/Basin.png") == 0)
expect_false(file.size("output_cov/plot/discon_graph_2.png") == 0)
expect_false(file.size("output_cov/plot/discon_graph_1.png") == 0)
