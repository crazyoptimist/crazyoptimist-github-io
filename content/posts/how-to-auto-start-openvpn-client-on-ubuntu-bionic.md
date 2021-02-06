---
title: "How to Auto Start OpenVPN Client on Ubuntu Bionic"
date: 2020-01-06T00:28:23-05:00
categories: ["network"]
---
## Make it as a daemon.

Assuming you already have your cert-file-name.ovpn file. 🙂  
OpenVPN client service name would be openvpn@cert-file-name.  
Put your cert file inside `/etc/openvpn` directory like so:

```bash
mv /path/to/cert-file-name.ovpn /etc/openvpn/
```

And then enable the service:

```bash
sudo killall openvpn
sudo systemctl enable --now openvpn@cert-file-name
```

Reload the daemons.

```bash
sudo systemctl daemon-reload
```

That's it. 🙂  

## When you have `username` and `password` for your certfile, need to do this.

Make a credential file like this:

```bash
touch login.conf
```

Put this into the file:

```ini
username
password
```

Open your certfile to edit:

```bash
vim cert-file-name.ovpn
```

Edit or add in this line:

```ini
auth-user-pass /path/to/login.conf
```

## Use a shell script.

Write a shell script like this:

```bash
#!/bin/bash
sudo killall openvpn
sudo openvpn --daemon --config /path/to/cert-file-name.ovpn
```

You can now use the script file whenever you need it, even on startup.  
Happy networking! 🙂
