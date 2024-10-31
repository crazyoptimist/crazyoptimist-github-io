---
title: "How to Configure DWM"
date: 2024-10-31T03:05:55-05:00
categories: ["linux"]
---

## Introduction

DWM is one of the most lightweight window manager for Linux. DWM stands for Dynamic Window Manager, but it's still focused on tiling window management.

So what is a tiling window manager? A tiling window manager automatically arranges and sizes windows on your screen, typically in a grid-like fashion. You would normally be using a floating window manager in MacOS, Windows, or Linux (XFCE, KDE Plasma, GNOME, etc).

A dynamic window manager is capable of managing windows in both fashion.

Are there any advantages in using a tiling window manager? For me, the answer is YES. It brings automatic alignment of windows, keyboard-centric operation, efficient use of screen space, and improved focus and productivity. Asides that, you look very cool if you use a tiling WM, just like when you use NVIM as your IDE. :sunglasses:

There are bunch of tiling window managers and dynamic window managers out there like i3, bspwm, dwm, sway, xmonad, qtile, hyprland, just to name a few.

DWM has only a few thousands lines of source code written in C, and you many guess the reason why it's very lightweight. It only eats 200-300 MB of RAM, while a typical floating window manager like GNOME usually consumes more than 1 GB.

Knowing all those good stuff, why not give it a try? TL;DR: Let's dive into it!

Before installing and configuring DWM on my machine, I already had Arch Linux with KDE Plasma as my daily driver. Thus, you will likely need to bring some more/different hacks if your prerequisite Linux setup is different from mine.

## Install DWM

### Install dependencies

I skipped this step because dependencies were already met by my KDE Plasma setup.

On Arch Linux:

```bash
sudo pacman -S base-devel libx11 libxft libxinerama freetype2 fontconfig
```

On Debian:

```bash
sudo apt install build-essential libx11-dev libxft-dev libxinerama-dev libfreetype6-dev libfontconfig1-dev
```

### Pull the source code

There's only one correct way of installing every suckless.org app -- from source.

Create a directory where you'll download source codes from suckless.org.

```bash
cd $HOME
mkdir .suckless
cd .suckless
```

I believe you have `git` installed on your machine already, but if not, install it:

```bash
sudo pacman -S git
```

Clone the DWM source repository.

```bash
git clone https://git.suckless.org/dwm
```

I would recommend storing your fork of DWM in your own git repository like I did. (optional, you can skip this step and do everything locally)

```bash
# add my fork repo url as upstream
git remote add upstream git@github.com:crazyoptimist/dwm-fork.git
# create a new branch where I will apply all my hacks
git switch -c hacks
# push the new branch to upstream
git push -u upstream hacks
```

### Install DWM, ST, and DMenu

DWM has a default configuration that uses ST (Simple Terminal) as a terminal emulator. Suckless team developed ST but it doesn't come with DWM. So you need to either install ST or modify the DWM config to use your favorite terminal emulator. In my case, I configured DWM to use Alacritty. Let's get back to it in a few.

For now, just install ST and DMenu. DMenu is something like an application launcher.

```bash
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu
```

Installing DWM is done by a single `make` command:

```bash
sudo make clean install
```

The above command builds the C code into a binary, and copies it to a system's executable path. That's why you need `sudo`.

Same applies for ST and DMenu.

Now, install everything:

```bash
cd $HOME/.suckless
cd dwm
make
sudo make clean install
cd ..
cd st
make
sudo make clean install
cd ..
cd dmenu
make
sudo make clean install
cd
```

### Let it run on boot

If you're using `startx`, simply add `exec dwm` at the end of `$HOME/.xinitrc`.

In my case, I already had SDDM installed with my KDE Plasma setup. Below approach will also work for other display managers like LightDM or GDM.

Create a desktop entry file for DWM:

```bash
sudo vim /usr/share/xsessions/dwm.desktop
```

```ini
[Desktop Entry]
Name=DWM
Comment=Suckless's DWM
Exec=dwm
Type=XSession
```

After rebooting, you will be able to select DWM in the login screen.

### Use DWM for the first time

In a tiling window management system, the screen is split into two parts - the master area and the stack area. The master area holds only one window at a time, and the stack area holds all other windows.

By default, DWM is configured to have 9 workspaces, named 1-9.

