################################  CUSTOMIZED  ##################################
export PATH=$PATH:$HOME/bin			# add user bin directory to path
#*******************************  OH MY ZSH  **********************************#
ZSH_THEME='lambda'				# very minimalist theme
#ZSH_THEME='mh'					# awesome theme
plugins=(
	git					# git aliases, etc
	python					# python syntax highlighting
	colored-man-pages			# colored man pages
#	vi-mode					# doesnt source .vimrc :(
)
#**********************************  ZSH  *************************************#


###################################  ZSH  ######################################
bindkey -v					# use vi keybinding
export ZDOTDIR=$HOME/.zsh			# use .zsh as dotfiles dir
#********************************  HISTORY  ***********************************#
HISTFILE=$HOME/.zsh_history			# save history in $HOME
HISTSIZE=1000					# save 1000 lines in terminal
SAVEHIST=2000					# save 2000 lines in history
setopt appendhistory beep			# enable  error beep and  append
						# to history
#*******************************  OH MY ZSH  **********************************#
export ZSH=$ZDOTDIR/oh-my-zsh			# set oh-my-zsh directory
source $ZSH/oh-my-zsh.sh			# needs to come  after oh-my-zsh
						# config


################################  CUSTOMIZED  ##################################
#********************************  ALIASES  ***********************************#
#-----------------------------------  LS  -------------------------------------#
alias ll='LC_COLLATE=C ls -Abgho --color'	# 'standard' list all
alias la='LC_COLLATE=C ls -Albh --color'	# list all with groups/owners
#----------------------------------  GCC  -------------------------------------#
alias gdbg='gcc -Og -Wall'
alias gfin='gcc -O3 -Wall'
#---------------------------------  OTHER  ------------------------------------#
alias del='trash-put'				# delete to trash
alias python='python3'				# use python 3
