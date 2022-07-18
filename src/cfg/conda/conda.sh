#!/bin/bash
# This script installs conda packages in a new terminal window

# config conda in a new terminal window
conda update anaconda -y && conda update --all -y
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda install numpy -y
#conda install kallisto -y
conda config --set auto_activate_base false # disable auto activate base in terminal
#conda activate # activate base when needed
#rm -rf ~/anaconda3/ # uninstall anaconda
# note: conda installed packages are constrained to the conda environment, while pip3 installed packages might affect system environment
