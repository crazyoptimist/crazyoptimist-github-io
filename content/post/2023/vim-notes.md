---
title: "Vim Notes"
date: 2023-04-14T20:22:54-05:00
categories: ["vim"]
---

There are several modes in VIM. `NORMAL`, `INSERT`, `VISUAL` are most common ones.

## The Most Used Default Key Bindings

- `:q`: quit VIM. `:wq`: save the current buffer and quit. `:q!` discard unsaved changes and quit
- `h`, `j`, `k`, `l`: Movement. Example: `8k` - move 8 lines up
- `:99`: jump to the line 99
- `w`: move one word forward
- `b`: move one word backward
- `$`: move to the end of the current line
- `0`: move to the beginning of the current line
- `o`: insert a new line below and go insert mode
- `O`: insert a new line above and go insert mode
- `A`: go insert mode at the end of the current line
- `y`: yank (copy) selected text
- `p`: paste the yanked text
- `d`: delete the selected text
- `dd`: delete the current line
- `x`: delete the cursor character
- `v`: select the cursor character
- `V`: select the current line
- `:sp`: split the screen horizontally
- `:vs`: split the screen vertically
- `/john`: search for "john" in the current <s>file</s> buffer
- `n`: jump to the next search result
- `N`: jump to the previous search result
- `gg`: jump to the top of the current file
- `G`: jump to the bottom of the current file
- `%`: jump to the closing/opening pair bracket
- `:%s/abc/xyz/g`: replace every "abc" with "xyz" in the current file
- `:vimgrep`: search current directory, see the help for more info
- `:help`: open VIM help

## Vim "leader" Key

`<leader>` key is a vim tool that can be used to create personalized shortcuts.

Default `<leader>` key is backslash `\`. To change the leader key to comma `,` add `let mapleader = ","` to your vimrc. You can use any other key as `<leader>` key, even space or function keys. But noting that you only have 1 second to press the actual shortcut key after the leader key is stroke(by default of course, you can configure it after all), it's kinda shitty to use backslash or function key as leader, isn't it?

Mapping a command with `<leader>` key is pretty easy.

```bash
map <leader>h :noh<CR>
```

Above mapping means if you press `<leader>` and `h` key in sequence, it will run `:noh`(remove highlighting for in-buffer search).

Mapping custom functions? No problem!

```bash
function! ToggleLineNumber()
if v:version > 703
  set norelativenumber!
endif
set nonumber!
endfunction
```

Above function toggles both relative and normal line numbers but not relative when using versions before vim 7.4.

And here's the mapping for it.

```bash
map <leader>l :call ToggleLineNumber()<CR>
```

## Vim Buffer

Buffer is the coolest concept I've learned while I use Vim to be honest.

In Vim, a buffer is nothing more than text that you are editing. For example, when you open a file, the content of the file is loaded into a buffer. So when you issue this command:

```bash
vim .vimrc
```

You are actually launching Vim with a single buffer that is filled with the contents of the .vimrc file. Easy peasy!

Now let’s look at what happens when you try to edit multiple files. Let’s issue this command:

```bash
vim .vimrc .bashrc
```

Now that you've opened two buffers, you can hop from one to another, it's very very similar to tabs in other applications like VS Code or Chrome.

For example, `:bnext` will lead you to the next buffer, and it cycles through the list of all open buffers.

So adding below two lines to your `.vimrc` file will give you a superpower to use buffer smartly and visually (I assume you're using airline plugin. But there must be similar ways if you are not using airline).

```vim
" enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" show filenames only
let g:airline#extensions#tabline#fnamemod = ':t'
```

You can view all the buffer commands by `:h :buffer`, but personally, I found only using `:bnext` and `:bd` was cool enough for my needs.

There are other related concepts in Vim, like `window` and `tab`. A window in Vim is just a way to view a buffer. Whenever you create a new vertical or horizontal split, that is a window. And Tabs? A tab is just a collection of windows according to the docs. However, correct use of buffers may bring a lot of fun on its own.

Now that you've got a correct understanding of buffers in Vim, you can supercharge your daily coding with Vim! :D

## Search and Replace Across Multiple Files

Vim has a native feature called "quickfix", which facilitates finding a list of positions in files. You can check it out by typing `:help quickfix`.

You can use Vim's native command to add findings to the quickfix list, or 3rd party extensions to achieve the same.

#### Using "vimgrep" Command

Let's say you want to find all occurrences of `windows` in the current working directory.

`:vimgrep /windows/gj **/*.*`

- `g` is a flag instructing "Add all matches in a line to the quickfix list."
- `j` is a flag instructing "Do not jump the cursor to the location of first pattern match."
- `**` is the pattern for all subdirectories
- `*.*` is the wildcard file name with wildcard extensions

If you want to search in a specific subdirectory:

`:vimgrep /windows/gj contents/**/*.*`

- `contents` is the subdirectory name

As the result of `vimgrep` command, the quickfix list will be filled with all findings.

#### Using Telescope with RipGrep

Very simple, you only need to press <Ctrl + q> after you got findings. It will add all findings to the quickfix list.

#### Nativating the Quickfix List

Here are commands that you can manage the quickfix list.

- :copen - Open the quickfix list window.
- :ccl or :cclose - Close the quickfix list window.
- :cnext or :cn - Go to the next item on the list.
- :cprev or :cp - Go to the previous item on the list.
- :cfirst - Go to the first item on the list.
- :clast - Go to the last item on the list.
- :cc <n> - Go to the nth item.

#### Replace Across Files

Vim has `cfdo` and `cdo` commands that allows you to run commands for each files in the quickfix list.

`:cfdo %s/windows/window/g | update`

Above command will replace all occurrences of `windows` with `window` in the quickfix list and write the buffers.

## Code Folding

- `zf` - Create a fold with the selected lines
- `za` - Toggle the current fold
- `zo` - Open the current fold
- `zc` - Close the current fold

There're a lot more options you can try. Read the docs for more. `:help fold`

## Common Issues

Pasting from the system clipboard generates extra empty lines and indents.

<details>
This issue happens on Windows. A workaround is `vp` or `Vp`
</details>
