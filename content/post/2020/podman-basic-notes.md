---
title: "Podman Basic Notes"
date: 2020-11-07T01:36:06-06:00
categories: ["devops"]
---

### Playing around with Podman

```bash
alias docker="sudo podman $1"
```

The above command works as of this time and podman makes namespaces for every users for every resources, i.e., images, containers and so on.

It means, `podman images` and `sudo podman images` will show different resources.😎

```bash
sudo podman pod create --name my-pod -p 8080:80
sudo podman run -d --restart=always --pod=my-pod --name my-nginx nginx
sudo podman run -d --restart=always --pod=my-pod --name my-curl curl
sudo podman generate kube my-pod > my-pod.yaml
sudo podman play kube ./my-pod.yaml
```

The generated file can not be used as raw. Below is an example of a manually edited version.

{{< gist dockerlead 6bb435b321bc73589db230c98cca0e4f >}}

# Install Podman on CentOS 8

```bash
sudo dnf -y update
sudo dnf -y module disable container-tools
sudo dnf -y install 'dnf-command(copr)'
sudo dnf -y copr enable rhcontainerbot/container-selinux
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/devel:kubic:libcontainers:stable.repo
sudo dnf -y install podman
```

Happy containerizing! 😎
