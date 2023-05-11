# DAG graph
mkdir -p plot
snakemake --rulegraph --config input=data/testdata.tsv outdir=output | dot -Tpng > plot/dag.png
