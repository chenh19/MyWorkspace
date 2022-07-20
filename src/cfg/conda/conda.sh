#!/bin/bash

# config conda in a new terminal window
conda update conda && conda update anaconda -y && conda update --all -y
conda config --add channels conda-forge
conda config --add channels bioconda
conda config --add channels defaults

# note: conda installed packages are constrained to the conda environment, while pip3 installed packages might affect system environment
conda install -c anaconda numpy pandas -y
#conda install kallisto -y
conda install -c conda-forge mamba
mamba create -c conda-forge -c bioconda -n snakemake snakemake

# disable auto activate base in terminal
conda config --set auto_activate_base false
#conda activate # activate base when needed
#conda activate snakemake # activate base when needed

# note: if conda stucks at solving environment
#conda config --remove channels conda-forge
#conda config --add channels conda-forge
#conda update conda

# uninstall anaconda
#rm -rf ~/anaconda3/
