---
title: "How to Build a CI/CD Pipeline on CircleCI"
date: 2020-03-11T23:49:20-05:00
categories: ["devops"]
---
Once you got your account on CircleCI and setup your project linked to your git repository, you will have to have a directory named “.circleci” inside the root of your project repo.  
Create a file named “config.yml” in there.  
Grab the sample script given by CircleCI platform according to your project type.  
**The first step is to get the building workflow success.**  
**The next step is to get the deployment workflow success.**  
Key point is writing a beautiful deploy command.  
Once it’s working basically, review your deployment checking if any issues exists.  
For example, you need to lock the master branch, which is called “repository protection”.  
In case you used docker, consider using this command for avoiding dummy images and containers ruin your storage every time you deploy(you may meet "no enough storage" error otherwise).  
```bash
docker-compose down
docker system prune -a -f
```
If you used SSH to deploy, check your repository on the server.
```bash
cd .git
vim config
#find this block:
[remote "origin"]
	url = https://github.com/username/blabla.git
	fetch = +refs/heads/*:refs/remotes/origin/*
```
Put your git credential(oh, god, it's dangerous!) like this:
```bash
  url = https://username:pass@github.com/username/blabla.git
```
Note that more elegant methods exist for this (SSH and non-SSH) regarding security concerns.  
Thanks for reading anyhow!  
Feel free to [ask me](mailto:crazyoptimist@mail.com) in you need further help.  
Happy coding!
