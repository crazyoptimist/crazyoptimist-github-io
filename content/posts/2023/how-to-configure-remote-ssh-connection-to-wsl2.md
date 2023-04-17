---
title: "How to Configure Remote SSH Connection to WSL 2"
date: 2023-04-17T03:45:14-05:00
categories: ["linux", "network"]
---

There's a case that you want to use WSL(Windows Subsystem for Linux) via remote ssh connection.

Configuring remote ssh connection to WSL is not super straightforward, because:

- You need to configure port-forwarding from WSL to the host machine
- WSL doesn't have `systemd`, so you need to configure automatic booting WSL and then SSH server inside it(because you want to automate everything).

So let's check out the configuring process step by step.

Install SSH server on the WSL instance.

```bash
sudo apt install openssh-server
```

Configure the SSH server to accept SSH connetions on port 2222(you may want to use another port, no problem!).

```bash
sudo vim /etc/ssh/sshd_config
```

```ini
Port 2222
#AddressFamily any
ListenAddress 0.0.0.0
#ListenAddress ::
```

Reboot the SSH server.

```bash
sudo service ssh restart
```

Allow your default WSL user to start the SSH server without typing a password.

```bash
sudo sh -c "echo '${USER} ALL=(root) NOPASSWD: /usr/sbin/service ssh start' >/etc/sudoers.d/service-ssh-start"
```

Configure firewall on the host machine(Windows 10 or 11) to allow remote SSH connections.

Open CMD as administrator and run:

```bash
netsh advfirewall firewall add rule name="Open Port 2222 for WSL2" dir=in action=allow protocol=TCP localport=2222
```

Create a batch script that boots WSL and SSH server on host startup.

```batch
@echo off
setlocal

C:\Windows\System32\bash.exe -c "sudo /usr/sbin/service ssh start"

C:\Windows\System32\netsh.exe interface portproxy delete v4tov4 listenport=2222 listenaddress=0.0.0.0 protocol=tcp

for /f %%i in ('wsl hostname -I') do set IP=%%i
C:\Windows\System32\netsh.exe interface portproxy add v4tov4 listenport=2222 listenaddress=0.0.0.0 connectport=2222 connectaddress=%IP%

endlocal
```

On the host OS(Windows), open start menu and search for "Task Scheduler", where you can create a new scheduled task that runs the above batch script. Make sure that you configure the task run whether a user is logged in or not.

That's pretty much. Please comment below if you got stuck in the process.

Happy coding!
