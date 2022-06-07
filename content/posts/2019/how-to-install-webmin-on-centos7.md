---
title: "How to Install Webmin on Centos7"
date: 2019-11-03T21:11:08-05:00
categories: ["network"]
---
{{< figure src="/images/2019/webmin-login.png" caption="Webmin Login Screen" >}}
First off, access to the server via ssh with root.\
Install dependencies with this command:
```bash
yum -y install wget perl perl-Net-SSLeay openssl perl-IO-Tty perl-Encode-Detect perl-Data-Dumper unzip
```
Create a repo file like this:
```bash
nano /etc/yum.repos.d/webmin.repo
```
```bash
[Webmin]
name=Webmin Distribution Neutral
#baseurl=http://download.webmin.com/download/yum
mirrorlist=http://download.webmin.com/download/yum/mirrorlist
enabled=1
```
Add the Webmin author’s PGP key so that your system will trust the new repository:
```bash
wget http://www.webmin.com/jcameron-key.asc
rpm --import jcameron-key.asc
```
Download latest version of Webmin:
```bash
wget http://www.webmin.com/download/rpm/webmin-current.rpm
```
Install Webmin:
```bash
rpm -Uvh webmin-current.rpm
```
If you installed firewall on the server, you should allow Webmin in the firewall. Otherwise, you are all set!\
Open your browser and hit your server hostname `http://your-hostname:10000`\
Assumed that you already know how to configure systemd service enable & start, as well as your firewall.\
Feel free to ask if you got any troubles. Thanks for reading! 😀
