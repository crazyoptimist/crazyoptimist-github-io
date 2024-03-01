---
title: "Setup Neovim with vim-plug on Windows 11"
date: 2022-11-19T17:15:28-06:00
categories: ['vim']
---
I love to use vim everywhere. Almost all the linux distros and macOS come with Vim pre-installed, but what about Windows? You can stick to the vim within the Windows Git Bash(you should know git because that's what makes you a developer :D) with a Linux-like configuration, but you may notice that `:w` command lags for some reason.

So why not use Neovim(nvim) on Windows? Let's get to it!

Open powershell and run the command below to install Neovim on your system. Different ways of installation can be found in the [source repository](https://github.com/equalsraf/vim-qt).

```bash
winget install Neovim.Neovim
```

Now close the powershell and reopen it. You should be able to use `nvim` command and see the nvim startup screen. 
It's time to configure your awesome nvim.  

[vim-plug](https://github.com/junegunn/vim-plug) is one of the most popular Vim plugin managers out there and I love it.

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

```vim
" Enable Mouse
set mouse=a

" Set Editor Font
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    " Below line assumes you installed the font "Hack Nerd Font Mono"
    GuiFont Hack\ Nerd\ Font\ Mono:h14
endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif

" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv
```

You can now use nvim on Windows. Very awesome! :XD

Happy coding!
