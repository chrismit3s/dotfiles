#!/bin/sh

files="bashrc gdbinit gitconfig vim vimrc weechat zsh zshrc"
source=~/dotfiles
dest=~

for filename in $files; do
	ln -s $source/$filename $dest/.$filename
done
