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

if [ $5 = "FALSE" ]; then
	echo "Dense Matrix"
	python3 src/mycheck_input.py $@
else
	echo "Sparse Matrix"
	python3 src/mycheck_input_sparse.py $@
fi