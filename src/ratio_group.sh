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

INPUT1=$1
INPUT2=$2
OUTPUT=$3
GROUP=$4
INPUT_SPARSE=$5

if [ $GROUP = "None" ]; then
    touch $OUTPUT
else
    if [ $INPUT_SPARSE = "FALSE" ]; then
		/julia_bin/bin/julia src/ratio_group_dense.jl $INPUT1 $INPUT2 $OUTPUT $GROUP
    else
		/julia_bin/bin/julia src/ratio_group_sparse.jl $INPUT1 $INPUT2 $OUTPUT $GROUP
	fi
fi
