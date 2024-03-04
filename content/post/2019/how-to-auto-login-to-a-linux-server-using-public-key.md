---
title: "How to Auto-Login to a Linux Server Using Public Key"
date: 2019-11-19T20:57:16-05:00
categories: ["network"]
---

This is like a *manual* of `ssh-copy-id` command.

Let’s say we are logging in to a server named B from a local machine named A.

First off, generate authentication key pair without passphrase on the local machine A:

```bash
ssh-keygen -t rsa
```

Now you got a public key of your local machine, and the path is:

```bash
cd ~/.ssh
cat id_rsa.pub
```

Grab the public key to append it to the server’s file named **authorized_keys**.

If the file doesn’t exist, create one on the server like so:

```bash
cd ~
mkdir .ssh
touch authorized_keys
```

Congrats! Now you can login to the server B without any credentials from the local machine A.

Happy networking! 😎
