---
title: "Deploy Your Web Apps in Just a Minute - Made With 💖 for Dockerists"
date: 2020-09-07T02:52:02-05:00
categories: ["devops"]
---
As a software engineer or a DevOps engineer, you may come up with boring tasks frequently, one of which is setting up a new cloud environment for deployment of your awesome web apps/micro services.  
Using the following script, you will lose the dull pain. Just grab the script and run it with bash, then you will get the complete environment with docker/docker-compose and nginx which are all on the latest stable version.  
***
Note: This is just for Ubuntu Bionic/Focal. Buzz me anytime in case you want to get the same one for any other distro, I'd love to help!
***
<br />
```bash
#!/bin/bash
# upgrades the system
sudo apt-get update && sudo apt-get upgrade -y

# install docker latest
sudo apt remove docker docker-engine docker.io containerd runc  # purging the legacy version if exists
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io -y
# install docker-compose latest
#curl -L "https://github.com/docker/compose/releases/download/1.27.0/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose
curl -s https://api.github.com/repos/docker/compose/releases/latest \
| grep -v ".sha256" \
| grep browser_download_url \
| grep "docker-compose-$(uname -s)-$(uname -m)" \
| cut -d '"' -f 4 \
| xargs curl -L -o docker-compose
chmod +x docker-compose
sudo mv docker-compose /usr/sbin/    # in case of Bionic or Focal
# add the current non-root user to docker group
sudo groupadd -f docker
sudo usermod -aG docker $USER
sudo docker -v
sudo docker-compose -v

# install nginx latest
echo "
deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu/ bionic nginx
deb-src http://nginx.org/packages/mainline/ubuntu/ bionic nginx
" | sudo tee /etc/apt/sources.list.d/nginx.list
wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo apt update
sudo apt remove nginx nginx-common nginx-full nginx-core -y
sudo apt install nginx -y
rm *.sh *.key

echo -e "\e[32mPlease reboot your machine .. \e[0m"
```
You can also get the latest version of this script from [my gist](https://gist.github.com/CrazyOptimist/4654624f10da68f62b183c82fa717176#file-bionic-focal-web-setup-sh) anytime.  
Happy containerizing gents! 😎
