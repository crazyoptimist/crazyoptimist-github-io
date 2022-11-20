---
title: "Setup Neovim with vim-plug on Windows 11"
date: 2022-11-19T17:15:28-06:00
categories: ['vim']
---
I love to use vim everywhere. Almost all the linux distros and mac os are shipped with vim already, but for windows? You can stick to the vim within the windows git bash(you should know git because it makes you a developer :D) with a linux-like configuration, but you will notice that `:w` command has kind of lagging for some reason.  
So why not use Neovim(nvim) on Windows? Okay, let's get to it!  

Open powershell and run the command below to install Neovim on your system.  

```bash
winget install Neovim.Neovim
```

Now close the powershell and reopen it. You should be able to use `nvim` command and see the nvim startup screen. 
It's time to configure your awesome nvim.  

vim-plug is one of the most popular vim plugin managers out there and I love it.  
Install vim-plug using the following commands in your powershell:

```bash
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force
```

Inside `%USERPROFILE%\AppData\Local` directory(for example, "C:\Users\crazyoptimist\AppData\Local"), make a new directory named `nvim`, and create a new file `init.nvim` there.  

```bash
mkdir nvim
cd nvim
nvim init.vim
```

Put your vimrc contents in it. I have my dotfiles on [github](https://github.com/crazyoptimist/dotfiles), you may have one as well. :D  
Restart nvim(just quit and reopen nvim), and install the plugins listed in your `init.vim` by running `:PlugInstall` command.  

Want to edit files by double click using nvim? You can find `nvim-qt.exe` in your `Program Files\Neovim\bin` directory, which you can select in the "Open With" menu. Then create a new file `ginit.vim` with following content:

```bash
set guifont=:h16
```

You can now use nvim on Windows. Very awesome! :XD  
Happy coding!
