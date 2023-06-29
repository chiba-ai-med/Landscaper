setwd("../")

#######################################
# Non-empty Figures
#######################################
expect_false(file.size("output_01/plot/J.png") == 0)
expect_false(file.size("output_01/plot/h.png") == 0)
expect_false(file.size("output_01/plot/Freq_Prob_Energy.png") == 0)
expect_false(file.size("output_01/plot/Allstates.png") == 0)
expect_false(file.size("output_01/plot/StatusNetwork_Subgraph.png") == 0)
expect_false(file.size("output_01/plot/StatusNetwork_Energy.png") == 0)
expect_false(file.size("output_01/plot/Landscape.png") == 0)
expect_false(file.size("output_01/plot/Basin.png") == 0)
expect_false(file.size("output_01/plot/discon_graph_2.png") == 0)
expect_false(file.size("output_01/plot/discon_graph_1.png") == 0)
