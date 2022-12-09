---
title: "Python Development Environment Setup - an Excellent Way"
date: 2022-12-08T01:55:10-06:00
categories: ["python", "vim", "linux"]
---

## Install pyenv to manage multiple python versions

This gist self-explains how to install pyenv and use it to manage multiple python versions on your machine  

{{< gist crazyoptimist 12a7bb9d586c5c23be3d1a7a04b208db >}}

## Manage virtual envs

A virtual env is where dependencies live without polluting the global space of the current python version, preventing dependency version conflicts between different projects on the same machine.  
Install `virtualenv` package:

```
pip install virtualenv
virtualenv --version
```

It's common that `.gitignore` file excludes virtual env directories named `venv`, `env`, `.venv`, `.env`, `ENV` in most python projects.  
I prefer to use `venv` for the name of virtual envs. `cd` to the project directory and create a virtual env:

```
virtualenv venv
```

- `source venv/bin/activate` - activate the virtual env
- `deactivate` - deactivate the virtual env

## Configure vim for python intellisense

`neoclide/coc.nvim` plugin is a LSP(Language Server Protocal) client for Vim. It has its own extensions ecosystem. You can get it work for python by using `coc-pyright` extension.  
[Here](https://github.com/crazyoptimist/dotfiles) is my vimrc file. You may also have one :D.  

Happy coding!
