" TODO - things to do {{{
"  !![_] fix CustomMarkerFold()
"   ![_] better mappings for splits and folds
"    [_] add cheatsheet for commands
"    [_] text fold funtion for python with foldexpr (https://bit.ly/2FUqkVp)
"    [_] modify s/S so it works in visual block mode
" }}}

" GENERAL - basic settings {{{
call pathogen#infect()		" load all plugins/colorschemes
set lazyredraw			" only redraw when needed
set autochdir			" use file path as working directory
set confirm			" ask to save instead of complaining
set title			" rename terminal
set scrolloff=5			" keep 5 lines above and below cursor
set nowrap			" dont wrap lines
set backspace=2			" backspace over everything
set listchars=			" clear list of unprintable characters
" Mouse {{{
set mouse=a			" enable the mouse (to disable mouse scroll)
set mousehide			" hide the cursor
" }}}
" Indentation {{{
set autoindent			" copy indentation of previous line
set tabstop=8			" should not be changed
" }}}
" }}}

" UI - how everything looks {{{
" Vim {{{
syntax on			" enable syntax highlighting
colorscheme deus		" nice gruvbox-like colorscheme
set background=dark		" nightmode
set list			" show unprintable characters
set listchars+=trail:•		" show trailing spaces
set listchars+=tab:>-		" show only tabs
set number			" show line number
set numberwidth=3		" show at least a 3 digit number
set showmatch			" highlight matching brace
set cursorline			" highlight current line
set colorcolumn=81		" highlight 81st column grey
				" highlight characters after the 80th
highlight OverLength ctermbg=red ctermfg=lightgrey
match OverLength /\%81v.\+/
" }}}
" Airline {{{
let g:airline_powerline_fonts=1	" use powerline fonts
if exists('g:colors_name')	" use colorscheme as airline theme if available
	let g:airline_theme=g:colors_name
else
	let g:airline_theme='default'
endif
				" custom statusline (see bit.ly/2rnzq8G)
let g:airline_section_b='%F %m%r%h%y'
let g:airline_section_c=''
let g:airline_section_x='File:%f%{g:current_git_branch}'
let g:airline_section_y='Ln:%l/%L Col:%c'
let g:airline_section_z='%3l|%-2c'
" }}}
" }}}

" FUNCTIONS - all functions {{{
" General {{{
function! GetString(len, char)	" returns a string containing char len times
	let l:string = ''

	" concat it with char length times
	let l:i = 0
	while l:i != a:len
		let l:i += 1
		let l:string .= a:char
	endwhile

	" return it
	return l:string
endfunction
				" return the first captured group of a regex
function! GetMatchGroup(expr, pattern)
	return filter(matchlist(a:expr, a:pattern), '!empty(v:val)')[1]
endfunction
" }}}
" Git branch {{{
function! GetGitBranch()	" returns current git branch
	return system(
\		 'git rev-parse --abbrev-ref HEAD '
\		.'2> /dev/null | tr -d "\n"')
endfunction
function! StatuslineGitBranch()	" returns git branch ready for the statusline
	let l:branchname = GetGitBranch()
	return (strlen(l:branchname) > 0) ? ' Branch:'.l:branchname : ''
endfunction
" }}}
" Text folds {{{
function! CustomCFolding()	" returns folded line for c-like languages
	" get start
	let l:start = getline(v:foldstart)
	let l:start = matchstr(l:start, '^[^{]\+')

	" calc folded lines
	let l:lines = v:foldend - v:foldstart + 1
	let l:lines = l:lines . ' line' . ((l:lines == 1)?(''):('s'))

	" concat start/end
	let l:start = l:start . '{ ' . l:lines . ' } '
	echom l:start
	let l:end = ' ' . l:lines . ' '

	" get padding
	let l:pad_len = 
\		  winwidth(0)
\		- strlen(l:start)
\		- strlen(l:end)
\		- &numberwidth
\		- &foldcolumn
\		- 1
	let l:pad = GetString(l:pad_len, '-')

	" return complete line
	return l:start . l:pad . l:end
endfunction
function! CustomPythonFolding()	" returns folded line for python
	" get start
	let l:start = getline(v:foldstart - 1)
	let l:start = matchstr(l:start, '^\([^:]\+\):')

	" calc folded lines
	let l:lines = v:foldend - v:foldstart + 1
	let l:lines = l:lines . ' line' . ((l:lines == 1)?(''):('s'))

	" concat start/end
	let l:start = l:start . ': (' . l:lines . ') '
	let l:end = ' ' . l:lines . ' '

	" get padding
	let l:pad_len =
\		  winwidth(0)
\		- strlen(l:start)
\		- strlen(l:end)
\		- &numberwidth
\		- &foldcolumn
\		- 1
	let l:pad = GetString(l:pad_len, '-')

	" return complete line
	return l:start . l:pad . l:end
