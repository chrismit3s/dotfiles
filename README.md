# dotfiles

Here I backup all of my dotfiles (`.vimrc`, `.bashrc`, `.gdbinit`, ...). On my 
Ubuntu machine they are in a directory called dotfiles and from there they are
symlinked in the $HOME directory. But since you dont want to create all those
symlinks by hand, I created the `create-symlinks.sh` script. It creates
symlinks for all files in the dotfiles directory (except for itself and this
`README.md`), and adds a dot to the filename so they are hidden and everything
works.


## Overview

File/Folder	 | Use
---------------- | ---
vimrc		 | vim configuration
vim		 | vim plugins/colorschemes/etc
zshrc		 | zsh configuration
zsh		 | zsh dotfiles like `.zcompdump`
gdbinit		 | gdb configuration
pwndbg		 | pwndbg extention for gdb
bashrc		 | bash configuration, mostly auto-generated stuff
create-symlinks.sh | script to link all files in `$HOME`
