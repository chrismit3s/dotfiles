# General {{{
export PATH=$PATH:$HOME/bin	# add user bin directory to path
export ZDOTDIR=$HOME/.zsh	# use .zsh as dotfiles dir
bindkey -v			# use vi keybinding
setopt beep			# enable error beep
# }}}


# History {{{
HISTFILE=$HOME/.zsh_history	# save history in $HOME
HISTSIZE=1000			# save 1000 lines in terminal
SAVEHIST=2000			# save 2000 lines in history
setopt appendhistory		# append to history
# }}}


# Oh my zsh {{{
#ZSH_THEME='mh'			# awesome theme
ZSH_THEME='lambda'		# minimalist theme
plugins=(
	git			# git aliases, etc
	python			# python syntax highlighting
	colored-man-pages	# colored man pages
#	vi-mode			# doesnt source .vimrc :(
)
export ZSH=$ZDOTDIR/oh-my-zsh	# set oh-my-zsh directory
source $ZSH/oh-my-zsh.sh	# source oh-my-zsh
# }}}


# Aliases {{{
alias gdbg='gcc -Og -Wall'	# gcc debug
alias gfin='gcc -O3 -Wall'	# gcc final
alias del='trash-put'		# delete to trash
alias python='python3'		# use python 3
				# some ls aliases
alias ll='LC_COLLATE=C ls -Abgho --color'
alias la='LC_COLLATE=C ls -Albh --color'
alias lm='LC_COLLATE=C ls -Alh --color'
# }}}
