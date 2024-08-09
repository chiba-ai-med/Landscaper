# -*- coding: utf-8 -*-

# Package Loading
import sys
import numpy as np
import scipy as sp

# Arguments passed by Snakemake
args = sys.argv
infile = args[1]
outfile1 = args[2]
outfile2 = args[3]
outfile3 = args[4]

# Loading Data Tensor (NumPy array)
mat = sp.io.mmread(infile)
mat = sp.sparse.csr_matrix(mat)

# Non-empty Check
if len(mat.data) == 0:
    print("The data tensor is empty...")
    quit()

# Data size Check
if len(mat.shape) == 1:
    print("There is only one variable.")
    quit()
else:
    if mat.shape[1] > 21:
        np.savetxt(outfile1, [1], fmt="%d")
    else:
        np.savetxt(outfile1, [0], fmt="%d")

# Binary Check
np.savetxt(outfile2, [1], fmt="%d")

# Binary Check
np.savetxt(outfile3, [0], fmt="%d")
