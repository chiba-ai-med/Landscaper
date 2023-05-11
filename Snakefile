from snakemake.utils import min_version

#################################
# Setting
#################################
# Minimum Version of Snakemake
min_version("7.24.0")

# Required Arguments
INPUT = config["input"]
OUTDIR = config["outdir"]

# Optional Arguments


# Docker Container
container: 'docker://koki/landscaper_component:20230511'

# All Rules
rule all:
	input:
		OUTDIR + '/BIN_DATA.npy'

#############################################################
# Checks for non-zero/non-empty tensor data and the data size
#############################################################
rule check_input:
	input:
		INPUT
	output:
		OUTDIR + '/FLOAT_DATA.npy',
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
		OUTDIR + '/FLOAT_DATA.npy',
		OUTDIR + '/CHECK_BINARY',
		OUTDIR + '/CHECK_LARGE_DATA'
	output:
		OUTDIR + '/BIN_DATA.npy'
	benchmark:
		OUTDIR + '/benchmarks/binarization.txt'
	log:
		OUTDIR + '/logs/binarization.log'
	shell:
		'src/binarization.sh {input} {output} >& {log}'

#############################################################
# Parameter estimation for Energy Landscape
#############################################################
# rule coniii:
