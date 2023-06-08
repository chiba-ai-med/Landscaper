#!/bin/bash

# Perform landscaper
docker run --rm -v $(pwd):/work ghcr.io/chiba-ai-med/landscaper:main \
-i /work/data/testdata.tsv -o /work/output \
--memgb=10

# Test
docker run --rm --entrypoint "bash" -v $(pwd):/work ghcr.io/chiba-ai-med/landscaper:main Rscript src/test.R
