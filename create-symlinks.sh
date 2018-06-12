#!/bin/sh

files="bashrc gdbinit gitconfig vim vimrc weechat zsh zshrc"

# for every file in files
for filename in $files
do
	# create a hidden symlink to it
	ln -s $PWD/$filename $HOME/.$filename
done
