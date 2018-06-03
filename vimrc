" TODO - things to do {{{
"    [_] text fold funtion for python with foldexpr (https://bit.ly/2FUqkVp)
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
" Behavior {{{
augroup start_in_insert		" start in insert mode when creating a new file
	autocmd!
	autocmd bufnewfile *
	\	startinsert
augroup END
" }}}
" }}}
" UI - how everything looks {{{
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
				" return the n-th captured group of a regex
function! GetMatchGroup(expr, pattern, n)
	return filter(matchlist(a:expr, a:pattern), '!empty(v:val)')[a:n]
endfunction
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
" CustomCFolding() {{{
function! CustomCFolding()	" returns folded line for c-like languages
	" get start
	let l:start = getline(v:foldstart)
	let l:start = matchstr(l:start, '^[^{]\+')

	" calc folded lines
	let l:lines = v:foldend - v:foldstart
	let l:lines = l:lines . ' line' . ((l:lines == 1)?(''):('s'))

	" concat start/end
	let l:start = l:start . '{ ' . l:lines . ' } '
	let l:lines =
\		  ' '
\		. l:lines
\		. ' line'
\		. ((l:lines == 1)?(' '):('s'))
\		. ' '

	" get padding (81 so that the 'lines' is after the color column)
	let l:pad_len = 81 - strlen(l:start . l:lines)
	let l:pad = GetString(l:pad_len, '-')

	" return complete line
	return l:start . l:pad . l:lines
endfunction
" }}}
" CustomPythonFolding() {{{
function! CustomPythonFolding()	" returns folded line for python
	" get start
	let l:start = getline(v:foldstart)
	let l:start = matchstr(l:start, '^[^:]\+')

	" calc folded lines
	let l:lines = v:foldend - v:foldstart
	let l:lines =
\		  ' '
\		. l:lines
\		. ' line'
\		. ((l:lines == 1)?(''):('s'))
\		. ' '

	" Concat them to start
	let l:start = l:start . ': (' . l:lines . ') '

	" get padding
	let l:pad_len = 81 - strlen(l:start . l:lines)
	let l:pad = GetString(l:pad_len, '-')

	" return complete line
	return l:start . l:pad . l:lines
endfunction
" }}}
" CustomMarkerFolding() {{{
function! CustomMarkerFolding()	" returns folded line for marker folding
	" get start
	let l:start = getline(v:foldstart)

	" calc folded lines
	let l:lines = v:foldend - v:foldstart
	let l:lines =
\		  ' '
\		. l:lines
\		. ' line'
\		. ((l:lines == 1)?(''):('s'))
\		. ' '

	if (!match(l:start, '^[^-]\+-[^{]\+')) " XXXX - yyyy (((
		" get head and body
		let l:head = GetMatchGroup(l:start, '^\([^-]\+\)-[^{]\+', 1)
		let l:body = GetMatchGroup(l:start, '^[^-]\+\(-[^{]\+\)', 1)

		" get first padding
		let l:pad_len = 14 - strlen(l:head)
		let l:pad1 = GetString(l:pad_len, ' ')

		" get second  padding
		let l:pad_len = 81 - strlen(l:head . l:body . l:pad1 . l:lines)
		let l:pad2 = GetString(l:pad_len, '-')

		" return complete line
		return l:head . l:pad1 . l:body . l:pad2 . l:lines
	else " Xxxx (((
		" concat start/end
		let l:start = GetMatchGroup(l:start, '^\([^{]\+\)', 1)

		" get padding
		let l:pad_len = 81 - strlen(l:start . l:lines)
		let l:pad = GetString(l:pad_len, '-')

		" return complete line
		return l:start . l:pad . l:lines
	endif
endfunction
" }}}
" CustomSyntaxFolding() {{{
function! CustomSyntaxFolding()	" returns folded line for syntax folding
	" get start
	let l:start = getline(v:foldstart) . getline(v:foldend)

	" calc folded lines
	let l:lines = v:foldend - v:foldstart
	let l:lines = l:lines . ' line' . ((l:lines == 1)?(''):('s'))

	" concat start/end
	let l:start = l:start . '{ ' . l:lines . ' } '
	let l:lines =
