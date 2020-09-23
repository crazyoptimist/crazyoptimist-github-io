---
title: "How to Install Golang on Manjaro"
date: 2020-05-22T01:59:46-05:00
categories: ["golang"]
---
Manjaro is an attractive distro based off Arch.  
Let's get golang development environment on your Manjaro machine!  
You can just update the whole system packages and then simply install golang stable version provided by the Arch repository, not sure what it's called really.  
```bash
pacman -Syu
pacman -S go
go version
```
Now you have a golang engine on your machine, let's make a development environment like so:  
```bash
cd ~
mkdir go && cd go && mkdir src && cd src && mkdir github.com && cd github.com && mkdir github_username && cd github_username && pwd
```
Then you will see an output similar to this:  
```bash
/home/netfan/go/src/github.com/crazyoptimist
```
Great, we are almost there, now google for the best golang extension for vim and configure your vim, then we are all set to go!  
FYI, working directory inside the docker official image of golang is `/go/src/app`.  
Happy coding Gophers! 😍


