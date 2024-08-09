##################### covなし #####################
# beta=2
## カウント値
snakemake -j 4 --config input=output_seurat_beta2/U.tsv outdir=output_seurat_beta2 \
--resources mem_gb=10 --use-singularity

## 対数変換
snakemake -j 4 --config input=output_log_seurat_beta2/U.tsv outdir=output_log_seurat_beta2 \
--resources mem_gb=10 --use-singularity

# beta=1
## カウント値
snakemake -j 4 --config input=output_seurat_beta1/U.tsv outdir=output_seurat_beta1 \
--resources mem_gb=10 --use-singularity

## 対数変換
snakemake -j 4 --config input=output_log_seurat_beta1/U.tsv outdir=output_log_seurat_beta1 \
--resources mem_gb=10 --use-singularity

# beta=0
## カウント値
snakemake -j 4 --config input=output_seurat_beta0/U.tsv outdir=output_seurat_beta0 \
--resources mem_gb=10 --use-singularity

## 対数変換
snakemake -j 4 --config input=output_log_seurat_beta0/U.tsv outdir=output_log_seurat_beta0 \
--resources mem_gb=10 --use-singularity

##################### covあり #####################
# beta=2
## カウント値
snakemake -j 4 --config input=output_seurat_beta2/U.tsv outdir=output_seurat_beta2_cov \
covariate=time_dapt.tsv \
--resources mem_gb=10 --use-singularity

## 対数変換
snakemake -j 4 --config input=output_log_seurat_beta2/U.tsv outdir=output_log_seurat_beta2_cov \
covariate=time_dapt.tsv \
--resources mem_gb=10 --use-singularity

# beta=1
## カウント値
snakemake -j 4 --config input=output_seurat_beta1/U.tsv outdir=output_seurat_beta1_cov \
covariate=time_dapt.tsv \
--resources mem_gb=10 --use-singularity

## 対数変換
snakemake -j 4 --config input=output_log_seurat_beta1/U.tsv outdir=output_log_seurat_beta1_cov \
covariate=time_dapt.tsv \
--resources mem_gb=10 --use-singularity

# beta=0
## カウント値
snakemake -j 4 --config input=output_seurat_beta0/U.tsv outdir=output_seurat_beta0_cov \
covariate=time_dapt.tsv \
--resources mem_gb=10 --use-singularity

## 対数変換
snakemake -j 4 --config input=output_log_seurat_beta0/U.tsv outdir=output_log_seurat_beta0_cov \
covariate=time_dapt.tsv \
--resources mem_gb=10 --use-singularity

