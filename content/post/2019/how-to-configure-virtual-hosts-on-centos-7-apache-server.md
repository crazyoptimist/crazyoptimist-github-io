---
title: "How to Configure Virtual Hosts on Centos 7 Apache Server"
date: 2019-12-20T21:25:40-05:00
categories: ["network"]
---

Prerequisites for a vhost setup:

```bash
chown -R apache:apache /path_to/site_root
```

Set the permission of the project root directory to 755, you may already know. 🙂

Well, let’s create a vhost config file before you edit it.

```bash
cd /etc/httpd/conf.d
vim domain_name.conf
```

Now, grab this content to your config file:

```bash
<VirtualHost *:80>

  ServerName domain.com
  ServerAlias www.domain.com
  DocumentRoot /var/www/path_to/site_root

  <Directory /var/www/path_to/site_root>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
  </Directory>

  CustomLog /var/log/httpd/domain.com-access.log combined
  ErrorLog /var/log/httpd/domain.com-error.log
  # Possible values include: debug, info, notice, warn, error, crit, alert, emerg.
  LogLevel warn

</VirtualHost>
```

Finally, restart the apache server to apply your changes.

```bash
sudo systemctl restart httpd
```

If you get stuck when using a framework like Laravel or Magento, don’t forget to check selinux status.

Happy networking! 🙂
