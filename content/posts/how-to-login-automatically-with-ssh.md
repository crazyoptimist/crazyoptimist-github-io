---
title: "How to Login Automatically With SSH"
date: 2019-11-08T02:10:45-05:00
categories: ["devops"]
---
{{< figure src="/images/2019/auto-login-ssh.jpg" caption="Auto Login With SSH" >}}
Today I am going to share you how to login to a cloud server without using password.\
Let’s say there is a server and your local machine, assuming you can login to the server using some kind of credentials.\
First off, you should generate a new local public key on your local machine.\
Chdir to the current user’s root directory.\
```bash
cd
ssh-keygen
```
If you see a prompt message of existing file, just overwrite it, give yes to every prompt otherwise.\
You can copy the generated public key to the server by this only one command 🙂
```bash
ssh-copy-id username@hostname
```
Use your existing credentials for prompts.\
If you see a message telling you to login to the server again, you are done. Pretty simple saving much time. 😎
