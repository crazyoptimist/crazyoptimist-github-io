---
title: "Basic Docker Notes"
date: 2019-12-28T00:08:01-05:00
categories: ["devops", "docker"]
---
To run a container from an image:
```bash
docker container run -it --rm ubuntu /bin/bash
```
-t: terminal inside  
-i: (STDIN) grabbing  
–rm: remove container automatically when process exits  
–name: name the container or daemon  
-d: daemonize the container running  

To list all containers:
```bash
docker container ps -a
```
To start or stop container:
```bash
docker container stop container_name
```
To remove container(s):
```bash
docker container rm -f $(docker container ps -aq)
```
-q: print only container IDs

To run a container as a daemon:
```bash
docker container run -d --name "test-nginx" -p 8080:80 -v $(pwd):/usr/share/nginx/html:ro nginx:latest
```
-p: port mapping, local_port:container_port  
-v: volume mounting, host_dir:container_dir  
$(pwd): current working dir  

To check the information of image/container/volume/network:
```bash
docker container inspect container_name
```
To write a basic Dockerfile:
```bash
FROM        #Set base image
RUN         #Execute command in container
ENV         #Set environment variable
WORKDIR     #Set working directory
VOLUME      #Create a mount point for a volume
CMD         #Set executable for container
```
To build an image from Dockerfile:
```bash
docker build -t image_name .
```
.: means context is the current working directory.  
-t: sets a name for the image  

For accessing to the docker daemon as a non-root user
```bash
groupadd docker
usermod -a -G docker $USER
```

Rule of thumb  
* 1 app = 1 container
* Process should be running in the foreground
* Keep data in volumes, not in containers
* Do not use SSH, use `docker exec` instead
* Avoid manual configurations inside container

Happy dockerizing, Gents! 🙂
