# -*- coding: utf-8 -*-

# Package Loading
import sys
import numpy as np

# Arguments passed by Snakemake
args = sys.argv
infile = args[1]
outfile1 = args[2]
outfile2 = args[3]
outfile3 = args[4]

# Loading Data Tensor (NumPy array)
mat = np.loadtxt(infile)

# Non-empty Check
if np.unique(mat).shape[0] == 1:
    print("The data tensor is empty...")
    quit()

# Saving a Numpy array into a Numpy's Binary file
np.save(outfile1, mat)

# Binary Check
if np.unique(mat).shape[0] == 2:
    np.savetxt(outfile2, [1], fmt="%d")
else:
    np.savetxt(outfile2, [0], fmt="%d")

# Data size Check
if mat.shape[1] > 10:
    np.savetxt(outfile3, [1], fmt="%d")
else:
    np.savetxt(outfile3, [0], fmt="%d")
