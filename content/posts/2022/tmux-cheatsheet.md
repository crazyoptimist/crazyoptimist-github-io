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

## split current pane horizontally

`C-b` %  

## split current pane vertically

`C-b` "  

## switch between panes

`C-b` <arrow key>         # in direction  
`C-b` o                   # by sequence

## make a pane go full screen, exit from full screen

`C-b` z  

## resize pane in direction

`C-b` `C-<arrow key>`  

## closing pane

`C-d` or `exit`  

## create a new window

`C-b` c  

## rename the current window

`C-b` ,  

## switch between windows

`C-b` p                 # previous  
`C-b` n                 # next  
`C-b` <num key>         # by number  


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

That's it. Happy coding! 😎
