# -*- coding: utf-8 -*-

# Package Loading
import sys
import numpy as np

# Arguments passed by Snakemake
args = sys.argv
infile = args[1]
outfile = args[2]

# Loading Data Tensor (NumPy array)
mat = np.load(infile)

# Median-based Binarization
med = np.median(mat, axis=0)
binmat = (mat >= med).astype(int)

# Saving a Numpy array into a Numpy's Binary file
np.save(outfile, binmat)
