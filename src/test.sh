#!/bin/bash

# Perform landscaper
docker pull ghcr.io/chiba-ai-med/landscaper:main

# docker run --rm -v $(pwd):/work ghcr.io/kokitsuyuzaki/tensorlycv:main \
# -i /work/data/vaccine_tensor.npy -o /work/output \
# --cores=2 --rank_min=2 --rank_max=2 --trials=2 \
# --n_iter_max=2 --ratio=30 --memgb=100
