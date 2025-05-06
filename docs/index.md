## Fresh Install and Configuration of Debian (KDE) for Work

### [1/4] Create a bootable USB drive
- Download [**balenaEtcher**](https://www.balena.io/etcher/)  
- Download [**Debian (KDE)**](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/)  
  - Flash a USB drive with the Debian (KDE) iso image:  
![](./images/0.png)

### [2/4] Boot into the USB drive
- Press ```F12``` when the computer is booting up  
- Select the corresponding UEFI boot option (e.g., USB HDD: Kingston) and press ```Enter```  

### [3/4] Install Debian (KDE)

- Once it logs in to Debian live session, open **"Install Debian"**:  
![](./images/1.png)

- Set language, then **"Next"**:  
![](./images/2.png)

- Set region and zone, then **"Next"**:  
![](./images/3.png)

- Set default keyboard, then **"Next"**:   
![](./images/4.png)

- Select **"Erase disk"**, then **"Next"** (if you plan to install multiple OS on a single physical drive, you might select **"Manual partitioning"**):  
![](./images/5.png)

- Set user account, then **"Next"**:  
![](./images/6.png)

- **"Install"**:  
![](./images/7.png)

- Installation might take some time (if it goes to sleep, the username/password for the live session is **"user/live"**):  
![](./images/8.png)

- Once finished, it will prompt a restart:  
![](./images/9.png)

### [4/4] Configuration
- Connect to internet
- Copy the below command, paste in [**Konsole**](https://konsole.kde.org/) (terminal) and press ```Enter```:  
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/chenh19/MyWorkspace/main/setup.sh)"
```
- Enter user password and press ```Enter``` to run:  
![](./images/10.png)

#### Note:
- If the text is too small in the Konsole (Terminal) before scaling configuration, you may press ```Ctrl``` + ```+``` to **make the text larger** (this temporary setting will not be saved).
- It will ask a few questions in terms of **configuration preferences**. If you didn't notice immediately, it will simply pause and wait for your input.
