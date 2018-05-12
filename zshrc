# GENERAL {{{
export PATH=$PATH:$HOME/bin	# add user bin directory to path
export ZDOTDIR=$HOME/.zsh	# use .zsh as dotfiles dir
bindkey -v			# use vi keybinding
setopt beep			# enable error beep
# }}}
# HISTORY {{{
HISTFILE=$HOME/.zsh_history	# save history in $HOME
HISTSIZE=1000			# save 1000 lines in terminal
SAVEHIST=2000			# save 2000 lines in history
setopt appendhistory		# append to history
# }}}
# OH MY ZSH {{{
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
# ALIASES {{{
# del {{{
if ! dpkg -s 'trash-cli' > /dev/null; then
	alias del='trash-put'	# delete to trash
fi
# }}}
# python {{{
if ! dpkg -s 'python3' > /dev/null; then
	alias python='python3'	# use python 3
fi
# }}}
# gdb {{{
alias gdbg='gcc -Og -Wall'	# gcc debug
alias gfin='gcc -O3 -Wall'	# gcc final
# }}}
# ls {{{
alias ll='LC_COLLATE=C ls -Abgho --color'
alias la='LC_COLLATE=C ls -Albh --color'
alias lm='LC_COLLATE=C ls -Alh --color'
# }}}
# }}}
