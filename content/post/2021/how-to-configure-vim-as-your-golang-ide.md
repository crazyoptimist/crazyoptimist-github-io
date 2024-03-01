---
title: "How to Configure Vim as Your Go IDE"
date: 2021-09-13T20:17:30-05:00
categories: ["go"]
---
Vim/Neovim is my IDE for day-to-day work. My vimrc file can be found [here](https://github.com/crazycptimist/dotfiles).

This article is all about Vim(not Neovim), and I assume that you have already configured Vim as your code editor.

Okay, let's get started by installing `fatih/vim-go` plugin with your favorite vim plugin manager.

After that, if you have Go installed correctly on your machine already, you will be able to run `:GoInstallBinaries`.

Next, install [coc.nvim](https://github.com/neoclide/coc.nvim) plugin, which is a great language server host for Vim.

> For Neovim, I would recommend to use Nvim LSP client, which is more awesome than coc-nvim in my opinion.

Now, you will need a coc.nvim extension called `coc-go`, which will serve as your Go language server. It can be done by this vim command: `:CocInstall coc-go`.

You can install some other language server extensions along with `coc-go`, like `coc-tsserver`, `coc-json`, etc.

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

Happy coding, Gophers! 😎
