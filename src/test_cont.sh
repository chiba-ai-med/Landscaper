# Perform landscaper
docker run --rm -v $(pwd):/work ghcr.io/chiba-ai-med/landscaper:main \
-i /work/data/testdata_continuous.tsv -o /work/output_cont --memgb=10

# Test Outputs
docker run --rm -v $(pwd):/work koki/landscaper_component:latest Rscript /work/src/test_cont.R output_cont
