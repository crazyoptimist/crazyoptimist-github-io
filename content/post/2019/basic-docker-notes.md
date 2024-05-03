---
title: "Basic Docker Notes"
date: 2019-12-28T00:08:01-05:00
categories: ["docker"]
---

## Create and run a new container from an image

```bash
docker container run -it --rm ubuntu /bin/bash
```

- `-i` or `--interactive`:    Keep STDIN open even if not attached
- `-t` or `--tty`:            Allocate a pseudo-TTY
- `--rm`:                     Automatically remove the container when it exits
- `--name`:                   Assign a name to the container
- `-d` or `--detach`:         Run container in background and print container ID

Aliases: docker container run, docker run

## List containers

```bash
docker container ps -a
```

- `-a` or `--all`: Show all containers (default shows just running)

Aliases: docker container ls, docker container list, docker container ps, docker ps

## Start or stop a container

```bash
docker container stop container_name
```

## Remove containers

```bash
docker container rm -f $(docker container ps -aq)
```

- `-q` or `--quiet`: Only display container IDs

## Run a container as a daemon:

```bash
docker container run -d --name "test-nginx" -p 8080:80 -v $(pwd):/usr/share/nginx/html:ro nginx:latest
```

- `-p`: port mapping, `host_port:container_port`
- `-v`: volume mounting, `host_dir:container_dir`
- `$(pwd)`: current working dir

## Check the information of a resource(container or image or volume or network):

```bash
docker container inspect container_name
```

## Write a basic Dockerfile:

```bash
FROM        # Set a base image
RUN         # Execute a command in the container
ENV         # Set an environment variable
WORKDIR     # Set the working directory
VOLUME      # Create a mount point for a volume
CMD         # Set executable for the container
```

## Build an image from a Dockerfile

```bash
docker build -t image_name .
```

- `.`:                  Path to the context (`.` - current working directory)
- `-t` or `--tag`:      Name and optionally a tag (format: "name:tag")
- `-f` or `--file`:     Name of the Dockerfile (default: "context_path/Dockerfile")

Aliases: docker buildx build, docker buildx b

## Access the Docker daemon as a non-root user

```bash
groupadd docker
usermod -a -G docker $USER
```

## Remove build cache

```bash
docker buildx prune
```

## Rule of thumb

* 1 app = 1 container
* Processes should be running in the foreground
* Keep data in volumes, not in containers
* Do not use SSH, use `docker exec` instead
* Avoid manual configurations inside containers

Happy containerizing! 🙂
