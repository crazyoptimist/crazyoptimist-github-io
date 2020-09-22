---
title: "How to Auto Start OpenVPN Client on Ubuntu Bionic"
date: 2020-01-06T00:28:23-05:00
categories: ["linux"]
---
Assuming you already have your cert-file-name.ovpn file. 🙂  
Note that client service name would be openvpn@cert-file-name.  
And then enable the service like so:
```bash
sudo killall openvpn
sudo systemctl enable --now openvpn@cert-file-name
```
Reload the daemons.
```bash
sudo systemctl daemon-reload
```
It seems all done. 🙂  
#### Here is another method using a shell script.
Write a shell script like this:
```bash
#!/bin/bash
sudo killall openvpn
sudo openvpn --daemon --config /path_to/cert-file-name.ovpn
```
You can now use the script file whenever you need it, even on startup.  
Happy networking, Gents!