You can do everything only with keyboard in DWM. To make this happen, there's MODKEY. MODKEY is a keyboard shortcut combination prefix just like the prefix key in tmux. MODKEY in DWM is configurable, and it's configured as ALT by default.

Here're some of the default shortcuts in DWM:

| Key Binding | Action |
|-------------|--------|
| MODKEY + SHIFT + ENTER | Open the terminal emulator (ST by default) |
| MODKEY + P | Open the application launcher (DMenu by default) |
| MODKEY + J | Focus on the next window |
| MODKEY + K | Focus on the previous window |
| MODKEY + SHIFT + C | Close the focused window |
| MODKEY + ENTER | Move the focused window into the master area, and vice versa (toggle) |
| MODKEY + SHIFT + Q | Quit DWM |
| MODKEY + <# of worksapce> | Move to the workspace # |
| MODKEY + SHIFT + <# of worksapce> | Move the focused window to the workspace # |

## Configure DWM

Every configuration resides in `config.def.h`, of which file name stands for "default config.h". You can copy `config.def.h` to create `config.h` and apply all the config changes to `config.h` before you build & reinstall DWM.

Personally I prefer applying all my hacks to `config.def.h` and remove `config.h` before rebuilding.

### Use a different terminal emulator

This time, I would decide to use Alacritty instead of ST.

Install Alacritty.

```bash
sudo pacman -S alacritty
```

Open `config.def.h` with your favorite code editor and search for `termcmd`.

```bash
nvim config.def.h
```

You'll find below line where you can replace `st` with `alacritty`.

```c
static const char *termcmd[]  = { "alacritty", NULL };
```

Run the install command now.

```bash
rm config.h
sudo make clean install
```

Reload DWM by quitting or rebooting.

### Change the MODKEY

Locate this part in the config file:

```c
/* key definitions */
#define MODKEY Mod1Mask
```

You can replace `Mod1Mask` (indicates ALT) with `Mod4Mask` (indicates SUPER/WIN).

### Use a different application launcher

This time, I would decide to use Rofi instead of DMenu.

Install Rofi.

```bash
sudo pacman -S rofi
```

Locate this part in the config file:

```c
// ... snip ...

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */

// ... snip ...
```

Add these lines below the above section:

```c
static const char *rofi[] = { "rofi", "-show", "drun", "-show-emojis", NULL };
```

Locate this line in the config file:

```c
static const Key keys[] = {
    // ... snip ...
}
```

It's where all key bindings are registered.

Replace dmenu with rofi:

```c
static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = rofi } },
    // ... snip ...
}
```

In the above code, XK is just a naming prefix, `p` is the actual shortcut key

Same way, you can create/edit other shortcuts. For example, I configured flameshot like so:

```c
static const char *flameshot[] = { "flameshot", "launcher", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = rofi } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },

    // ... snip ...
}
```

Reinstall and reload DWM.

### Configure autostart

There is a staggering number of Git patches submitted by DWM users on the [suckless.org website](https://dwm.suckless.org/patches/). Every patch exists to enhance DWM by adding an extra functionality or modify default configurations.

This time, I would decide to leverage a patch named "cool autostart". There are a few other patches too, aiming for the same purpose.

Since you will likely want to use more than one patches in the future, create a separate directory for all patches and download them there.

```bash
cd $HOME/.suckless/dwm
mkdir patches
cd patches
wget https://dwm.suckless.org/patches/cool_autostart/dwm-cool-autostart-20240312-9f88553.diff
```

Apply the patch.

```bash
git apply patches/dwm-cool-autostart-20240312-9f88553.diff
```

Follow the instructions from the patch author. I only needed to add autostart items into the autostart array.

```c
static const char *const autostart[] = {
  "sh", "-c", "/home/snail/.local/init.sh", NULL,
  "feh", "--bg-scale", "/home/snail/.local/wallpaper.png", NULL,
  "/usr/lib/polkit-kde-authentication-agent-1", NULL,
  "mblocks", NULL,
  "fcitx5", NULL,
  NULL /* terminate */
};
```

Reinstall and reload DWM.

That's pretty much it and thanks for reading thus far!

If you are a terminal aficionado, DWM is not at all complicated, and I believe you will likely become addicted. :p
