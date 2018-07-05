# dotfiles

Here I backup all of my dotfiles (`.vimrc`, `.bashrc`, `.gdbinit`, etc). On my
Xubuntu machine they are in a directory called dotfiles and from there they are
symlinked in the $HOME directory.


## Overview

File/Folder		 | Use
-----------		 | ---
vimrc			 | vim configuration
vim			 | vim plugins/colorschemes/etc
zshrc			 | zsh configuration
zsh			 | zsh dotfiles like `.zcompdump`
gdbinit			 | gdb configuration
pwndbg			 | pwndbg extention for gdb
bashrc			 | bash configuration, mostly auto-generated stuff
setup.(bat|sh)		 | script to set everything up (see Setup)

## Setup

Just clone the repository and run setup.(bat|sh) depending on system and it will
symlink or copy the files specified in the `files` variable in the script and
add a dot to them so they will be hidden (at least on linux).