endfunction
function! CustomMarkerFolding()
	" get start
	let l:start = getline(v:foldstart - 1)
	let l:lines = v:foldend - v:foldstart + 1
	let l:lines = l:lines . ' line' . ((l:lines == 1)?(''):('s'))

	if(match(l:start, '^[\S\W\D]{1,3} [^-]- [^{]{'))
		" Large header: com head - end {_{
		" get com
		let l:com = GetMatchGroup(
\			l:start,
\			'^\([\S\W\D]\+\) [^-]- [^{]{')
		echom 'COM #' . l:com . '#'

		" get head
		let l:head = GetMatchGroup(
\			l:start,
\			'^[\S\W\D]\+ \([^-]\)- [^{]{')
		echom 'HEAD #' . l:head . '#'

		" get end
		let l:end = GetMatchGroup(
\			l:start,
\			'^[\S\W\D]\+ [^-]- \([^{]\){')
		echom 'END #' . l:end . '#'

		" get first padding
		let l:pad_len =
			  13
\			- strlen(l:head)
		echom 'PAD1 #' . l:pad_len . '#'
		let l:pad1 = GetString(l:pad_len, ' ')

		" get second padding
		let l:pad_len =
\			  winwidth(0)
\			- strlen(l:com)
\			- strlen(l:head)
\			- strlen(l:end)
\			- strlen(l:pad1)
\			- strlen(l:end)
\			- &numberwidth
\			- &foldcolumn
\			- 1
		echom 'PAD2 #' . l:pad_len . '#'
		let l:pad2 = GetString(l:pad_len, '-')

		return
\			  l:head
\			. l:pad1
\			. l:end
\			. l:pad2
\			. ' line'
\			. ((l:lines == 1)?(''):('s'))
\			. ' '
	else
		echom 'false'
		" Small header: Xxxx {_{
	endif
endfunction
" }}}
" }}}

" TOOLS - how tools behave {{{
" Folding {{{
set foldcolumn=5		" add column for fold information
set foldmethod=syntax		" fold lines syntax-based
set foldlevelstart=4		" start with 4 open folds
" }}}
" Searching {{{
set incsearch			" search as charcters are entered
set hlsearch			" highlight matches
set ignorecase			" ignore case when searching
set smartcase			" only if there are no capital letters in querry
" }}}
" }}}

" MAPPINGS - commands for editing {{{
let mapleader=','		" set <leader> key
				" insert single character with s/S
nnoremap s i<Space><Esc>r
nnoremap S a<Space><Esc>r
vnoremap s I<Space><Esc>gvr
vnoremap S A<Space><Esc>gvr
				" shift + undo = redo
nnoremap U <C-R>
				" copy from cursor to end of line with Y like D
nmap Y yE
" Movement {{{
" Cursor {{{
				" map movement characters one to the right
nnoremap j h
nnoremap k j
nnoremap l k
nnoremap ö l
vnoremap j h
vnoremap k j
vnoremap l k
vnoremap ö l
onoremap j h
onoremap k j
onoremap l k
onoremap ö l
				" move more lines/character when capital
nnoremap J 3h
nnoremap K 3j
nnoremap L 3k
nnoremap Ö 3l
vnoremap J 3h
vnoremap K 3j
vnoremap L 3k
vnoremap Ö 3l
onoremap J 3h
onoremap K 3j
onoremap L 3k
onoremap Ö 3l
				" move in line
nnoremap B ^
nnoremap E $
vnoremap B ^
vnoremap E $
onoremap B ^
onoremap E $
				" unmap $/^
nnoremap ^ <nop>
nnoremap $ <nop>
vnoremap ^ <nop>
vnoremap $ <nop>
onoremap ^ <nop>
onoremap $ <nop>
" }}}
" Page {{{
				" scroll with <C-k/l>
nnoremap <C-l>      <C-e>
nnoremap <C-k>      <C-y>
vnoremap <C-l>      <C-e>
vnoremap <C-k>      <C-y>
inoremap <C-l> <C-o><C-e>
inoremap <C-k> <C-o><C-y>
" }}}
" Splits {{{
set splitright			" open new splits on the right
				" cycle through spilts
nnoremap <leader>wn      <C-w>w
onoremap <leader>wn      <C-w>w
inoremap <leader>wn <C-o><C-w>w
nnoremap <leader>wp      <C-w>W
onoremap <leader>wp      <C-w>W
inoremap <leader>wp <C-o><C-w>W
				" easier navigations
nnoremap <leader>wj <C-W>h
nnoremap <leader>wk <C-W>j
nnoremap <leader>wl <C-W>k
nnoremap <leader>wö <C-W>l
" }}}
" Tabs {{{
				" cycle through tabs
