# Perform landscaper
docker run --rm -v $(pwd):/work ghcr.io/chiba-ai-med/landscaper:main \
-i /work/data/testdata_01.tsv -o /work/output_01 --memgb=10

# Test Outputs
docker run --rm -v $(pwd):/work koki/landscaper_component:latest Rscript /work/src/test_01.R output_01
