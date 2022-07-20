#!/bin/bash

# config conda in a new terminal window
conda update anaconda -y && conda update --all -y
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda install -c anaconda numpy pandas -y
#conda install kallisto -y
conda config --set auto_activate_base false # disable auto activate base in terminal
conda install -n base -c conda-forge mamba
mamba create -c conda-forge -c bioconda -n snakemake snakemake
#conda activate # activate base when needed
#conda activate snakemake # activate base when needed
#rm -rf ~/anaconda3/ # uninstall anaconda
# note: conda installed packages are constrained to the conda environment, while pip3 installed packages might affect system environment
