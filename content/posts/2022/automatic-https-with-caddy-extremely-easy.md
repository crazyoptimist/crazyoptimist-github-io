---
title: "Automatic Https With Caddy - Extremely Easy"
date: 2022-06-07T13:08:39-05:00
categories: ["devops"]
---

Today I had a chance to try [Caddy](https://caddyserver.com/) for dev purpose, and you guess what, it was extremely easy and funny. Only two steps and boom, you got a secured website almost instantly.  
Here are the steps I followed:  

#### Install Caddy on Ubuntu/Debian
Check their [documentation](https://caddyserver.com/docs/install) for another OS/installation method.  

```bash
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy
```

#### Edit `Caddyfile` and restart the service

```bash
sudo vim /etc/caddy/Caddyfile
```

```ini
dev-api.your-domain.com

reverse_proxy 127.0.0.1:8000
```

```bash
sudo systemctl restart caddy
# or
sudo caddy reload
```

That's it, you can now browse `https://dev-api.your-domain.com`.  
In my case, a REST API service was running on port 8000 and I configured Caddy as a reverse proxy.  
Configuring Caddy should be easy for other use cases as well, I'm pretty sure.  

If you were to configure multiple domains:

```ini
dev-api.domain-one.com {
  reverse_proxy 127.0.0.1:8000
}

dev-app.domain-two.com {
  reverse_proxy 127.0.0.1:3000
}
```

Happy coding!
