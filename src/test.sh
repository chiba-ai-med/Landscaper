#!/bin/bash

# Perform landscaper
docker run --rm -v $(pwd):/work ghcr.io/chiba-ai-med/landscaper:main \
-i /work/data/testdata.tsv -o /work/output \
--memgb=10

Rscript src/test.R