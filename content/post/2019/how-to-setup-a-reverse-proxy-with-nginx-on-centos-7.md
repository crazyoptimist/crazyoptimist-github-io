---
title: "How to Setup a Reverse Proxy With Nginx on Centos 7"
date: 2019-12-20T21:50:44-05:00
categories: ["devops"]
---
First off, install nginx on the server machine.  
```bash
yum update
yum install epel-release
yum install nginx
```
Edit the nginx config file then.
```bash
cd /etc/nginx/nginx.conf
vim nginx.conf
```
Edit the file like this:
```bash
server_name domain.com;
```
If you are not going to use domain name, a public ip address would also work instead of domain.com 🙂  
Find location section in the file and replace it with:
```bash
location / {
  proxy_pass http://server_ip:8080;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection 'upgrade';
  proxy_set_header Host $host;
  proxy_cache_bypass $http_upgrade;
}
```
Boom! You did it!  
You can also add another app in the same nginx server block, for example, `location /app_name { … … }`, which means that server relays from the route `/app_name`, and another port, of course.  
Last but not least, don’t forget to check the server's selinux settings.
```bash
getsebool -a
setsebool -P configuration_name on
```
Happy networking gents. 🙂
