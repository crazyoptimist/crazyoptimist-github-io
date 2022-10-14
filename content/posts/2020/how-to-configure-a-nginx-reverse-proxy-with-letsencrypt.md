---
title: "How to Configure a Nginx Reverse Proxy With Let's Encrypt"
date: 2020-03-11T00:02:26-05:00
categories: ["devops"]
---
Let’s say one of your micro services is running on http://localhost:3000  
If you already have a nginx service running on the server, create a server block like this:
```bash
vim /etc/nginx/sites-available/domain.com.conf
```
Grab this content to paste in:
```ini
server {

  server_name domain.com;

  root /var/www/html;
  index index.html;

  location / {
    proxy_pass http://localhost:3000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
  }

}
```
For more advanced(production ready) configuration, use below instead:
```ini
server {

  server_name domain.com;

  root /var/www/html;
  index index.html;

  location / {
    proxy_pass http://localhost:3000;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;

    if ($request_uri ~* ".(ico|css|js|gif|jpe?g|png)$") {
      expires 30d;
      access_log off;
      add_header Pragma public;
      add_header Cache-Control "public";
      break;
    }
  }

  client_max_body_size 50M;
  keepalive_timeout    65s;
  keepalive_requests   1000;
  sendfile             on;
  tcp_nopush           on;
  tcp_nodelay          on;
  error_log            off;
  access_log           off;

  gzip on;
  gzip_vary on;
  gzip_comp_level 4;
  gzip_min_length 256;
  gzip_proxied any;
  gzip_types
    text/plain
    text/css
    text/xml
    text/javascript
    application/json
    application/javascript
    application/x-javascript
    application/xml
    application/xml+rss
    application/vnd.ms-fontobject
    font/eot
    font/opentype
    font/otf
    application/font-woff
    application/font-otf
    application/font-ttf
    application/x-font-opentype
    application/x-font-truetype
    application/x-font-woff
    application/x-font-otf
    application/x-font-ttf
    image/svg+xml
    image/x-icon
    image/vnd.microsoft.icon;

}
```
Make a link of the config file:
```bash
sudo ln -s /etc/nginx/sites-available/domain.com.conf /etc/nginx/sites-enabled/
```
Or in nginx v14+, just create the .conf file inside the conf.d directory then you are good to go.
Check the validity of your config file with this command
```bash
sudo nginx -t
```
Now that it went fine, you will be able to see your public domain will be showing your landing page or something like that.  
It’s time to secure your service with Let’s Encrypt (Let's just assume that the server is running Ubuntu 18.04 Bionic for simplicity):  
```bash
apt-get update
apt-get install software-properties-common
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install certbot python-certbot-nginx
certbot --nginx
```
Now, you will have to configure a cron job for auto-renewing the received certificates.  
```bash
certbot renew --dry-run
crontab -e
```
Grab this code **followed by an empty line**  
```bash
0 0,12 * * * python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew

```
It seems you did an awesome job! 😉  
**A Bonus Tip:** Nginx Purging - Right Way
```bash
apt purge nginx nginx-common nginx-full
```
On CentOS 7/8, you need to configure SELinux as well like so:
```bash
setsebool -P httpd_can_network_connect on
```
Happy coding! 😎
