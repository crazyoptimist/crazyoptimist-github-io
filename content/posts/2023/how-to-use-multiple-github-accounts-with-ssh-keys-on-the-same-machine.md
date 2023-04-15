---
title: "How to Use Multiple Github Accounts With SSH Keys on the Same Machine"
date: 2023-04-14T18:26:42-05:00
categories: ["devops"]
---

There might be a chance that you need to create and use a separate github(or bitbucket) account other than your personal one in your workplace. And Github(Bitbucket or Gitlab will do the same I believe) doesn't allow to share a ssh key between different accounts for authentication.

That's the case we are going to figure out below.

First of all, create a new ssh key pair on your machine.

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
# Note: If you are using a legacy system that doesn't support the Ed25519 algorithm, use:
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

Next, edit/create the ssh config file.

```bash
vim ~/.ssh/config
```

```ini
# Default github account: crazyoptimist
Host github.com
   HostName github.com
   IdentityFile ~/.ssh/id_rsa
   IdentitiesOnly yes

# Workplace github account: extremeoptimist
Host github-workplace   # <-- This is the hostname that you will actually add by `git remote add`
   HostName github.com
   IdentityFile ~/.ssh/id_ed25519
   IdentitiesOnly yes
```

Test the ssh authentication.

```bash
ssh -T git@github.com
ssh -T git@github-workplace
```

Now you should be able to clone repos in your workplace org.

```bash
git clone git@github-workplace:your-org/some-cool-project.git
```

You got an idea to do this in a better way? Then you got it!

Happy coding!
