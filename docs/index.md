## Fresh Install and Configuration of My Workspace

### [1/5] Create a bootable USB drive
- Download [**balenaEtcher**](https://www.balena.io/etcher/)  
- Download [**Kubuntu**](https://kubuntu.org/getkubuntu/)  
- Flash a USB drive with the Kubuntu iso image:  
![](./images/0.png)

### [2/5] Boot into the USB drive
- Press ```F12``` when the computer is booting up  
- Select the corresponding UEFI boot option (e.g., USB HDD: SanDisk) and hit ```Enter```  

### [3/5] Install Kubuntu

- Once log in to Kubuntu installer, select **Install Kubuntu**":  
![](./images/1.png)

- **Continue** with default keyboard setting:  
![](./images/2.png)

- **Continue** without connecting to internet:  
![](./images/3.png)

- Select **Normal installation** and check **Install third-party software for graphics and Wi-Fi hardware and additional media formats** option, then **Continue**:   
![](./images/4.png)

- Select **Guided - use entire disk** and **Install Now**:  
![](./images/5.png)

- **Continue** to confirm partition formatting:  
![](./images/6.png)

- Set **Region** and **Time Zone**, then **Continue**:  
![](./images/7.png)

- Set user account, then **Continue**:  
![](./images/8.png)

- Installation might take some time:  
![](./images/9.png)

- Once finished, it will prompt a restart:  
![](./images/10.png)

### [4/5] Reboot the system
- Once log out, it will prompt "**Please remove the installation meduim, then press ENTER**", simply unplug the USB drive and press ```Enter```  

### [5/5] Configuration
Simply copy the below command and run in [**Konsole**](https://konsole.kde.org/) (terminal): 
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/chenh19/MyWorkspace/main/setup.sh)" 
```
- 
![](./images/11.png)

#### Note:
- It will ask a few questions in terms of **configuration preferences**. If you didn't notice immediately, it will simply wait for your choice.
- It will automatically reboot a few times during the process, please **log in** and it will automatically continue. When all configuration is finished, it will remove cache and reboot.
