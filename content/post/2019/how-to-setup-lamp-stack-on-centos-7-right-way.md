---
title: "How to Setup LAMP Stack on Centos 7 - Right Way"
date: 2019-12-25T23:47:47-05:00
categories: ["devops"]
---

This post shows how to setup a standard LAMP stack on CentOS 7.

For the latest version of phpMyAdmin:

```bash
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*
yum -y install epel-release
```

For MariaDB:

```bash
yum -y install mariadb-server mariadb
systemctl enable --now mariadb
mysql_secure_installation
```

For Apache:

```bash
yum -y install httpd
systemctl enable --now httpd
```

For PHP:

```bash
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install yum-utils
yum update -y
yum-config-manager --enable remi-php73
yum -y install php php-opcache
systemctl restart httpd
```

For making PHP work with MySQL:

```bash
yum -y install php-mysqlnd php-pdo
yum -y install php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-soap curl curl-devel
systemctl restart httpd
```

For phpMyAdmin:

```bash
yum -y install phpMyAdmin
vim /etc/httpd/conf.d/phpMyAdmin.conf
```

For remote access to DB:

```bash
# ... snip ...

Alias /phpMyAdmin /usr/share/phpMyAdmin
Alias /phpmyadmin /usr/share/phpMyAdmin

<Directory /usr/share/phpMyAdmin/>
  AddDefaultCharset UTF-8

  <IfModule mod_authz_core.c>
    # Apache 2.4
    # <RequireAny>
    # Require ip 127.0.0.1
    # Require ip ::1
    # </RequireAny>
    Require all granted
  </IfModule>

  <IfModule !mod_authz_core.c>
    # Apache 2.2
    Order Deny,Allow
    Deny from All
    Allow from 127.0.0.1
    Allow from ::1
  </IfModule>
</Directory>

<Directory /usr/share/phpMyAdmin/>
  Options none
  AllowOverride Limit
  Require all granted
</Directory>

# ... snip ...
```

Finally, you did it!

Happy coding! 🙂
