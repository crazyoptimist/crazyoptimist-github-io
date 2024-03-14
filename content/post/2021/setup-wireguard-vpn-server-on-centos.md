---
title: "Setup Wireguard VPN Server on CentOS"
date: 2021-02-04T12:10:35-05:00
categories: ["network"]
---

This tutorial is going to show you how to set up your own WireGuard VPN server on CentOS.

WireGuard is made specifically for the Linux kernel. It runs inside the Linux kernel and allows you to create fast, modern, and secure VPN tunnel.

TL;DR

## Prerequisites

This tutorial assumes that the VPN server and VPN client are both going to be running on CentOS 7/8 operating system.

## Step 1: Install WireGuard on CentOS Server and Desktop

Log into your CentOS server, then run the following commands to install WireGuard.

```bash
# CentOS 8
sudo dnf install elrepo-release epel-release -y
sudo dnf install kmod-wireguard wireguard-tools -y
# CentOS 7
sudo yum install epel-release https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
sudo yum install yum-plugin-elrepo
sudo yum install kmod-wireguard wireguard-tools -y
```

Then use the same commands to install WireGuard on your local CentOS computer (the VPN client).

## Step 2: Generate Public/Private Keypair

#### Server

```bash
sudo mkdir -p /etc/wireguard/
cd /etc/wireguard
wg genkey | sudo tee /etc/wireguard/server_private.key | wg pubkey | sudo tee /etc/wireguard/server_public.key
```

#### Client

```bash
sudo mkdir -p /etc/wireguard/
cd /etc/wireguard
wg genkey | sudo tee /etc/wireguard/client_private.key | wg pubkey | sudo tee /etc/wireguard/client_public.key
```

## Step 3: Create WireGuard Configuration File

#### Server

```bash
sudo vim /etc/wireguard/wg0.conf
```

Paste in this content:

```ini
[Interface]
Address = 10.10.10.1/24
SaveConfig = true
PrivateKey = private-key-of-your-server
ListenPort = 51820

[Peer]
PublicKey = public-key-of-your-client
AllowedIPs = 10.10.10.2/32
```

Secure the file like so:

```bash
sudo chmod 600 /etc/wireguard/ -R
```

#### Client

```bash
sudo vim /etc/wireguard/wg-client0.conf
```

Paste in this content:

```ini
[Interface]
Address = 10.10.10.2/24
DNS = 10.10.10.1
PrivateKey = private-key-of-your-client

[Peer]
PublicKey = public-key-of-your-server
AllowedIPs = 0.0.0.0/0 # to allow untunneled traffic, use `0.0.0.0/1, 128.0.0.0/1` instead
Endpoint = public-ip-of-your-server:51820
PersistentKeepalive = 25
```

Secure the config like so:

```bash
sudo chmod 600 /etc/wireguard/ -R
```

## Step 4: Enable IP Forwarding on the Server

```bash
sudo vim /etc/sysctl.conf
```

Add the following line at the end of this file.

```ini
net.ipv4.ip_forward = 1
```

```bash
sudo sysctl -p # The -p option will load sysctl settings from /etc/sysctl.conf file. This command will preserve our changes across system reboots.
```

## Step 5: Configure IP Masquerading on the Server

Run the following command to enable IP masquerading in the server firewall.

```bash
sudo firewall-cmd --zone=public --permanent --add-masquerade
sudo systemctl reload firewalld
```

This will hide your VPN network from the outside world. So the Internet can only see your VPN server’s IP, but can’t see your VPN client’s IP, just like your home router hides your private home network.

## Step 6: Install a DNS Resolver on the Server

Since we specify the VPN server as the DNS server for client, we need to run a DNS resolver on the VPN server. We can install the bind9 DNS server.

```bash
sudo dnf install bind
sudo systemctl start named
sudo systemctl enable named
systemctl status named
```

Edit the BIND main configuration file /etc/named.conf.

```bash
sudo vim /etc/named.conf
```

In the options clause, you can find the following two lines.

```ini
listen-on port 53 { 127.0.0.1; };
listen-on-v6 port 53 { ::1; };
```

This makes named listen on localhost only. If you want to allow clients in the same network to query domain names, then comment out these two lines. (add double slashes at the beginning of each line)

