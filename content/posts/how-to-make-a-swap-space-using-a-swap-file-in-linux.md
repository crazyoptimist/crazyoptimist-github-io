---
title: "How to Make a Swap Space Using a Swap File in Linux"
date: 2020-10-06T21:43:07-05:00
categories: ["linux","devops"]
featured_image: "/images/2020/swap-space.jpg"
---
This article is based on the content of [aws knowledgebase](https://aws.amazon.com/premiumsupport/knowledge-center/ec2-memory-swap-file/).  
You might have been stuck in memory leak when building some kinda javascript-heavy frontend apps like Vue or React on a cloud server itself.  Just for serving built artifacts, we do not need large instances, but still the building process is always hungry for more memory you know.  
Below is how to resolve such specific problem.  
Oh, this is not the case if you already have a dedicated(partitioned) swap space, it's a better option in any case but in most cases, we will be playing with servers without a swap patition.  
Okay, let's get started.  
As a general rule, calculate swap space according to the following:  
| Amount of physical RAM | Recommended swap space |
| :--------------------: | :--------------------: |
| 2 GB or **less** | 2 * `Amount of physical RAM` |
| **More** than 2 GB, **less** than 32 GB | 4 GB + (`Amount of physical RAM` – 2 GB) |
| 32 GB or **more** | 1 *  `Amount of physical RAM` |
> Important Note: Swap sapce should never be less than 32 MB!  
### Steps
#### Create a swap file
```bash
sudo dd if=/dev/zero of=/swapfile bs=128M count=YOUR_COUNT
```
In the above command, **bs** is *block size* which should be less than the available memory at that moment.  
`bs * YOUR_COUNT` will be your swap file size, for example, `bs=128M count=32` means your swap file will be 4096 MB in size.  
#### Update the read and write permissions for the swap file
```bash
sudo chmod 600 /swapfile
```
#### Set up a Linux swap area
```bash
sudo mkswap /swapfile
```
#### Make the swap file available for immediate use by adding the swap file to swap space
```bash
sudo swapon /swapfile
```
#### Verify that the procedure was successful:
```bash
sudo swapon -s
```
#### Enable the swap file at boot time by editing the `/etc/fstab` file
```bash
sudo vim /etc/fstab
```
Add the following line at the end of the file:
```ini
/swapfile swap swap defaults 0 0
```
That's it.  
Happy coding!
