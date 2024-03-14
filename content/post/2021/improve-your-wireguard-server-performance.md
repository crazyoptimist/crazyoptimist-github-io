---
title: "Improve Your Wireguard Server's Performance"
date: 2021-07-13T02:28:56-05:00
categories: ["network"]
---

The default MTU(Maximum Transmission Unit) is 1420 in wireguard, while the most other devices use 1496 or 1500.

Read [here](https://superuser.com/questions/1537638/wireguard-tunnel-slow-and-intermittent?newreg=4af74385cf164e0f8e1d156bae77ad03) for more info.

TL;DR

Stop the wireguard interface in use:

```
sudo systemctl stop wg-quick@wg0
# or
sudo wg-quick down wg0
```

Edit the wireguard config file:

```
sudo vim /etc/wireguard/wg0.conf
```

Add `MTU=1400` to the `Interface` section like this:

```ini
[Interface]
Address = 10.10.10.1/24
SaveConfig = true
ListenPort = 51820
MTU = 1400
PrivateKey = xxxxxx
```

And start the stopped service:

```
systemctl start wg-quick@wg0
```

Add the same for the client config.

That's it.

Happy networking!
