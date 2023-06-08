setwd("../")

#######################################
# Non-empty Figures
#######################################
expect_false(file.size("output/plot/J.png") == 0)
expect_false(file.size("output/plot/h.png") == 0)
expect_false(file.size("output/plot/Freq_Prob_Energy.png") == 0)
expect_false(file.size("output/plot/Allstates.png") == 0)
expect_false(file.size("output/plot/StatusNetwork_Subgraph.png") == 0)
expect_false(file.size("output/plot/StatusNetwork_Energy.png") == 0)
expect_false(file.size("output/plot/Landscape.png") == 0)
expect_false(file.size("output/plot/Basin.png") == 0)
expect_false(file.size("output/plot/discon_graph_2.png") == 0)
expect_false(file.size("output/plot/discon_graph_1.png") == 0)
