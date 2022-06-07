---
title: "How to Dockerize a Full Stack MEVN Application"
date: 2020-02-15T19:21:16-05:00
categories: ["docker"]
---
First things first. Let’s check the directory structure of the app.  
{{< figure src="/images/2020/mevn-app.jpg" caption="A Full Stack MEVN Application" >}}

Let’s take a look into the DB image first.
```dockerfile
FROM mongo:latest

WORKDIR /app
COPY . /app

ENV MONGO_INITDB_ROOT_USERNAME=root
ENV MONGO_INITDB_ROOT_PASSWORD=password

EXPOSE 27017
```
I thought importing dump data should be working if I used CMD or ENTRYPOINT.  
It didn’t work though. So I picked a solution using exec and shell script. It’s in the last part. 😉  
Now, let’s check the Express.js backend server image.
```dockerfile
FROM node:12
WORKDIR /app
COPY . /app
RUN npm install
CMD ["node", "index.js"]
```
Pretty simple, isn’t it? 😉  
Let’s move on to the FE part.
```dockerfile
FROM nginx:latest
WORKDIR /app
COPY . /app
RUN apt update -y \
    && apt install curl -y \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt install nodejs -y \
    && node --version \
    && npm install \
    && npm run build \
    && rm -rf /usr/share/nginx/html/* \
    && cp -r /app/dist/* /usr/share/nginx/html/ \
    && service nginx start
EXPOSE 80
```
You know what? Too much complicated? 😉 This is not a raw development server, but a production server.  
But this is not the best way to deploy Vue apps, better solution is to separate the building stage using node docker image, and also need some hack in nginx configuration in case you use [history mode](https://cli.vuejs.org/guide/deployment.html#docker-nginx).  
Finally, let's check our docker-compose.yml file.
```yaml
version: "3"
services:
  db:
    container_name: mongo-container
    build: ./backend/db
    environment:
      MONGO_INITDB_DATABASE: sageglass
    ports:
      - "27017:27017"
    volumes:
      - db-data:/data/db
    restart: always
  frontend:
    container_name: vuejs-app
    build: ./frontend
    ports:
      - "80:80"
    restart: always
  backend:
    container_name: express-app
    build: ./backend
    depends_on:
      - db
    ports:
      - "9000:9000"
    restart: always
volumes:
  db-data:
```
Now, here comes the shell script named “db-init.sh” for importing db dump.
```bash
mongoimport --authenticationDatabase admin --username root --password password --host localhost --db sageglass --collection location --type json --file location.json \
&& mongoimport --authenticationDatabase admin --username root --password password --host localhost --db sageglass --collection config --type json --file config.json \
&& mongoimport --authenticationDatabase admin --username root --password password --host localhost --db sageglass --collection overlay --type json --file overlay.json \
&& mongoimport --authenticationDatabase admin --username root --password password --host localhost --db sageglass --collection map --type json --file map.json --jsonArray \
&& mongoimport --authenticationDatabase admin --username root --password password --host localhost --db sageglass --collection connected --type json --file connected.json --jsonArray \
&& mongoimport --authenticationDatabase admin --username root --password password --host localhost --db sageglass --collection non-connected --type json --file non-connected.json --jsonArray \
&& mongoimport --authenticationDatabase admin --username root --password password --host localhost --db sageglass --collection health --type json --file health.json \
&& mongoimport --authenticationDatabase admin --username root --password password --host localhost --db sageglass --collection tints --type json --file tints.json --jsonArray \
&& mongoimport --authenticationDatabase admin --username root --password password --host localhost --db sageglass --collection upcoming --type json --file upcoming.json --jsonArray
```
Need to be careful to the last tag “–jsonArray”.  
When should it be there?  
Literally, it should be there when the data is json array, not an object.  
Alright, now let’s get the whole app up and running with these commands:
```bash
docker-compose up -d
docker exec -it mongo-container sh /app/db-init.sh
```
Awesome! We got the whole app containerized.  
The whole source code to review the real flow is [here](https://github.com/dockerlead/vue-googlemap).  
Happy dockerizing! 🙂
