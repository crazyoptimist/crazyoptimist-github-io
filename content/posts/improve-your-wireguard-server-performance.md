---
title: "Improve Your Wireguard Server's Performance"
date: 2021-07-13T02:28:56-05:00
categories: ["network"]
---
The default MTU(Maximum Transmission Unit) is 1420 in wireguard, while the most other devices use 1496 or 1500.  
Read [this](https://superuser.com/questions/1537638/wireguard-tunnel-slow-and-intermittent?newreg=4af74385cf164e0f8e1d156bae77ad03) for more info.  
TL;DR  
Stop the wireguard interface in use:
```
sudo wg-quick down wg0
sudo systemctl stop wg-quick@wg0
```
Edit the config file:
```
sudo vim /etc/wireguard/wg0.conf
```
Add these lines to server section like this:
```ini
MTU=1412
PostUp = iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
```
And start the stopped service:
```
systemctl start wg-quick@wg0
```
Sometimes network connection via IPv6 is compromising your connection and it degrades the performance, so remove all the IPv6 related rows from the server section(mostly generated ones).  
Hope this helps.  
Happy networking!  
