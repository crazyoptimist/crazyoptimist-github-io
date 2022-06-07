---
title: "How to Install Vmware-Tools on Manjaro - an Awesome Distro of Arch Linux"
date: 2020-04-23T01:50:51-05:00
categories: ["linux"]
---
As you may know, the package manager of Arch Linux is "pacman".
```bash
sudo pacman -Syu                #Update and upgrade system packages
sudo pacman -S package_name     #Install a new package
sudo pacman -R package_name     #Remove a package
sudo pacman -Rn package_name    #Remove along with backup-ed config files
sudo pacman -Rsu package_name   #Remove along with dependencies
```
If you do not have wget on your machine, you can install like so:  
```bash
sudo pacman -S wget
```
Then follow the steps below:
```bash
wget http://www.as2.com/linux/tools/vmtools-4-arch-and-co.tar.bz2
tar -xjf vmtools-4-arch-and-co.tar.bz2
sudo bash vmtools-4-arch-and-co.sh
```
Now you may have a vmware-tools installed on your machine. The left thing is to daemonize your vmware-tools.  
Let's make a service file first.
```bash
sudo vim /etc/systemd/system/vmwaretools.service
```
```ini
[Unit]
Description=VMWare Tools daemon

[Service]
ExecStart=/etc/init.d/vmware-tools start
ExecStop=/etc/init.d/vmware-tools stop
PIDFile=/var/lock/subsys/vmware-tools
TimeoutSec=0
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```
Well then, you know, enable and start your awesome service!
```bash
sudo systemctl enable --now vmwaretools
```
Your machine is all set now, you evil archer! :XD  
Thanks for reading!
