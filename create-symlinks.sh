#!/bin/sh

files="bashrc gdbinit gitconfig vim vimrc weechat zsh zshrc"
source=~/dotfiles
dest=~

# for every file in files
for filename in $files
do
	# create a hidden symlink to it
	ln -s $source/$filename $dest/.$filename
done
