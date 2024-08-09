#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --nice=50
#SBATCH --requeue
#SBATCH -p node03-06
SLURM_RESTART_COUNT=2

if [ ${9} = "None" ]; then
	if [ ${10} = "FALSE" ]; then
		Rscript src/estimate_ising.R $@
	else
		/julia_bin/bin/julia src/estimate_ising_sparse.jl $@
	fi
else
	if [ ${10} = "FALSE" ]; then
		Rscript src/estimate_ising_cov.R $@
	else
		echo "Covariance-mode with sparse format is not supported for now..."
		exit 1
	fi
fi
