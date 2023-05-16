# -*- coding: utf-8 -*-

# Package Loading
import sys
import numpy as np
from coniii import *

# Arguments passed by Snakemake
args = sys.argv
infile = args[1]
outfile1 = args[2]
outfile2 = args[3]

# Loading Data Tensor (NumPy array)
mat = np.load(infile)

# Declare and call solver.
solver = Enumerate(mat)
solver.solve()
h = solver.multipliers[range(0, mat.shape[1])]
J = solver.multipliers[range(mat.shape[1], solver.multipliers.shape[0])]

# Save
np.savetxt(outfile1, h, fmt="%d")
np.savetxt(outfile2, J, fmt="%d")
