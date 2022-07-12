# MyWorkspace
*Current version: v0.3.0 (under heavy development, **not** recommended for productive purposes until v1.0)*  

## Introduction
This is an automated configuration tool for freshly installed [**Kubuntu**](https://kubuntu.org/), which is my wife's least hated linux distro.  
  
This tool will install and configure:
- [WeChat](https://www.wechat.com/)
- [EuDic](https://www.eudic.net/)
- [SnapGene](https://www.snapgene.com/)
- [IGV](https://software.broadinstitute.org/software/igv/)
- [PyMOL](https://pymol.org/)
- [JupyterLab](https://github.com/jupyterlab/jupyterlab-desktop)
- [RStudio](https://www.rstudio.com/)
- [RKWard](https://rkward.kde.org/)
- [Krita](https://krita.org/)
- [Bottles](https://usebottles.com/)
- [Touchegg](https://github.com/JoseExposito/touchegg)
- [alt_rm](https://github.com/chenh19/alt_rm)
- [Human Resource Machine](https://tomorrowcorporation.com/humanresourcemachine)
- and a lot more

**To be checked/tested:**  

- [x] [kde-configuration-files](https://github.com/shalva97/kde-configuration-files): ```kwriteconfig5``` very helpful
- [ ] [singularity-deepin](https://github.com/brighill/singularity-deepin) for newer version of WeChat
- [ ] [thinkpad-tools](https://github.com/devksingh4/thinkpad-tools) (**Having trouble undervolting x1yoga7**)
- [ ] [arch wiki for thinkpad](https://wiki.archlinux.org/index.php?search=Lenovo+ThinkPad+X1&title=Special%3ASearch&fulltext=Search)
- [x] kde on [wayland](https://wayland.freedesktop.org/): still not stable and compatible enough, maybe wait for 24.04 LTS
- [ ] fcitx input for Chinese when renaming folders


## How to use
Simply connect to internet and execute the below command in [**Konsole**](https://konsole.kde.org/) (terminal): 
```
bash <(wget -qO- https://raw.githubusercontent.com/chenh19/MyWorkspace/main/setup.sh)
```
Or, there is also a simple [**tutorial**](https://chenh19.github.io/MyWorkspace/) for reference.
