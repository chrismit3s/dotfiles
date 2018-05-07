#!/bin/sh

# for every file in the directory...
for filename in ~/dotfiles/*
do	# thats not the README.md, this scrips or whos filename is already taken
	if [ $filename != ~/dotfiles/create-symlinks.sh ] && \
	   [ $filename != ~/dotfiles/README.md ] && \
	   [ ! -e ~/.$(basename $filename) ]
	then
		# create a hidden symlink to it
		ln -s $filename ~/.$(basename $filename)
	fi
done
