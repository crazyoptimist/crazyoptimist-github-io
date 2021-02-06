---
title: "How to Login Using PPK File With SSH"
date: 2019-11-19T20:36:34-05:00
categories: ["network"]
---
In some situations, you are given only a ppk file for access to a cloud server. You know, however, it's for [Putty](https://en.wikipedia.org/wiki/PuTTY) on windows, not for OpenSSH client which might be the most familiar to you.🤔  
I am gonna introduce a method to convert a ppk file into a pem file so that you can login to the linux server with ssh command which you might be used to.  
First off, install **putty-tools** on your machine.  
```bash
sudo apt-get install putty-tools
```
Then convert your \*.ppk file into a \*.pem file like so:
```bash
puttygen ppkfilename.ppk -O private-openssh -o pemfilename.pem
```
Pretty simple, isn’t it? 🙂  
Secure the pem file, it's important, as you may know.  
```bash
chmod 400 pemfilename.pem
```
Now you can login to the server with ssh command!
```bash
ssh -i pemfilename.pem user@server-ip
```
Thanks for reading!
