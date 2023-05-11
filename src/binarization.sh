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

BIN_DATA=`cat $2`
LARGE_DATA=`cat $3`

if [ $BIN_DATA = 0 ]; then
	cp $1 $4
else
	if [ $LARGE_DATA = 0 ]; then
		# Median-based Binarization
		python src/mymedian_binarization.py $1 $4
	else
		# Semi-binary Matrix Factorization-based Binarization
		Rscript src/smbf_binarization.R $1 $4
	fi
fi