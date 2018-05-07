"##################################  TODO  ####################################"
"[ ] text fold funtion for python
"[ ] change c text fold function to (also rename it):
"    "foo bar(baz){}-----------------------420 lines"
"    [ ] add function to create string of given length with specifiv character
"[ ] make vimrc fold like bit.ly/2JVSYri
"    [ ] in .vimrc (or general in all .*rc) use marker folding
"    [ ] reorder vimrc:
"        TODO,   GENERAL,   UI,   TOOLS(searching, folding),   EDITING COMMANDS,
"        MOVEMENT, PLUGINS
"[ ] fix colorschemes (redownload repos and put into bundles)
"[ ] add plugins
"[ ] add cheatsheet for commands


"################################  GENERAL  ###################################"
let mapleader=','	" set leader key
filetype on		" enable filetype detection
set lazyredraw		" redraw only when needed
set autochdir		" use file path as working directory
set confirm		" ask to save instead of complaining
set listchars=		" empty listchars list
			" use glorious zsh
if !empty(glob("/usr/bin/zsh"))
	set shell=/usr/bin/zsh
endif


"###############################  FUNCTIONS  ##################################"
			" get current git branch
function! GetGitBranch()
	return system(
\	"git rev-parse --abbrev-ref HEAD 2> /dev/null | tr -d '\n'")
endfunction
			" display branch only if there is one (for statusline)
function! DisplayGitBranch()
	let l:branchname = GetGitBranch()
	return (strlen(l:branchname) > 0) ? ' Branch:'.l:branchname : ''
endfunction


"################################  PLUGINS  ###################################"
filetype plugin on
"********************************  PATHOGEN  **********************************"
call pathogen#infect()
"********************************  NERDTree  **********************************"
			" toggle NERDTree
nnoremap <silent> <C-n>      :NERDTreeToggle<CR>
vnoremap <silent> <C-n>      :NERDTreeToggle<CR>
inoremap <silent> <C-n> <C-o>:NERDTreeToggle<CR>
augroup plugin_nerdtree
	autocmd!
			" Close NERDTree if its the only buffer left
	autocmd bufenter *
	\	if(winnr("$") == 1
	\	&& exists("b:NERDTree")
	\	&& b:NERDTree.isTabTree())
	\|		q
	\|	endif
augroup END
"********************************  AIRLINE  ***********************************"
			" function to update airline statusline
function! UpdateAirline()
	let g:current_git_branch = DisplayGitBranch()
endfunction
augroup plugin_airline
	autocmd!
			" to update git branch in status line
	autocmd vimenter     * let g:current_git_branch = DisplayGitBranch()
	autocmd shellcmdpost * let g:current_git_branch = DisplayGitBranch()
			" disable the AirlineToggleWhitespace in the airline
	autocmd vimenter *
	\	silent!
	\|	AirlineToggleWhitespace
	\|	redraw!
augroup END
			" use powerline fonts
let g:airline_powerline_fonts = 1
			" use deus airline theme
let g:airline_theme = 'deus'
			" custom statusline (see bit.ly/2rnzq8G)
let g:airline_section_b = '%F %m%r%h%y'
let g:airline_section_c = ''
let g:airline_section_x = 'File:%t'
let g:airline_section_x.= '%{g:current_git_branch}'
let g:airline_section_y = 'Ln:%l/%L Col:%c'
let g:airline_section_z = '%3l|%-2c'
"*********************************  GUNDO  ************************************"
nnoremap <silent> <C-g>      :GundoToggle<CR>
vnoremap <silent> <C-g>      :GundoToggle<CR>
inoremap <silent> <C-g> <C-o>:GundoToggle<CR>
if has('python3')	" use python 3 if available
	let g:gundo_prefer_python3 = 1
endif
			" map movement keys to the right (QWERTZ keyboard)
let g:gundo_map_move_newer = 'l'
let g:gundo_map_move_older = 'k'
			" close  undo tree  when  focus  is returned  to another
			" window
let g:gundo_return_on_revert = 1


"################################  VISUALS  ###################################"
syntax on		" enable syntax highlighting
colorscheme deus	" nice gruvbox-like colorscheme
set title		" rename terminal
set showmatch		" show matching brace
set scrolloff=5		" keep at least 5 lines above and below cursor
set sidescrolloff=7	" keep at least 7 characters left and right from cursor
set cursorline		" highlight current line
set list		" show unprintable characters in listchars
set number		" show line number
set background=dark	" nightmode
set listchars+=trail:•	" show trailing spaces
set nowrap		" dont wrap lines
set colorcolumn=81	" highlight 81st line grey
			" highlight 81st char in a line red
