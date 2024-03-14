---
title: "How to Deploy Your Nodejs App on Centos 7"
date: 2019-12-20T21:35:46-05:00
categories: ["devops"]
---

PM2 is a process manager for nodejs apps. It daemonizes apps built with nodejs, which means run-as-service.

Let’s install PM2 using npm.

```bash
npm install -g pm2@latest
```

Now you can start your app using pm2 like so:

```bash
pm2 start app.js
```

Next, register the app as a startup process.

```bash
pm2 startup systemd
pm2 save
```

You can check the currently running apps like so:

```bash
pm2 list
```

Remember your app name or id so that you can use it to restart or stop the service.

```bash
pm2 restart
```

Simply entering `pm2` command in your terminal will show you the pm2 help.

Happy coding! 🙂
