---
title: "How to Install the Latest Version of Nginx on Ubuntu Bionic"
date: 2020-04-07T00:52:18-05:00
categories: ["devops"]
---
Nginx.org maintains a repository for Ubuntu. We can use this repository to install the latest version of Nginx.  
First off, let's create a repository source file for Nginx with the following command.  
```bash
vim /etc/apt/sources.list.d/nginx.list
```
Paste in the following two lines to the file:
```
deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu/ bionic nginx
deb-src http://nginx.org/packages/mainline/ubuntu/ bionic nginx
```
In order to verify the integrity of packages downloaded from this repository, we need to import Nginx public key using the commands below.  
```bash
wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
```
You should see 'OK' so that we can move on.  
Run the following command to update the repository info, remove the former version, finally install the latest version of nginx.
```bash
apt update
apt remove nginx nginx-common nginx-full nginx-core
apt install nginx
systemctl status nginx
```
Beautiful! Right? ;)  
On CentOS 8:  
```bash
dnf -y upgrade
dnf -y install https://nginx.org/packages/rhel/8/x86_64/RPMS/nginx-1.18.0-1.el8.ngx.x86_64.rpm
systemctl enable --now nginx
```
Happy coding! 😎