highlight OverLength ctermbg=red ctermfg=lightgrey
match OverLength /\%81v.\+/


"################################  FOLDING  ###################################"
set foldcolumn=5	" add column for fold information
set foldmethod=syntax	" fold lines syntax-based
set foldlevelstart=4	" start with 4 nested open folds
			" toggle folds fast
nnoremap <leader>f za
"****************************  CUSTOM TEXT FOLD  ******************************"
function! CustomTextFold()
	" force syntax folding
	set! foldmethod=syntax

	" get start and end
	let start_line = getline(v:foldstart)
	let end_line = getline(v:foldend)

	" Get each component
	let start = substitute(
		start_line,
		'^\([ \t]*\)\([^{]\+\){',
		'\1\2',_'')
	let num_lines = v:foldend - v:foldstart + 1
	if num_lines == 1
		let line = "line"
	else
		let line = "lines"
	endif

	" return complete line
	return start . "{ " . num_lines . " " . line . " }"
endfunction


"###############################  SEARCHING  ##################################"
			" turn off search highlight
nnoremap <silent> <leader>s :nohlsearch<CR>
set incsearch		" search as charcters are entered
set hlsearch		" highlight matches
set ignorecase		" ignore case when searching
set smartcase		" (with  ignorecase)   only  casesensitive  when  querry
			" contains capital letters


"#################################  MOUSE  ####################################"
set mouse=a		" enable the mouse (to disable mouse scroll)
set mousehide		" hide the cursor
			" disable mouse wheel scroll
map <ScrollWheelUp> <nop>
map <S-ScrollWheelUp> <nop>
map <C-ScrollWheelUp> <nop>
map <ScrollWheelDown> <nop>
map <S-ScrollWheelDown> <nop>
map <C-ScrollWheelDown> <nop>


"##############################  INDENTATION  #################################"
set autoindent		" copy indentation of previous line
set listchars=tab:>-	" show only tabs
set tabstop=8		" should not be changed
"*******************************  FILE TYPE  **********************************"
filetype indent on	" enable loading indent files
augroup filetype_c	" for C code
	autocmd!
	autocmd filetype c
	\	setlocal shiftwidth=8
	\|	setlocal softtabstop=8
	\|	setlocal noexpandtab
	\|	setlocal listchars+=tab:\|\ 
	\|	setlocal foldmethod=syntax
	\|	setlocal foldtext=CustomTextFold()
augroup END
augroup filetype_python	" for Python code
	autocmd!
	autocmd filetype python
	\	setlocal shiftwidth=4
	\|	setlocal softtabstop=4
	\|	setlocal expandtab
	\|	setlocal foldmethod=indent
augroup END


"############################  EDITING COMMANDS  ##############################"
"*******************************  NORMALMODE  *********************************"
			" insert single character with s/S
nnoremap s i_<Esc>r
nnoremap S a_<Esc>r
			" shift + undo = redo
nnoremap U <C-R>
"*******************************  INSERTMODE  *********************************"
set backspace=2		" backspace over everything
			" when opening new files, start in insert
augroup start_in_insert
	autocmd!
	autocmd bufnewfile * startinsert
augroup END
"*******************************  VISUALMODE  *********************************"
set ttimeoutlen=10	" no delay when quitting visual mode with <Esc>



"################################  MOVEMENT  ##################################"
			" better tag-following in help
nnoremap <C-f> <C-]>
"*********************************  CURSOR  ***********************************"
			" map  movement  characters  one to  the  right  (QWERTZ
			" keyboard)
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
			" move in line when capital (in normal and visual)
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
"**********************************  PAGE  ************************************"
			" scroll with <C-k/l>
nnoremap <C-l>      <C-e>
nnoremap <C-k>      <C-y>
vnoremap <C-l>      <C-e>
vnoremap <C-k>      <C-y>
inoremap <C-l> <C-o><C-e>
inoremap <C-k> <C-o><C-y>
"*********************************  SPLITS  ***********************************"
set splitright		" open new splits on the right
			" cycle through spilts
nnoremap <C-c>      <C-w>w
onoremap <C-c>      <C-w>w
inoremap <C-c> <C-o><C-w>w
			" easier navigations
nnoremap <C-W>j <C-W>h
nnoremap <C-W>k <C-W>j
nnoremap <C-W>l <C-W>k
nnoremap <C-W>ö <C-W>l
"**********************************  TABS  ************************************"
nnoremap <silent> <m-c>      :tabnext<CR>
vnoremap <silent> <m-c>      :tabnext<CR>
inoremap <silent> <m-c> <C-o>:tabnext<CR>
