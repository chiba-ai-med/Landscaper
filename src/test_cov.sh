#!/usr/bin/env bash
set -euo pipefail

echo "== whoami/dirs =="
id || true
pwd || true
ls -la || true
ls -la data || true

echo "== landscaper --help =="
docker run --rm ghcr.io/chiba-ai-med/landscaper:main --help || true

echo "== run landscaper =="
docker run --rm \
  -u "$(id -u):$(id -g)" \
  -v "$PWD":/work \
  -w /work \
  ghcr.io/chiba-ai-med/landscaper:main \
  -i /work/data/testdata.tsv \
  -o /work/output_cov \
  -e /work/data/cov_data.tsv \
  --memgb=10 | tee run_landscaper.log

echo "== list outputs =="
ls -l output_cov || true
ls -l output_cov/logs || true

echo "== tail logs =="
# 生成されていれば中身を見る（無ければ true で続行）
for f in output_cov/logs/*; do
  echo "--- $f ---"; sed -n '1,200p' "$f" || true
done

echo "== run R tests =="
docker run --rm \
  -u "$(id -u):$(id -g)" \
  -v "$PWD":/work \
  -w /work \
  koki/landscaper_component:latest \
  Rscript /work/src/test_cov.R output_cov
