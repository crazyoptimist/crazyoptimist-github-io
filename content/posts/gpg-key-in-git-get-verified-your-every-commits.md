---
title: "GPG Key in Git - Get Verified Your Every Commits"
date: 2020-10-04T14:40:59-05:00
categories: ["devops"]
---
You will get your own verified badge on every git commits once you configure your GPG key with your VCS.  
First things first, check your gpg version using this command:  
```bash
gpg --version
```
Allow me assume that you are on version 2.1.17 or greater.  
Use this command to generate a GPG key:
```bash
gpg --full-generate-key
```
Choose the default for *kind of key* and give 4096 for *key size*, choose `0` for expiration time or up to your decision otherwise.  
Enter your git ID(or full name is also fine), email which is verified in your git account already.  
Set your password for the GPG key.  
After you confirm your configurations, do some memory-consuming operations(for example, looping through a million-sized simple array in python or ruby) so that the key generation process wouldn't take too long.  
Now that the key generation process has been finished, use this command to list all your GPG keys in your machine.  
```bash
gpg --list-secret-keys --keyid-format LONG
```
You should see results looking like this:
```bash
/Users/hubot/.gnupg/secring.gpg
------------------------------------
sec   4096R/AA4FC34371563EAD 2020-10-10 [expires: 2021-10-10]
uid                          Hubot 
ssb   4096R/CCB717FD4BA8AA47 2020-10-10
```
In the above example, **AA4FC34371563EAD** is your GPG key **ID**.  
Use this command to retrieve your GPG key:  
```bash
gpg --armor --export YOUR_GPG_KEY_ID
# Prints the GPG key ID, in ASCII armor format
```
Copy your GPG key, beginning with `-----BEGIN PGP PUBLIC KEY BLOCK-----` and ending with `-----END PGP PUBLIC KEY BLOCK-----`.  
Paste it into the **GPG keys** field in your git account settings.  
Well, so far so good.  
Now, use this commands to tell your git to sign every commits with GPG key to get verified.  
```bash
git config --global user.signingkey YOUR_GPG_KEY_ID
git config --global commit.gpgsign true
```
Finally, add this line to your `.bashrc` or to any other of your auto-loaded dot files like `.bash_profile`, `.profile`.  
```bash
export GPG_TTY=$(tty)
```
Boom! You did it!  
Happy coding gents! 😎
