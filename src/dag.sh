# DAG graph
mkdir -p plot
snakemake --rulegraph --config input=data/testdata.tsv outdir=output seed=123456 rownames="" colnames="" | dot -Tpng > plot/dag.png
