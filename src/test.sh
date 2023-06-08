#!/bin/bash

# Perform landscaper
docker run --rm -v $(pwd):/work ghcr.io/chiba-ai-med/landscaper:main \
-i /work/data/testdata.tsv -o /work/output \
--memgb=10

# Test Outputs
docker run --rm -v $(pwd):/work koki/landscaper_component:latest Rscript /work/src/test.R
