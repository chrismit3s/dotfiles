#!/bin/sh

for filename in ~/dotfiles/*
do
	if [ $filename != ~/dotfiles/create-symlinks.sh ] && \
	   [ $filename != ~/dotfiles/README.md ]
	then
		ln -s $filename ~/.$(basename $filename)
	fi
done
