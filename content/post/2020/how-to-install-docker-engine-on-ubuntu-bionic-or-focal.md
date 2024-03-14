---
title: "How to Install Docker Engine (Not a Legacy Version!) on Ubuntu Bionic or Focal"
date: 2020-06-11T02:43:23-05:00
categories: ["docker"]
---

In some cases, you may get stuck due to docker and docker compose version.

Let's follow up on docker official documentation:

```bash
apt remove docker docker-engine docker.io containerd runc    # purging the legacy version if exists
apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update && apt install docker-ce docker-ce-cli containerd.io
```

Very awesome! What about the docker-compose which is a pretty cool stuff?

```bash
curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose
chmod +x docker-compose
echo $PATH
mv docker-compose /usr/sbin/    # In case Bionic or Focal
```

You should be eager to run docker as a non-root user!

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
sudo reboot -h now
```

That's it for now.

Happy containerizing! 😎
