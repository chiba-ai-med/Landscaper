# Guideline for M1/M2 Mac users

This README is for M1/M2 Mac users.

In our environment, `Singularity` did not work properly on M1/M2 Mac (2023/1/6).

Therefore, for M1/M2 Mac user, the required tools for `TensorLyCV` are not available via the Docker container image file for now.

Instead, all required tools must be installed manually.

Here are the steps we followed on an M1 Mac to install the tools.

Note that this README is not exhaustive enough to solve all possible problems.

## Installation of all pre-requisites

First, we downloaded a shell script to install Mambaforge providing the minimum installer of `mamba` from the Miniforge website.
[https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-MacOSX-arm64.sh](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-MacOSX-arm64.sh)

Then we performed the shell script as follows:

```bash
bash Mambaforge-MacOSX-arm64.sh
```

After rebooting the shell, we confirmed that the `mamba` command did work as follows:

```
exec $SHELL -l
mamba --version
```

Next, we created a `conda` environment containing the required tools in `Landscaper` as follows:

```bash
mamba create -c conda-forge -c bioconda -c anaconda -n landscaper snakemake wget tensorly seaborn matplotlib -y
```

After activating the conda environment, we confirmed that the `snakemake` command did work as follows:

```bash
mamba activate landscaper
snakemake --version
```

## Download this GitHub repository

First, download this GitHub repository and change the working directory.

```bash
git clone https://github.com/kokitsuyuzaki/Landscaper.git
cd Landscaper
```

## Example with local machine

Next, perform `Landscaper` by the `snakemake` command as follows.

**Note that `--use-singularity` option does not work on M1/M2 Mac.**

```bash
snakemake -j 4 --config input=data/testdata.tsv outdir=output \
--resources mem_gb=10
```

The meanings of all the arguments are below.

- `-j`: Snakemake option to set [the number of cores](https://snakemake.readthedocs.io/en/stable/executing/cli.html#useful-command-line-arguments) (e.g. 10, mandatory)
- `--config`: Snakemake option to set [the configuration](https://snakemake.readthedocs.io/en/stable/snakefiles/configuration.html) (mandatory)
- `input`: Input file (e.g., vaccine_tensor.npy, mandatory)
- `outdir`: Output directory (e.g., output, mandatory)
- `--resources`: Snakemake option to control [resources](https://snakemake.readthedocs.io/en/stable/snakefiles/rules.html#resources) (optional)
- `mem_gb`: Memory usage (GB, e.g. 10, optional)

## Example with a local machine with Docker

If the `docker` command is available, the following command can be performed without installing any tools.

**Note that `--platform linux/amd64` option is required on M1/M2 Mac.**

```bash
docker run --platform Linux/amd64 \
--rm -v $(pwd):/work ghcr.io/chiba-ai-med/landscaper:main \
-i /work/data/testdata.tsv -o /work/output \
--cores=4 --memgb=10
```

# Authors
- Koki Tsuyuzaki
- Tetsuo Ishikawa
- Eiryo Kawakami
