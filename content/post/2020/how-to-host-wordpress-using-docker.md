---
title: "How to Host Wordpress Using Docker"
date: 2020-01-06T14:14:16-05:00
categories: ["devops"]
---

Let’s the docker compose file first.

```yaml
version: '3'

services:
  wp:
    image: wordpress:latest
    ports:
      - ${IP}:80:80
    volumes:
      - ./php.conf.ini:/usr/local/etc/php/conf.d/conf.ini
      - ./wordpress:/var/www/html
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_NAME: "${DB_NAME}"
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: "${DB_ROOT_PASSWORD}"
    depends_on:
      - db

  pma:
    image: phpmyadmin/phpmyadmin
    environment:
      PMA_HOST: db
      PMA_PORT: 3306
      MYSQL_ROOT_PASSWORD: "${DB_ROOT_PASSWORD}"
    ports:
      - ${IP}:8080:80
    links:
      - db:db

  db:
    image: mysql:latest
    ports:
      - ${IP}:3306:3306
    command: [
        '--default_authentication_plugin=mysql_native_password',
        '--character-set-server=utf8mb4',
        '--collation-server=utf8mb4_unicode_ci'
    ]
    volumes:
      - ./wp-data:/docker-entrypoint-initdb.d
      - db_data:/var/lib/mysql
    environment:
      MYSQL_DATABASE: "${DB_NAME}"
      MYSQL_ROOT_PASSWORD: "${DB_ROOT_PASSWORD}"

volumes:
  db_data:
```

Here comes a relavant php.conf.ini file:

```ini
file_uploads = On
memory_limit = 500M
upload_max_filesize = 30M
post_max_size = 30M
max_execution_time = 600
```

Environmental variables will be needed, right? Here comes the .env file:

```ini
IP=127.0.0.1
DB_ROOT_PASSWORD=password
DB_NAME=wordpress
```

You will have to export a SQL dump sometimes. (I don’t do that though 😉)

Here comes the export_dump.sh file:

```bash
#!/bin/bash
_now=$(date +"%m_%d_%Y")
_file="wp-data/data_$_now.sql"

# Export dump
EXPORT_COMMAND='exec mysqldump "$MYSQL_DATABASE" -uroot -p"$MYSQL_ROOT_PASSWORD"'
docker-compose exec db sh -c "$EXPORT_COMMAND" > $_file
sed -i 1,1d $_file
```

All thing left is to spin up everything.

```bash
docker-compose up -d
```

Everything is running already? You've done awesome!

Happy containerizing! 🙂
