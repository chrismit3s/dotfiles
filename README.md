MOVED TO https://gitlab.com/chrismit3s/dotfiles

# dotfiles

Here I backup all of my dotfiles (`.vimrc`, `.bashrc`, `.gdbinit`, etc). On my
Xubuntu machine they are in a directory called dotfiles and from there they are
symlinked in the $HOME directory, with `setup.sh`.


## Overview

File/Folder		 | Use
-----------------+----
bashrc           | bash configuration, mostly auto-generated stuff (not used, see zshrc)
cvimrc           | config for chrome(ium) vim plugin
gdbinit          | gdb config
gitconfig        | git config
setup.(bat|sh)   | script to set everything up (see Setup)
vim              | vim plugins/colorschemes/etc
vimrc            | vim config
vsvimrc          | config for visual studio vim plugin
weechat          | weechat directory
zsh              | zsh files like `.zcompdump`, also for oh my zsh
zshrc            | zsh config

## Setup

Just clone the repository and run setup.(bat|sh) depending on system and it will
symlink or copy the files specified in the `files` variable in the script and
add a dot to them so they will be hidden (at least on linux).
