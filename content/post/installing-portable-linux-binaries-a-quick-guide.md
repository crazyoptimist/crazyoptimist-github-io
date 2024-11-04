---
title: "Installing Portable Linux Binaries: A Quick Guide"
date: 2024-11-04T02:36:42-05:00
categories: ["linux"]
---

## Introduction

I use [PeaZip](https://github.com/peazip/PeaZip) on my computers. It's a powerful cross-platform zip/unzip software.

I used to install it through `yay`, which re-downloads the entire source code and rebuilds it every time I update the OS. While staying up-to-date is crucial for security-sensitive applications like web browsers and cryptocurrency wallets (and plenty more), it's not always necessary for tools like PeaZip. Even if you forget to update PeaZip, you likely won't face security risks.

This post explores using portable Linux binaries for applications like PeaZip. Portable apps are self-contained and don't require build on your machine, saving time and system resources.

TL;DR: Let's jump in and learn how to use PeaZip as a portable application!

## Portable Binary Installation

Open the PeaZip Github release page and locate the binary file appropriate for your system architecture (e.g., peazip_portable-10.0.0.LINUX.GTK2.x86_64.tar.gz). Click to download it using your browser or use `wget` or `curl` in your terminal.

```bash
wget https://github.com/peazip/PeaZip/releases/download/10.0.0/peazip_portable-10.0.0.LINUX.GTK2.x86_64.tar.gz
```

Extract the downloaded archive.

Rename the extracted directory for easier access. For example, `peazip_portable`.

Move the directory to `/usr/local/`.

```bash
sudo mv peazip_portable /usr/local/
```

Create a symbolic linx to the executable.

```bash
sudo ln -s /usr/local/peazip_portable/peazip /usr/local/bin/peazip
```

Explanation of above command: `ln -s A B` means "Create a symbolic link at path B which points to path A".

And you're done. `/usr/local/bin` is one of the standard executable paths. You can also configure an automatic update with some hacks but I don't do it personally.

Happy zipping! :zipper_mouth_face:
