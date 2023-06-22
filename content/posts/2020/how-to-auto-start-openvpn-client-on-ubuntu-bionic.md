---
title: "How to Auto Start OpenVPN Client on Ubuntu Bionic"
date: 2020-01-06T00:28:23-05:00
categories: ["network"]
---
## Launch OpenVPN client as a daemon.

Here I assume you already have your own cert file - `filename.ovpn`. 🙂  
Modify its file extension to `conf` like so:  

```bash
mv filename.ovpn filename.conf 
```

Put your cert file inside `/etc/openvpn` directory like so:  

```bash
mv /path/to/filename.conf /etc/openvpn/
```

OpenVPN client service name would be `openvpn@filename`.  
Well, you might already know what to do to launch the service.  

```bash
sudo killall openvpn
sudo systemctl enable --now openvpn@filename
```

Reload the system daemons.  

```bash
sudo systemctl daemon-reload
```

That's it. 🙂  

## If you have `username` and `password` for the certfile, you need this step

Make a credential file like so:  

```bash
sudo touch /etc/openvpn/login.conf
```

Enter the following into the file.

```ini
your-username
your-password
```

Open your certfile to edit.

```bash
sudo vim /etc/openvpn/filename.conf
```

Add this line or edit it if it already exists.

```ini
auth-user-pass login.conf
```

## If you want to launch it manually each time, I recommend a shell script

Write a shell script with the following contents.

```bash
#!/bin/bash
sudo killall openvpn
sudo openvpn --daemon --config /path/to/filename.ovpn
```

You can now use the script file whenever you need it, even on startup.

Happy networking! 🙂
