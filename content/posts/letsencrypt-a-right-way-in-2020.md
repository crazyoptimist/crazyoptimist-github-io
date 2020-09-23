---
title: "Let's Encrypt - A Right Way in 2020"
date: 2020-06-11T02:07:02-05:00
categories: ["devops"]
---
Today I'm going to share a neat way to set up your let's encrypt (up-to-date way in 2020).  
First off, we will have to get the script using this command:  
```bash
wget https://dl.eff.org/certbot-auto
```
Then enable the script to run globally as we expect using this commands:  
```bash
chmod +x certbot-auto
mv certbot-auto certbot
echo $PATH
mv certbot /usr/sbin/    # In case of Ubuntu Bionic or Focal
certbot --version
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
