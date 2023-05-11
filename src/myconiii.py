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


# Import common libraries.
from coniii import *
# Import file containing full equations for solving the n=5 system.
from coniii.ising_eqn import ising_eqn_5_sym

# Generate example data set.
n = 5  # system size
np.random.seed(0)  # standardize random seed
h = np.random.normal(scale=.1, size=n)           # random couplings
J = np.random.normal(scale=.1, size=n*(n-1)//2)  # random fields
hJ = np.concatenate((h, J))
p = ising_eqn_5_sym.p(hJ)  # probability distribution of all states p(s)
sisjTrue = ising_eqn_5_sym.calc_observables(hJ)  # exact means and pairwise correlations

allstates = bin_states(n, True)  # all 2^n possible binary states in {-1,1} basis
sample = allstates[np.random.choice(range(2**n),
                                    size=1000,
                                    replace=True,
                                    p=p)]  # random sample from p(s)
sisj = pair_corr(sample, concat=True)  # means and pairwise correlations

# Define useful functions for measuring success fitting procedure.
def error_on_correlations(estSisj):
    return np.linalg.norm( sisj - estSisj )

def error_on_multipliers(estMultipliers):
    return np.linalg.norm( hJ - estMultipliers )

def summarize(solver):
    print("Error on sample corr: %E"%error_on_correlations(solver.model.calc_observables(solver.multipliers)))
    print("Error on multipliers: %E"%error_on_multipliers(solver.multipliers))







# Declare and call solver.
solver = Enumerate(sample)
solver.solve()
summarize(solver)



# Plot comparison of model results with the data.
fig,ax = plt.subplots(figsize=(10.5,4), ncols=2)
ax[0].plot(sisj, solver.model.calc_observables(solver.multipliers), 'o')
ax[0].plot([-1,1], [-1,1], 'k-')
ax[0].set(xlabel='Measured correlations', ylabel='Predicted correlations')

ax[1].plot(hJ, solver.multipliers, 'o')
ax[1].plot([-1,1], [-1,1], 'k-')
ax[1].set(xlabel='True parameters', ylabel='Solved parameters')

fig.subplots_adjust(wspace=.5)


# # Saving a Numpy array into a Numpy's Binary file
# np.save(outfile1, mat)
