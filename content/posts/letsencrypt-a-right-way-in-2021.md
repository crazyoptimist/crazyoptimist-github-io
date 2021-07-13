---
title: "Let's Encrypt - The Right Way in 2021
date: 2020-06-11T02:07:02-05:00
categories: ["devops"]
---
#### Install Certbot
Install [snapd](https://snapcraft.io/docs/installing-snapd).  
Remove old version of certbot:
```
sudo apt-get remove certbot
# or
sudo dnf remove certbot
```
Install certbot:
```
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```
Run it!
```
sudo certbot --nginx
```

#### Caution!
In case you have an IP access blocking config in nginx, you need to disable it, temporarily at least.  
For example, imagine you have this nginx block for IP access blocking:
```ini
server {

  listen 80 default_server;
  return 444;

}
```
Then disable it like so:  
```bash
mv ip-guard.conf ip-guard.conf.bak
nginx -s reload
```
Yay, your certbot should be working for sure! 😎  
Happy securing!
