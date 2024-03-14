---
title: "How to Update Apt Repository on Kali Linux"
date: 2020-02-18T22:55:51-05:00
categories: ["linux"]
---

Back up the current sources.list first.

```bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
```

Well, run this command then.

```bash
sudo echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" > /etc/apt/sources.list
```

Now you can run `apt update` command!

Happy networking! 😎
