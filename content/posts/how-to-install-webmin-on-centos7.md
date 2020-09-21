---
title: "How to Install Webmin on Centos7"
date: 2019-11-03T21:11:08-05:00
categories: ["server"]
---
{{< figure src="/images/2019/webmin-login.png" caption="Webmin Login Screen" >}}
First off, access to the server via ssh with root. <br />
Install dependencies with this command:
```bash
yum -y install wget perl perl-Net-SSLeay openssl perl-IO-Tty perl-Encode-Detect perl-Data-Dumper unzip
```
Create a repo file like this:
```bash
nano /etc/yum.repos.d/webmin.repo
```