```ini
// listen-on port 53 { 127.0.0.1; };
// listen-on-v6 port 53 { ::1; };
```

Find the following line.

```ini
allow-query { localhost; };
```

Add the 10.10.10.0/24 network range so that VPN clients can send DNS queries. Note that you need to end each network range with a semicolon.

```ini
allow-query { localhost; 10.10.10.0/24; };
```

Save and close the file. Restart BIND9 for the changes to take effect.

```bash
sudo systemctl restart named
```

Then you need to run the following command to allow VPN clients to connect to port 53.

```bash
sudo firewall-cmd --zone=public --permanent --add-rich-rule='rule family="ipv4" source address="10.10.10.0/24" accept'
```

## Step 7: Open WireGuard Port in Firewall

Run the following command to open UDP port 51820 on the server.

```bash
sudo firewall-cmd --permanent --add-port=51820/udp
sudo systemctl reload firewalld
```

## Step 8: Start WireGuard

#### Server

Run the following command on the server to start WireGuard.

```bash
sudo wg-quick up /etc/wireguard/wg0.conf
```

To stop it, run

```bash
sudo wg-quick down /etc/wireguard/wg0.conf
```

You can also use systemd service to start WireGuard.

```bash
sudo systemctl start wg-quick@wg0.service
```

If the start failed, you should check the log to find out what’s wrong.

```bash
sudo journalctl -eu wg-quick@wg-client0.service
```

Enable auto-start at system boot time with the following command.

```bash
sudo systemctl enable wg-quick@wg0.service
```

Now WireGuard server is ready to accept client connections.

#### Client

Start WireGuard.

```bash
sudo systemctl start wg-quick@wg-client0.service
```

Enable auto-start at system boot time.

```bash
sudo systemctl enable wg-quick@wg-client0.service
```

By default, all traffic on the VPN client will be routed through the VPN server. Sometimes you may want to route only a specific type of traffic, based on the transport layer protocol and the destination port. This is known as policy routing.

Policy routing is configured on the client computer, and we need to stop the VPN connection first.

```bash
sudo systemctl stop wg-quick@wg-client0.service
```

Then edit the client configuration file.

```bash
sudo nano /etc/wireguard/wg-client0.conf
```

For example, if you add the following 3 lines in the [interface] section, then WireGuard will create a routing table named “1234” and add the ip rule into the routing table. In this example, traffic will be routed through VPN server only when TCP is used as the transport layer protocol and the destination port is 25, i.e, when the client computer sends emails.

```ini
Table = 1234
PostUp = ip rule add ipproto tcp dport 25 table 1234
PreDown = ip rule delete ipproto tcp dport 25 table 1234
```

Save and close the file. Then start WireGuard client again.

```bash
sudo systemctl start wg-quick@wg-client0.service
```

#### VPN Kill Switch

By default, your computer can access the Internet via the normal gateway when the VPN connection is disrupted. You may want to enable the kill switch feature, which prevents the flow of unencrypted packets through non-WireGuard interfaces.

Stop the WireGuard client process.

```bash
sudo systemctl stop wg-quick@wg-client0.service
```

Edit the client configuration file.

```bash
sudo nano /etc/wireguard/wg-client0.conf
```

Add the following two lines in the [interface] section.

```ini
PostUp = iptables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
PreDown = iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
```

Like this:

```ini
[Interface]
Address = 10.10.10.2/24
DNS = 10.10.10.1
PrivateKey = cOFA+x5UvHF+a3xJ6enLatG+DoE3I5PhMgKrMKkUyXI=
PostUp = iptables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
PreDown = iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT

[Peer]
PublicKey = RaoAdsIEIwgV9DHNSubxWVG+nZ1GP/c3OU6A/efBJ0I=
AllowedIPs = 0.0.0.0/0
Endpoint = 12.34.56.78:51820
PersistentKeepalive = 25
```

Save and close the file. Then start the WireGuard client.

```bash
sudo systemctl start wg-quick@wg-client0.service
```

If you want to remove a peer from your server, this will work:

```bash
sudo wg set wg0 peer CLIENT_PUBLIC_KEY remove
```

That's it. *The same content posted in many places on the internet.*

Happy networking! 😎
