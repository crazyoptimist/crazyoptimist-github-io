---
title: "How to Configure Vim as Your Golang IDE"
date: 2021-09-13T20:17:30-05:00
categories: ["golang"]
---
I use Vim massively as my main IDE, and my vimrc file can be found [here](https://github.com/CrazyOptimist/dotfiles).  
This article presumes that you have already configured Vim as your code editor basically.  

Okay, let's get started by installing `fatih/vim-go` plugin with your favorite vim plugin manager.  
If you have Golang installed correctly on your machine, you will be able to run `:GoInstallBinaries` after installing the above plugin.  

After that, install [coc.nvim plugin](https://github.com/neoclide/coc.nvim), which is a great language server for Vim.  
Now, you will need a coc.nvim extension called `coc-go`, which will serve as your golang language server.  
It can be done by this command: `:CocInstall coc-go coc-json`.  
You can install some other language server extensions along with `coc-go`, like `coc-emmet`, `coc-html`, `coc-json`, etc.  

The next step is to configure the installed plugins properly. You can do it just by adding below scripts to your vimrc file:  

```vim
" disable all linters as that is taken care of by coc.nvim
let g:go_diagnostics_enabled = 0
let g:go_metalinter_enabled = []

" don't jump to errors after metalinter is invoked
let g:go_jump_to_error = 0

" run go imports on file save
let g:go_fmt_command = "goimports"

" automatically highlight variable your cursor is on
let g:go_auto_sameids = 0
" for syntax highlighting
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
```

`SHIFT` + `K` will show documentation for every func you want to know about.  
And that's pretty much it. Try and edit some `go` files with your awesome IDE.  
Happy coding!  
😎
