---
title: "Tmux Cheatsheet"
date: 2022-10-12T05:57:14-05:00
categories: ["linux"]
---
I use linux terminal all day, and if you are like me, you should use [tmux](https://github.com/tmux/tmux), which enables a number of terminals to be created, accessed, and controlled from a single screen, just to be more productive!  
So, there're some essential commands for tmux down below.  

## start a new session

```
tmux                              # session name will be 0,1,2, ... by default
tmux new -s <session name>        # you can set a custom session name
```

## rename an existing session

```
tmux rename-session -t <old name> <new name>
```

## detach current session

`C-b` d  
`C-b` D

## list running sessions

```
tmux ls
```

## attach an existing session

```
tmux attach -t <session name>
```
or
```
tmux a -t <session name>
```

## split current pane horizontally

`C-b` %  

## split current pane vertically

`C-b` "  

## switch between panes

`C-b <arrow key>`         # in direction  
`C-b` o                   # by sequence

## make the current pane full screen(same for exit)

`C-b` z  

## resize the current pane in an arrow direction

`C-b` `C-<arrow key>`  

## closing the current pane

`C-d` or `exit`  

## create a new window

`C-b` c  

## rename the current window

`C-b` ,  

## switch between windows

`C-b` p                 # previous  
`C-b` n                 # next  
`C-b <num key>`         # by number  


## to use vim color scheme inside tmux

Create a tmux config file

```
touch ~/.tmux.conf
```

Put these lines in the file:

```ini
set -g default-terminal "xterm-256color"
set -ga terminal-overrides ",*256col*:Tc"
```

## wait, what? I can't scroll up/down inside tmux. it sucks, huh?

Nah, you can do it. You can get into scrolling mode by `C-b` [, and quit by `q`. Very cool :XD  

## even better, we can persist tmux sessions between reboots. soooo cool, isn't it?

Tmux has its own plugin ecosystem. A plugin called [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) enables us to persist sessions across reboots.  
So, there are two ways of installing `tmux-resurrect` plugin, and the manual way is my preferred one because I do not use many plugins for tmux.  

```
mkdir -p ~/.tmux
cd ~/.tmux
git clone https://github.com/tmux-plugins/tmux-resurrect
```

Then add this line to the bottom of `~/.tmux.conf`:

```
run-shell ~/.tmux/tmux-resurrect/resurrect.tmux
```

Reload tmux environment:

```
tmux source-file ~/.tmux.conf
```

Wowooo, you are now able to persist any number of sessions across reboots

- `C-b` `C-s` - save
- `C-b` `C-r` - restore


That's it. Happy tmuxing! :XD