\		  ' '
\		. l:lines
\		. ' line'
\		. ((l:lines == 1)?(' '):('s'))
\		. ' '

	" get padding
	let l:pad_len = 81 - strlen(l:start . l:lines)
	let l:pad = GetString(l:pad_len, '-')

	" return complete line
	return l:start . l:pad . l:lines
endfunction
" }}}
" }}}
" }}}
" TOOLS - how tools behave {{{
" Folding {{{
set foldcolumn=5		" add column for fold information
set foldmethod=syntax		" fold lines syntax-based
				" custom foldfunction for syntaxfolding
set foldtext=CustomSyntaxFolding()
set foldlevelstart=5		" start with 5 open folds
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
nnoremap <leader>s      <C-w>w
onoremap <leader>s      <C-w>w
inoremap <leader>s <C-o><C-w>w
				" other movements with <leader>W
nnoremap <leader>S      <C-w>
onoremap <leader>S      <C-w>
inoremap <leader>S <C-o><C-w>
" }}}
" Tabs {{{
				" cycle through tabs
nnoremap <silent> <leader>t       :tabnext<CR>
onoremap <silent> <leader>t       :tabnext<CR>
inoremap <silent> <leader>t  <C-o>:tabnext<CR>
nnoremap <silent> <leader>Tn      :tabnext<CR>
onoremap <silent> <leader>Tn      :tabnext<CR>
inoremap <silent> <leader>Tn <C-o>:tabnext<CR>
nnoremap <silent> <leader>Tp      :tabprevious<CR>
onoremap <silent> <leader>Tp      :tabprevious<CR>
inoremap <silent> <leader>Tp <C-o>:tabprevious<CR>
" }}}
" Folding {{{
				" toggle/open/close folds fast
nnoremap <leader>f  za
nnoremap <leader>Fo zo
nnoremap <leader>Fc zc
nnoremap <leader>FO zR
nnoremap <leader>FC zM
" }}}
" Searching {{{
				" turn off search highlight
nnoremap <silent> <leader>h :nohlsearch<CR>
" }}}
" Macros {{{
				" easier macro use
nmap <leader>m @
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
nnoremap <silent> <C-u>      :GundoToggle<CR>
vnoremap <silent> <C-u>      :GundoToggle<CR>
inoremap <silent> <C-u> <C-o>:GundoToggle<CR>
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
"	\|	if(g:colors_name == 'deus')
"	\|		highlight! Folded ctermbg=236
"	\|	endif
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
"	\|	if(g:colors_name == 'deus')
"	\|		highlight! Folded ctermbg=236
"	\|	endif
augroup END
" }}}
" Html and Php code {{{
augroup filetype_html_php	" auto commands for html and php code
	autocmd!
	autocmd filetype html,php
	\	setlocal shiftwidth=4
	\|	setlocal softtabstop=4
	\|	setlocal expandtab
	\|	setlocal foldmethod=indent
"	\|	if(g:colors_name == 'deus')
"	\|		highlight! Folded ctermbg=236
"	\|	endif
augroup END
" }}}
" Vim {{{
augroup filetype_vim		" autocommands for vim(script) files
	autocmd!
	autocmd filetype vim
	\	setlocal foldmethod=marker
	\|	setlocal foldtext=CustomMarkerFolding()
	\|	setlocal foldlevel=0
"	\|	if(g:colors_name == 'deus')
"	\|		highlight! Folded ctermbg=236
"	\|	endif
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
	\|	setlocal foldtext=CustomMarkerFolding()
	\|	setlocal foldlevel=0
	\|	if(g:colors_name == 'deus')
	\|		highlight! Folded ctermbg=235
	\|	endif
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
" Plugins {{{
" Toggle Nerdtree:	ctrl-n
" Toggle Undotree:	ctrl-u
" }}}
" Movement {{{
" Normal:		jklö
" Fast:			JKLÖ
" End Of Word:		e
" End Of Line:		E
" Begin Of Word:	b
" Begin Of Line:	B
" Page Scroll:		ctrl-kl
" }}}
" Tabs and Splits {{{
" Cycle Splits:		leader-s
" Cycle Tabs:		leader-t
" Other Split Commands:	leader-S
" Other Tab Commands:	leader-T
" }}}
" Undo and Redo {{{
" Undo:			u
" Redo:			U
" }}}
" }}}
