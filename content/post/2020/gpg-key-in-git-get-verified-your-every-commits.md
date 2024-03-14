---
title: "GPG Key in Git - Get Your Every Commit Verified"
date: 2020-10-04T14:40:59-05:00
categories: ["devops"]
featured: true
---

This article is based on the contents of the [Github's documentation](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/managing-commit-signature-verification).

You will get your own verified badge on every git commits once you configure your GPG key with your VCS.

First things first, check your gpg version using this command:

```bash
gpg --version
```

Allow me to assume that you are on version 2.1.17 or greater.

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
/home/crazyoptimist/.gnupg/pubring.kbx
-------------------------------
sec   rsa4096/C82530CF298B7FD4 2020-10-04 [SC]
      BD47472FAE42F276ACAD1E44C82530CF298B7FD4
uid                 [ultimate] crazycptimist (crazyoptimist) <crazyoptimist@mail.com>
ssb   rsa4096/86DE9F8D3D5B068D 2020-10-04 [E]
```

In the above example, **C82530CF298B7FD4** is your GPG key **ID**.

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

The second line will force you to sign every commits on your machine.

If you do not like it for some reason, skip the line and use -S tag instead, whenever you commit with signature.

```bash
git commit -S -m "YOUR_COMMIT_MESSAGE"
```

Finally, add this line to your `.bashrc` or to any other of your auto-loaded dot files like `.bash_profile`, `.profile`.

```bash
export GPG_TTY=$(tty)
```

If you want to remove your GPG key from your machine:

```bash
gpg --delete-secret-keys username@email
gpg --delete-keys username@email
# confirm if it's removed
gpg --list-keys
```

If you want to backup your key pair as files:

```bash
gpg --output private.pem --armor --export-secret-key username@email
gpg --output public.pub --armor --export username@email
```

If you want to import your backuped key pair:

```bash
gpg --import private.pem
gpg --import public.pub
```

Hooray! You did it!

Happy coding! 😎
