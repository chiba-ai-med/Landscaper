setwd("../")

#######################################
# Non-empty Figures
#######################################
expect_false(file.size("output_cont/plot/J.png") == 0)
expect_false(file.size("output_cont/plot/h.png") == 0)
expect_false(file.size("output_cont/plot/Freq_Prob_Energy.png") == 0)
expect_false(file.size("output_cont/plot/Allstates.png") == 0)
expect_false(file.size("output_cont/plot/StatusNetwork_Subgraph.png") == 0)
expect_false(file.size("output_cont/plot/StatusNetwork_Energy.png") == 0)
expect_false(file.size("output_cont/plot/Landscape.png") == 0)
expect_false(file.size("output_cont/plot/Basin.png") == 0)
expect_false(file.size("output_cont/plot/discon_graph_2.png") == 0)
expect_false(file.size("output_cont/plot/discon_graph_1.png") == 0)