nnoremap <leader>tn      :tabnext<CR>
onoremap <leader>tn      :tabnext<CR>
inoremap <leader>tn <C-o>:tabnext<CR>
nnoremap <leader>tp      :tabnext<CR>
onoremap <leader>tp      :tabnext<CR>
inoremap <leader>tp <C-o>:tabnext<CR>
" }}}
" }}}
" Folding {{{
				" toggle/open/close folds fast
nnoremap <leader>ff za
nnoremap <leader>fo zo
nnoremap <leader>fc zc
nnoremap <leader>fO zR
nnoremap <leader>fC zM
" }}}
" Searching {{{
				" turn off search highlight
nnoremap <silent> <leader>s :nohlsearch<CR>
" }}}
" Mouse {{{
				" disable mouse wheel scroll
map <ScrollWheelUp> <nop>
map <S-ScrollWheelUp> <nop>
map <C-ScrollWheelUp> <nop>
map <ScrollWheelDown> <nop>
map <S-ScrollWheelDown> <nop>
map <C-ScrollWheelDown> <nop>
" }}}
" Nerdtree {{{
				" toggle Nerdtree
nnoremap <silent> <C-n>      :NERDTreeToggle<CR>
vnoremap <silent> <C-n>      :NERDTreeToggle<CR>
inoremap <silent> <C-n> <C-o>:NERDTreeToggle<CR>
" }}}
" Gundo {{{
				" toggle Gundo
nnoremap <silent> <C-g>      :GundoToggle<CR>
vnoremap <silent> <C-g>      :GundoToggle<CR>
inoremap <silent> <C-g> <C-o>:GundoToggle<CR>
" }}}
" }}}

" FILES - settings for files {{{
filetype plugin indent on	" enable filetype detection
if !empty(glob('/usr/bin/zsh'))	" use glorious zsh if available
	set shell=/usr/bin/zsh
endif
" C code {{{
augroup filetype_c		" auto commands for c code
	autocmd!
	autocmd filetype c
	\	setlocal shiftwidth=8
	\|	setlocal softtabstop=8
	\|	setlocal noexpandtab
	\|	setlocal listchars+=tab:\|\ 
	\|	setlocal foldmethod=syntax
	\|	setlocal foldtext=CustomCFolding()
"	\|	highlight link Folded Normal
augroup END
" }}}
" Python code {{{
augroup filetype_python		" auto commands for python code
	autocmd!
	autocmd filetype python
	\	setlocal shiftwidth=4
	\|	setlocal softtabstop=4
	\|	setlocal expandtab
	\|	setlocal foldmethod=indent
	\|	setlocal foldtext=CustomPythonFolding()
"	\|	highlight link Folded Normal
augroup END
" }}}
" Vim {{{
augroup filetype_vim		" autocommands for configfiles
	autocmd!
	autocmd filetype vim
	\	setlocal foldmethod=marker
	\|	setlocal foldtext=CustomMarkerFolding()
augroup END
" }}}
" Help {{{
augroup filetype_help
	autocmd!
	autocmd filetype help
	\	noremap t <C-]>
	\|	noremap T <C-t>
augroup END
" }}}
" Configfiles {{{
augroup filetype_configfile	" autocommands for configfiles
	autocmd!
	autocmd bufread,bufnewfile *rc
	\	setlocal foldmethod=marker
"	\|	setlocal foldtext=CustomMarkerFolding()
"	\|	highlight! Folded ctermbg=
augroup END
" }}}
" }}}

" PLUGINS - settings for plugins {{{
" Nerdtree {{{
augroup plugin_nerdtree		" auto commands for nerdtree
	autocmd!
				" close nerdtree if its the only buffer left
	autocmd bufenter *
	\	if(winnr("$") == 1
	\	&& exists("b:NERDTree")
	\	&& b:NERDTree.isTabTree())
	\|		q
	\|	endif
augroup END
" }}}
" Airline {{{
augroup plugin_airline		" auto commands for ailrline
	autocmd!
				" update git branch in status line
	autocmd vimenter,shellcmdpost *
	\	let g:current_git_branch = StatuslineGitBranch()
				" disable the trailing whitespace check
	autocmd vimenter *
	\	silent!
	\|	AirlineToggleWhitespace
	\|	redraw!
augroup END
" }}}
" Gundo {{{
if has('python3')		" use python 3 if available
	let g:gundo_prefer_python3 = 1
endif
				" map movement keys one to the right
let g:gundo_map_move_newer='l'
let g:gundo_map_move_older='k'
				" close split when its unfocused again
let g:gundo_return_on_revert=1
" }}}
" }}}

" CHEATSHEET - important commands in one place {{{
" }}}
