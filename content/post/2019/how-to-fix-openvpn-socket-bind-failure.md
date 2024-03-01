---
title: "How to Fix OpenVPN Socket Bind Failure"
date: 2019-12-06T21:09:42-05:00
categories: ["network"]
---
I recently came up with this error on one of my OpenVPN servers.

>"OpenVPN - Socket bind failed on local address [AF_INET] IP:#portnum: Cannot assign requested address"  

Let me share how I did fix it.  
First off, check this openvpn’s default init script : openvpn@.service  
```bash
sudo grep After /usr/lib/systemd/system/openvpn\@.service
```
It will look like this: `After=network.target`  
Well, change it like this:
```bash
After=network-online.target
```
Reboot the server, if the connection is still not working after rebooting, change the selinux configuration.
```bash
cd /etc/selinux/
# youmayknowwhattodo
```
Reboot again, then it should be working.  
Enjoy networking! 🙂
