#!/usr/bin/env bash

# purge miniconda3 and all conda environments
[ -d ~/.conda/ ] && rm -rf ~/.conda/
[ -d ~/.cache/conda/ ] && rm -rf ~/.cache/conda/
[ -d ~/.cache/conda-anaconda-tos/ ] && rm -rf ~/.cache/conda-anaconda-tos/
[ -d ~/miniconda3/ ] && rm -rf ~/miniconda3/
[ -f ~/.condarc ] && rm -f ~/.condarc
if [[ -f ~/.bashrc ]]; then
  start0=$(( $(grep -wn "# >>> conda initialize >>>" ~/.bashrc | head -n 1 | cut -d: -f1) - 1 ))
  end0=$(( $(grep -wn "# <<< conda initialize <<<" ~/.bashrc | tail -n 1 | cut -d: -f1) + 1 ))
  if [[ "$start0" -gt 0 && "$end0" -gt 0 ]]; then sed -i "${start0},${end0}d" ~/.bashrc; fi
  if grep -q 'export PATH="$HOME/miniconda3/bin:$PATH"' ~/.bashrc ; then sed -i '/export PATH=/d' ~/.bashrc; fi
fi
if [[ -f ~/.zshrc ]]; then
  start0=$(( $(grep -wn "# >>> conda initialize >>>" ~/.zshrc | head -n 1 | cut -d: -f1) - 1 ))
  end0=$(( $(grep -wn "# <<< conda initialize <<<" ~/.zshrc | tail -n 1 | cut -d: -f1) + 1 ))
  if [[ "$start0" -gt 0 && "$end0" -gt 0 ]]; then sed -i "${start0},${end0}d" ~/.zshrc; fi
  if grep -q 'export PATH="$HOME/miniconda3/bin:$PATH"' ~/.zshrc ; then sed -i '/export PATH=/d' ~/.zshrc; fi
fi
hash -r
