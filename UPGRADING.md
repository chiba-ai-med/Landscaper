# Upgrading / Re-running past analyses

This document explains, per fix that changes results, **whether you need to
re-run an analysis you produced with an older version**. Decide per project
using the criteria below.

---

## v1.7.1 — basin (local-minima) extraction fix

### What was wrong
The basin (local-minima) extraction in `src/status_network.R` was incorrect.
Concretely, the steepest-descent step that assigns each state to a basin of
attraction could:

- report **basins that are not true local minima** (a state whose Hamming-1
  neighbor has lower or equal energy);
- report **two basins that are directly adjacent** (local minima must differ by
  more than one spin, so they can never be neighbors);
- **miss or merge shallow minima** into a deeper neighboring basin; and
- **mishandle flat plateaus** (several adjacent states of exactly equal,
  locally-minimal energy).

The root cause was that non-neighbors were encoded as `0` and included in a
`min()` over energies that take both signs, so a `0` could win as the
"minimum"; local minima were also forced to point uphill instead of being
treated as sinks. See the comment block in `src/status_network.R` for details.

### Which outputs are affected — and which are NOT
The Ising fit itself is **unchanged**. Only basin extraction and everything
downstream of it changes.

**NOT affected (upstream — safe to reuse as-is):**
`binarization` and `estimate_ising` outputs — `Allstates.tsv`, `E.tsv`,
`h.tsv`, `J.tsv`, `P_emp.tsv`, `P_est.tsv`, `Freq.tsv`. The binarized data,
the Ising parameters (h, J), the per-state energies, and the empirical/estimated
state probabilities are all identical.

**Affected (`status_network` and downstream — regenerated):**
`StatusNetwork.tsv`, `SubGraph.tsv`, `Basin.tsv`, `Coordinate.tsv`,
`igraph.RData`, `EnergyBarrier.tsv`, `dendrogram.RData`, and every figure that
depends on them: `plot/Basin.png`, `plot/StatusNetwork_*.png`,
`plot/Landscape.png`, `plot/discon_graph_*.png`.

### Do I need to re-run a given project?
**Re-run** if the project used or reported any of:

- basins / local minima (their number, identity, or which states belong to which);
- basin-of-attraction membership (`SubGraph`);
- energy barriers between basins, or the disconnectivity (tree) graph;
- the energy landscape figure colored by basin;
- the count of stable states.

**No re-run needed** if the project only used upstream quantities: the binarized
matrix, the Ising parameters (h, J), the per-state energies, or the
empirical/estimated state probabilities — i.e. no basin / landscape-topology
analysis.

> The bug was present in **all releases up to and including v1.7.0**, so any
> result produced before v1.7.1 is potentially affected.

### Quick self-check on an existing output directory
For standard / covariate / continuous output (binarized as `{-1, 1}`), this
tells you whether a past run was actually wrong. Replace `OUTDIR`:

```r
Allstates <- as.matrix(read.table("OUTDIR/Allstates.tsv", header = FALSE))
E         <- unlist(read.table("OUTDIR/E.tsv",         header = FALSE))
Basin     <- unlist(read.table("OUTDIR/Basin.tsv",     header = FALSE))

# Hamming-1 neighbor graph (requires +/-1 encoding)
G_ngh <- (Allstates %*% t(Allstates)) == (ncol(Allstates) - 2)

# (1) every reported basin must be a true local minimum
not_minima <- Filter(function(b) any(E[which(G_ngh[b, ])] < E[b]), Basin)

# (2) no two basins may be adjacent
adjacent <- FALSE
if (length(Basin) > 1) {
    pr <- combn(Basin, 2)
    adjacent <- any(apply(pr, 2, function(ij) G_ngh[ij[1], ij[2]]))
}

if (length(not_minima) == 0 && !adjacent) {
    cat("OK: basins are valid local minima -> this project is UNAFFECTED.\n")
} else {
    cat("AFFECTED: re-run this project (invalid or adjacent basins found).\n")
}
```

(Sparse / MatrixMarket output is written in `{-1, 1}` by the current code, so
the same check applies; only legacy `{0, 1}` artifacts need the neighbor formula
adjusted.)

### How to re-run efficiently
You do **not** need to refit the Ising model. The `estimate_ising` outputs are
unaffected and deterministic, so you can reuse them and recompute only from
`status_network` onward. The simplest, fully-reproducible option is to re-run
the whole pipeline with the same seed:

```bash
./landscaper -i <your-input> -o <your-outdir> -s <same-seed> [other flags...]
```

Given the same input and seed, the result is reproducible; only the basin /
landscape-topology outputs will differ from the pre-v1.7.1 run.
