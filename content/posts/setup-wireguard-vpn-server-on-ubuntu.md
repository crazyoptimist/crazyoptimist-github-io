---
title: "Setup Wireguard VPN Server on Ubuntu"
date: 2021-02-04T13:49:08-05:00
categories: ["network"]
---
This tutorial is going to show you how to set up your own WireGuard VPN server on Ubuntu.  
WireGuard is made specifically for the Linux kernel. It runs inside the Linux kernel and allows you to create fast, modern, and secure VPN tunnel.  
TL;DR  

## Prerequisites

This tutorial assumes that the VPN server and VPN client are both going to be running on Ubuntu 20.04 operating system.  

## Setting Up the WireGuard Server

Install Wireguard from the default Ubuntu repository:

```bash
sudo apt update
sudo apt install wireguard
```

You should got the two cli `wg` and `wg-quick` now.  
Generate a key pair for your server:

```bash
wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey
cat /etc/wireguard/privatekey
cat /etc/wireguard/publickey
```

Keep the server key pair in your clipboard or somewhere temporary place.  
Now, edit the wireguard server configuration file.  
Check the name of your public network interface first:

```bash
ip -o -4 route show to default | awk '{print $5}'
```

Then create wireguard configuration file:

```bash
sudo vim /etc/wireguard/wg0.conf
```

Add this content:

```ini
[Interface]
Address = 10.0.0.1/24
SaveConfig = true
ListenPort = 51820
PrivateKey = SERVER_PRIVATE_KEY
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
```

* Address - A comma-separated list of v4 or v6 IP addresses for the wg0 interface. Use IPs from a range that is reserved for private networks (10.0.0.0/8, 172.16.0.0/12 or 192.168.0.0/16).

* SaveConfig - When set to true, the current state of the interface is saved to the configuration file when shutdown.

* PostUp - Command or script that is executed before bringing the interface up. In above configuration, we’re using iptables to enable masquerading. This allows traffic to leave the server, giving the VPN clients access to the Internet.

* `eth0` - Name of your public network interface


Secure the configuration file and private key file like so:

```bash
sudo chmod 600 /etc/wireguard/{privatekey,wg0.conf}
```

Launch the vpn network interface you just configured:

```bash
sudo wg-quick up wg0
sudo systemctl enable wg-quick@wg0
# `wg0` is just name of the config file you've created above.
```

## Configure Server Networking and Firewall

IP forwarding must be enabled for NAT to work. Do the following:

```bash
sudo vim /etc/sysctl.conf
```

Uncomment or add this line:

```ini
net.ipv4.ip_forward=1
```

Apply the change:

```bash
sudo sysctl -p
```

Optionally, if ufw is active on your server, do this:

```bash
sudo ufw allow 51820/udp
```

## Client Setup

Installation is all the same, and so the key pair generation is:

```bash
wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey
```

Create Wireguard client configuration:

```bash
sudo vim /etc/wireguard/wg0.conf
```

```ini
[Interface]
PrivateKey = CLIENT_PRIVATE_KEY
Address = 10.0.0.2/24


[Peer]
PublicKey = SERVER_PUBLIC_KEY
Endpoint = SERVER_IP_ADDRESS:51820
AllowedIPs = 0.0.0.0/0
```

* Address - A comma-separated list of v4 or v6 IP addresses for the wg0 interface. Your client machine will have this private ip.

* PrivateKey - To see the contents of the file on the client machine run: sudo cat /etc/wireguard/privatekey

* AllowedIPs - A comma-separated list of v4 or v6 IP addresses from which incoming traffic for the peer is allowed and to which outgoing traffic for this peer is directed. We’re using 0.0.0.0/0 because we are routing the traffic and want the server peer to send packets with any source IP.

## Add the Client Peer to the Server Peer

On the server, use this command:

```bash
sudo wg set wg0 peer CLIENT_PUBLIC_KEY allowed-ips 10.0.0.2
```

You should be able to launch your client now:

```bash
sudo wg-quick up wg0
sudo wg show wg0
```

If you want to remove a peer from your server, this will work:

```bash
sudo wg set wg0 peer CLIENT_PUBLIC_KEY remove
```

That's it.  
Happy networking! 😎  
