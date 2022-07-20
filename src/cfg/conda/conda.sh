#!/bin/bash

# config conda in a new terminal window
conda config --set auto_activate_base false
#conda config --add channels conda-forge
conda config --add channels bioconda
conda config --add channels defaults

# note: conda installed packages are constrained to the conda environment, while pip3 installed packages might affect system environment
conda update --all -y
conda install -c anaconda numpy pandas -y
conda install -c bioconda snakemake kallisto bustools -y

#conda activate # activate base when needed
#conda activate snakemake # activate base when needed
# note: if conda stucks at solving environment
#conda config --remove channels conda-forge
#conda config --add channels conda-forge
#conda update conda
# uninstall anaconda
#rm -rf ~/anaconda3/
