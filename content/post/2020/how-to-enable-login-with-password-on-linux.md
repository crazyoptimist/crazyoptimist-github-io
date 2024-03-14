---
title: "How to Enable Login with Password on Linux"
date: 2020-02-18T23:20:11-05:00
categories: ["network"]
---

Let’s update the Password Authentication parameter in the ssh service config file:

```bash
vim /etc/ssh/sshd_config
```

Wait, what? I can't even find the sshd service?

Install it then:

```bash
sudo apt update
sudo apt install openssh-server
```

In the `/etc/ssh/sshd_config` file, uncomment this line:

```bash
#PasswordAuthentication yes
```

Done.

Oops! Don’t forget to reboot! 🙂

Or just run:

```bash
sudo systemctl restart sshd
```

Happy networking!
