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
if np.count_nonzero(mat) == 0:
    print("The data tensor is empty...")
    quit()

# Non-negative Check
boolmat = mat < 0
if boolmat.sum() != 0:
    print("The data tensor contains negative elements...")
    quit()

# Convert Int => Float
mat = 1.0 * mat

# Saving a Numpy array into a Numpy's Binary file
np.save(outfile1, mat)

# Binary Check
zeromat = mat == 0
onemat = mat == 1
if zeromat.sum() + onemat.sum() == mat.shape[0]*mat.shape[1]:
    np.savetxt(outfile2, [1], fmt="%d")
else:
    np.savetxt(outfile2, [0], fmt="%d")

# Data size Check
if mat.shape[1] > 10:
    np.savetxt(outfile3, [1], fmt="%d")
else:
    np.savetxt(outfile3, [0], fmt="%d")
