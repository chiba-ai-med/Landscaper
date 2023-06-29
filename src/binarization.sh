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

INPUT=$1
LARGE_DATA=`cat $2`
BIN_DATA=`cat $3`
ONE_minusONE_DATA=`cat $4`
OUTPUT=$5

if [ $LARGE_DATA = 1 ]; then
	# Semi-binary Matrix Factorization-based Binarization
	echo "The dimension is too large!!!"
	echo "Use SBMFCV to reduce the dimension and binarize at once."
	echo "cf. https://github.com/chiba-ai-med/SBMFCV"
	exit 1
else
	if [ $BIN_DATA = 1 ]; then
		if [ $ONE_minusONE_DATA = 1 ]; then
			# Small binary data can be directly used for down-stream analysis
			echo "Small binary data can be directly used for down-stream analysis"
			cp $INPUT $OUTPUT
		else
			# Convert the binary elements into {-1,1}
			echo "Convert the binary elements into {-1,1}"
			Rscript src/myconvert_one_minusone.R $INPUT $OUTPUT
		fi
	else
		# GMM-based Binarization
		echo "GMM-based Binarization"
		Rscript src/gmm_binarization.R $INPUT $OUTPUT
	fi
fi
