---
title: "How to Install Letsencrypt Certbot for Apache on Centos 7"
date: 2019-12-20T22:01:55-05:00
categories: ["devops"]
---
Simply follow this script below:
```bash
yum install epel-release -y
yum install certbot python-certbot-apache mod_ssl -y
certbot --apache
```
Create a cron job which renews certification once a week.
```bash
crontab -e
```
```cron
0 0,12 * * * python -C 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew
# keep this line blank, it's a magic
```
Your domain is all set to relay on https now!  
Happy networking gents! 🙂

