# HTML
mkdir -p report
snakemake --report report/landscaper.html --config input=data/testdata.tsv outdir=output seed=123456 group="" colnames=""