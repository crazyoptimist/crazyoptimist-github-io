---
title: "How to Use Jenkins - A Basic Approach"
date: 2020-06-11T02:22:20-05:00
categories: ["devops"]
---

Deploy your Jenkins instance first.

{{< gist crazyoptimist e8836cee62dc52a05a94cbcbb6783a09 >}}

Let's go for  password login for deployment, noting that it's not the most secure way, but just for simplicity. ;)

### CHANGE SSH PORT - FOR DESTINATION SERVER

```bash
sudo vim /etc/ssh/sshd_config
```

Find out the line `#port 22` and uncomment it to change into `port ${YOUR_NEW_SSH_PORT}`, then reload the sshd service like so:

```bash
sudo systemctl restart sshd
```

One more additional step for firewall (ufw in Ubuntu, firewall-cmd in CentOS), but we will refer to tons of materials out there, instead of mentioning it here.

### ENABLE PASSWORD LOGIN FOR DESTINATION SERVER

In the same file as just above (`/etc/ssh/sshd_config`), do some modification like so:

```ini
PasswordAuthentication yes
PermitRootLogin prohibit-password -> PermitRootLogin yes
```

```bash
sudo systemctl restart sshd
```

### CREATE A PUBLIC KEY - FOR DESTINATION SERVER

```bash
ssh-keygen  # yes to all
cat /home/$USER/.ssh/id_rsa.pub
```

Now you are seeing a public key of the destination server, which is called `Deploy Key` in **Settings** section on your github repo.

I believe you got some sense on how to use it now.

### CREATE A JENKINS JOB

You need **SSH plugin** besides the preinstalled recommended plugins in your Jenkins plugin shed.

Pretty straightforward hereafter, once you know shell script, you will get things done smoothly.

### CONFIGURE GITHUB HOOK TRIGGER FOR GIT-SCM POLLING

Navigate to your github repo's **Settings** page, in the **Webhooks** tab, add in this url for **Payload URL**.

```bash
$JENKINS_BASE_URL/github-webhook/
```

And set the payload type to `application/json`.

Note that this is specific to **Github** plugin, which is automatically installed as a recommended one.

Now you have everything needed for setting up a basic CD pipeline using Jenkins.

Feel free to ask for help in case you got stuck. 😎

Thanks for reading!
