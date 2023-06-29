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

# Data size Check
if len(mat.shape) == 1:
    print("There is only one variable.")
    quit()
else:
    if mat.shape[1] > 13:
        np.savetxt(outfile1, [1], fmt="%d")
    else:
        np.savetxt(outfile1, [0], fmt="%d")

# Binary Check
if np.unique(mat).shape[0] == 2:
    np.savetxt(outfile2, [1], fmt="%d")
else:
    np.savetxt(outfile2, [0], fmt="%d")

# Binary Check
if set(np.unique(mat)) == {1.0,-1.0}:
    np.savetxt(outfile3, [1], fmt="%d")
else:
    np.savetxt(outfile3, [0], fmt="%d")
