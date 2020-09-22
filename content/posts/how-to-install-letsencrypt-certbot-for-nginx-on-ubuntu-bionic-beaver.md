---
title: "How to Install Letsencrypt Certbot for Nginx on Ubuntu Bionic Beaver"
date: 2019-12-20T22:17:28-05:00
categories: ["devops"]
---
Simply follow this script:
```bash
apt update -y
apt install software-properties-common -y
add-apt-repository universe -y
add-apt-repository ppa:certbot/certbot -y
apt update -y
install certbot python-certbot-nginx -y
certbot --nginx
```
Your server should now be all set to relay on https. 🙂  
As for Apache, you could refer to [this article](https://certbot.eff.org/lets-encrypt/ubuntubionic-apache)  
Happy networking gents!
