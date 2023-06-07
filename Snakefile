from snakemake.utils import min_version

#################################
# Setting
#################################
# Minimum Version of Snakemake
min_version("7.25.0")

# Required Arguments
INPUT = config["input"]
OUTDIR = config["outdir"]

# Optional Arguments
# COLNAMES = config["colnames"]
# ROWNAMES = config["rownames"]
# TEMPERATURE = config["temp"]
# COORDINATE = config["coordinate"]
# TEXT, Seurat, Loom, 10X
# TYPE = config[""]

# Docker Container
container: 'docker://koki/landscaper_component:20230606'

# All Rules
rule all:
	input:
		OUTDIR + '/plot/Allstates.png',
		OUTDIR + '/plot/Freq_Prob_Energy.png',
		OUTDIR + '/plot/h.png',
		OUTDIR + '/plot/J.png',
		OUTDIR + '/plot/Basin.png',
		OUTDIR + '/plot/StatusNetwork_Subgraph.png',
		OUTDIR + '/plot/StatusNetwork_Energy.png',
		OUTDIR + '/plot/Landscape.png',
		OUTDIR + '/plot/discon_graph_1.png',
		OUTDIR + '/plot/discon_graph_2.png'

#############################################################
# Checks for non-zero/non-empty tensor data and the data size
#############################################################
rule check_input:
	input:
		INPUT
	output:
		OUTDIR + '/FLOAT_DATA.tsv',
		OUTDIR + '/CHECK_BINARY',
		OUTDIR + '/CHECK_LARGE_DATA'
	benchmark:
		OUTDIR + '/benchmarks/check_input.txt'
	log:
		OUTDIR + '/logs/check_input.log'
	shell:
		'src/check_input.sh {input} {output} >& {log}'

#############################################################
# Binarization
#############################################################
rule binarization:
	input:
		OUTDIR + '/FLOAT_DATA.tsv',
		OUTDIR + '/CHECK_BINARY',
		OUTDIR + '/CHECK_LARGE_DATA'
	output:
		OUTDIR + '/BIN_DATA.tsv'
	benchmark:
		OUTDIR + '/benchmarks/binarization.txt'
	log:
		OUTDIR + '/logs/binarization.log'
	shell:
		'src/binarization.sh {input} {output} >& {log}'

#############################################################
# Parameter estimation for Energy Landscape
# Energy for each Spin pattern
#############################################################
rule estimate_ising:
	input:
		OUTDIR + '/BIN_DATA.tsv'
	output:
		OUTDIR + '/Allstates.tsv',
		OUTDIR + '/Freq.tsv',
		OUTDIR + '/P_emp.tsv',
		OUTDIR + '/h.tsv',
		OUTDIR + '/J.tsv',
		OUTDIR + '/E.tsv',
		OUTDIR + '/P_est.tsv'
	benchmark:
		OUTDIR + '/benchmarks/estimate_ising.txt'
	log:
		OUTDIR + '/logs/estimate_ising.log'
	shell:
		'src/estimate_ising.sh {input} {output} >& {log}'

rule plot_parameters:
	input:
		OUTDIR + '/Allstates.tsv',
		OUTDIR + '/Freq.tsv',
		OUTDIR + '/P_emp.tsv',
		OUTDIR + '/h.tsv',
		OUTDIR + '/J.tsv',
		OUTDIR + '/E.tsv',
		OUTDIR + '/P_est.tsv'
	output:
		OUTDIR + '/plot/Allstates.png',
		OUTDIR + '/plot/Freq_Prob_Energy.png',
		OUTDIR + '/plot/h.png',
		OUTDIR + '/plot/J.png'
	benchmark:
		OUTDIR + '/benchmarks/plot_parameters.txt'
	log:
		OUTDIR + '/logs/plot_parameters.log'
	shell:
		'src/plot_parameters.sh {input} {output} >& {log}'

#############################################################
# Status Network
#############################################################
rule status_network:
	input:
		OUTDIR + '/Allstates.tsv',
		OUTDIR + '/E.tsv'
	output:
		OUTDIR + '/StatusNetwork.tsv',
		OUTDIR + '/SubGraph.tsv',
		OUTDIR + '/Basin.tsv',
		OUTDIR + '/Coordinate.tsv',
		OUTDIR + '/igraph.RData'
	benchmark:
		OUTDIR + '/benchmarks/status_network.txt'
	log:
		OUTDIR + '/logs/status_network.log'
	shell:
		'src/status_network.sh {input} {output} >& {log}'

rule plot_basin:
	input:
		OUTDIR + '/Allstates.tsv',
		OUTDIR + '/Basin.tsv'
	output:
		OUTDIR + '/plot/Basin.png'
	benchmark:
		OUTDIR + '/benchmarks/plot_basin.txt'
	log:
		OUTDIR + '/logs/plot_basin.log'
	shell:
		'src/plot_basin.sh {input} {output} >& {log}'

rule plot_status_network:
	input:
		OUTDIR + '/E.tsv',
		OUTDIR + '/SubGraph.tsv',
		OUTDIR + '/Basin.tsv',
		OUTDIR + '/Coordinate.tsv',
		OUTDIR + '/igraph.RData'
	output:
		OUTDIR + '/plot/StatusNetwork_Subgraph.png',
		OUTDIR + '/plot/StatusNetwork_Energy.png'
	benchmark:
		OUTDIR + '/benchmarks/plot_status_network.txt'
	log:
		OUTDIR + '/logs/plot_status_network.log'
	shell:
		'src/plot_status_network.sh {input} {output} >& {log}'

#############################################################
# Landscape by Akima Spline
#############################################################
rule plot_landscape:
	input:
		OUTDIR + '/E.tsv',
		OUTDIR + '/SubGraph.tsv',
		OUTDIR + '/Basin.tsv',
		OUTDIR + '/Coordinate.tsv',
		OUTDIR + '/igraph.RData'
	output:
		OUTDIR + '/plot/Landscape.png'
	benchmark:
		OUTDIR + '/benchmarks/plot_landscape.txt'
	log:
		OUTDIR + '/logs/plot_landscape.log'
	shell:
		'src/plot_landscape.sh {input} {output} >& {log}'

#############################################################
# Disconnectivity graph
#############################################################
rule energy_barrier:
	input:
		OUTDIR + '/Allstates.tsv',
		OUTDIR + '/E.tsv',
		OUTDIR + '/Basin.tsv'
	output:
		OUTDIR + '/EnergyBarrier.tsv'
	benchmark:
		OUTDIR + '/benchmarks/energy_barrier.txt'
	log:
		OUTDIR + '/logs/energy_barrier.log'
	shell:
		'src/energy_barrier.sh {input} {output} >& {log}'

rule dendrogram:
	input:
		OUTDIR + '/E.tsv',
		OUTDIR + '/Basin.tsv',
		OUTDIR + '/EnergyBarrier.tsv'
	output:
		OUTDIR + '/dendrogram.RData'
	benchmark:
		OUTDIR + '/benchmarks/dendrogram.txt'
	log:
		OUTDIR + '/logs/dendrogram.log'
	shell:
		'src/dendrogram.sh {input} {output} >& {log}'

rule plot_discon_graph:
	input:
		OUTDIR + '/dendrogram.RData'
	output:
		OUTDIR + '/plot/discon_graph_1.png',
		OUTDIR + '/plot/discon_graph_2.png'
	benchmark:
		OUTDIR + '/benchmarks/plot_discon_graph.txt'
	log:
		OUTDIR + '/logs/plot_discon_graph.log'
	shell:
		'src/plot_discon_graph.sh {input} {output} >& {log}'
