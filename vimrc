" Author: John Anderson (sontek@gmail.com)
" Modificacions: Antoni Aloy (aaloy@apsl.net)
" Afegit : http://github.com/skyl/vim-config-python-ide/blob/supertab/.vimrc
" Afegit :  http://code.google.com/p/pycopia/source/browse/trunk/vim/vimfiles/vimrc.vim
" Tested with vim7
"
" 5/04/2010  - Added tComment from  http://www.vim.org/scripts/script.php?script_id=1173
"            - Added better tab completion (test shift+tab)
"            - Added markdown syntax
"            - Added additional colour themes
" 5/04/2010  - Merged with http://amix.dk/vim/vimrc.html
" 26/04/2010 - Change surround
"			   Better match it
"			   Updated vcs plugin
"
" 8/07/2010  - Merges from  http://github.com/JoseBlanca/vim-for-python/blob/master/vimrc
" 19/11/2010 - Added advices from  http://items.sjbach.com/319/configuring-vim-right
"
" ----------------------------------------------------------------------------------

set hidden
let mapleader = ","
set encoding=utf-8
set ffs=unix,dos,mac "Default file types

"Set backup to a location
set backup
set backupdir=$HOME/temp/vim_backups/,~/tmp,/var/tmp,/tmp
set directory=$HOME/temp/vim_swp/,~/tmp,/var/tmp/tmp
set noswapfile

" Establim els amples de tabulació

au BufRead,BufNewFile *.py  set ai sw=4 sts=4 et tw=72 " Doc strs
au BufRead,BufNewFile *.js  set ai sw=2 sts=2 et tw=72 " Doc strs
au BufRead,BufNewFile *.html set ai sw=2 sts=2 et tw=72 " Doc strs
au BufRead,BufNewFile *.json set ai sw=4 sts=4 et tw=72 " Doc strs
au BufNewFile *.html,*.py,*.pyw,*.c,*.h,*.json set fileformat=unix
au! BufRead,BufNewFile *.json setfiletype json 

let python_highlight_all=1
syntax on

" Bad whitespace
highlight BadWhitespace ctermbg=red guibg=red
" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" OO
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

filetype plugin on
set iskeyword+=.

"" Skip this file unless we have +eval
if 1

""" Settings 
set nocompatible						" Don't be compatible with vi

"""" Movement
" work more logically with wrapped lines
noremap j gj
noremap k gk

"""" Searching and Patterns
set ignorecase							" search is case insensitive
set smartcase							" search case sensitive if caps on 
set incsearch							" show best match so far
set hlsearch							" Highlight matches to the search 

"""" Display
set background=dark						" I use dark background
set lazyredraw							" Don't repaint when scripts are running
set scrolloff=3							" Keep 3 lines below and above the cursor
set ruler								" line numbers and column the cursor is on
set number								" Show line numbering
set numberwidth=1						" Use 1 col + 1 space for numbers
set ttyfast

if has("gui_running")
	syntax enable
	set t_Co=256
	set hlsearch
	set clipboard=autoselect
	set guioptions+=T
	set toolbar=icons,tooltips
	colorscheme wombat					"or blackboard
	"set guifont=DejaVu\ Sans\ Mono
	set guifont=Inconsolata\ Medium\ 12
	set nu
else
	colorscheme tango
endif


" tab labels show the filename without path(tail)
set guitablabel=%N/\ %t\ %M

""" Windows
if exists(":tab")						" Try to move to other windows if changing buf
set switchbuf=useopen,usetab
else									" Try other windows & tabs if available
	set switchbuf=useopen
endif

"""" Messages, Info, Status
set shortmess+=a						" Use [+] [RO] [w] for modified, read-only, modified
set showcmd								" Display what command is waiting for an operator
set laststatus=2						" Always show statusline, even if only 1 window
set report=0							" Notify me whenever any lines have changed
set confirm								" Y-N-C prompt if closing with unsaved changes
set vb t_vb=							" Disable visual bell!  I hate that flashing.
set statusline=%<%f%m%r%y%=%b\ 0x%B\ \ %l,%c%V\ %P
set laststatus=2  " always a status line


"""" Editing
set backspace=2							" Backspace over anything! (Super backspace!)
set matchtime=2							" For .2 seconds
set formatoptions-=tc					" I can format for myself, thank you very much
set nosmartindent
"set autoindent
set cindent
set tabstop=4							" Tab stop of 4
set shiftwidth=4						" sw 4 spaces (used on auto indent)
set softtabstop=4						" 4 spaces as a tab for bs/del
set matchpairs+=<:>						" specially for html
"set showmatch							" Briefly jump to the previous matching parent


"""" Coding
set history=1000						" 100 Lines of history
set showfulltag							" Show more information while completing tags
filetype plugin indent on				" Let filetype plugins indent for me

" set up tags
set tags=tags;~/
set tags+=$HOME/.vim/tags/python.ctags

""""" Folding
set foldmethod=indent					" By default, use indent to determine folds
set foldlevelstart=99					" All folds open by default
set nofoldenable

"""" Command Line
set wildmenu							" Autocomplete features in the status bar
set wildmode=longest:full,list
set wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn

"""" Autocommands
if has("autocmd")
augroup vimrcEx
au!
	" In plain-text files and svn commit buffers, wrap automatically at 78 chars
	au FileType text,svn setlocal tw=78 fo+=t

	" In all files, try to jump back to the last spot cursor was in before exiting
	au BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "normal g`\"" |
		\ endif

	" Use :make to check a script with perl
	au FileType perl set makeprg=perl\ -c\ %\ $* errorformat=%f:%l:%m

	" Use :make to compile c, even without a makefile
	au FileType c,cpp if glob('Makefile') == "" | let &mp="gcc -o %< %" | endif

	" Switch to the directory of the current file, unless it's a help file.
	au BufEnter * if &ft != 'help' | silent! cd %:p:h | endif

	" Insert Vim-version as X-Editor in mail headers
	au FileType mail sil 1  | call search("^$")
				 \ | sil put! ='X-Editor: Vim-' . Version()
	" smart indenting for python
	au FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
	autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
	set iskeyword+=.,_,$,@,%,#
	au FileType python set expandtab
	" setup file type for snipmate
	"--------------------------------------------------------------------------
	au FileType python set ft=python.django
	au FileType xhtml set ft=htmldjango.html
	au FileType html set ft=htmldjango.html

	" kill calltip window if we move cursor or leave insert mode
	au CursorMovedI * if pumvisible() == 0|pclose|endif
	au InsertLeave * if pumvisible() == 0|pclose|endif
	
	autocmd FileType python set omnifunc=pythoncomplete#Complete
	autocmd FileType python.django set omnifunc=pythoncomplete#Complete
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType htmldjango.html set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS

	augroup END
endif

"""" Key Mappings
" bind ctrl+space for omnicompletion
inoremap <Nul> <C-x><C-o>
imap <c-space> <C-x><C-o>

" Toggle the tag list bar
nmap <F4> :TlistToggle<CR>
nmap <F8> :NERDTreeToggle<CR>

"Format 
au FileType xml map <F9> :silent 1,$!xmllint --format --recover - 2>/dev/null<CR>
" tab navigation (next tab) with alt left / alt right

if &diff
" easily handle diffing 
   vnoremap < :diffget<CR>
   vnoremap > :diffput<CR>
   vnoremap j :[c
   vnoremap k :]c
else
" visual shifting (builtin-repeat)
   vnoremap < <gv                       
   vnoremap > >gv 
endif

" Extra functionality for some existing commands:
" <C-6> switches back to the alternate file and the correct column in the line.
nnoremap <C-6> <C-6>`"

" CTRL-g shows filename and buffer number, too.
nnoremap <C-g> 2<C-g>

" <C-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Q formats paragraphs, instead of entering ex mode
noremap Q gq

" * and # search for next/previous of selected text when used in visual mode
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>

" <space> toggles folds opened and closed
nnoremap <space> za

" <space> in visual mode creates a fold over the marked range
vnoremap <space> zf

" allow arrow keys when code completion window is up
inoremap <Down> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>

""" Abbreviations
function! EatChar(pat)
	let c = nr2char(getchar(0))
	return (c =~ a:pat) ? '' : c
endfunc

endif

" Taglist variables
" Display function name in status bar:
let g:ctags_statusline=1
" Automatically start script
let generate_tags=1
" Displays taglist results in a vertical window:
let Tlist_Use_Horiz_Window=0
" Shorter commands to toggle Taglist display
nnoremap TT :TlistToggle<CR>
map <F4> :TlistToggle<CR>
" Various Taglist diplay config:
let Tlist_Use_Right_Window = 1
let Tlist_Compact_Format = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_File_Fold_Auto_Close = 1


" Let abbreviations be in its own file
" ------------------------------------

if filereadable(expand("~/.vim/abbr"))
	source ~/.vim/abbr
endif

"Delete trailing white space, useful for Python ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cope
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Do :help cope if you are unsure what cope is. It's super useful!
map <leader>cc :botright cope<cr>
map <leader>n :cn<cr>
map <leader>p :cp<cr>
" just subsitute ESC with ,
map <leader> ,

"fast copy

nmap <leader>y "*y
nmap <leader>Y "yy
nmap <leader>p "*p
nmap <leader>0 "0p
nmap <leader>1 "1p
nmap <leader>2 "2p
nmap <leader>3 "3p
nmap <leader>4 "4p
nmap <leader>5 "5p
nmap <leader>6 "6p
nmap <leader>7 "7p
nmap <leader>8 "8p
nmap <leader>9 "9p
"show registers
nmap <leader>r :registers<CR>

" movement remaps
" ------------------------------------------
"
nnoremap  <a-right>  gt
nnoremap  <a-left>   gT

" Ctrl + Arrows - Move around quickly
nnoremap  <c-up>     {
nnoremap  <c-down>   }
nnoremap  <c-right>  El
nnoremap  <c-down>   Bh

" Shift + Arrows - Visually Select text
nnoremap  <s-up>     Vk
nnoremap  <s-down>   Vj
nnoremap  <s-right>  vl
nnoremap  <s-left>   vh

nnoremap ' `
nnoremap ` '

"pyflakes gives me probles on Linux PPC and quickfix, so just 
"deactivate quickfix use with pyflakes
let g:pyflakes_use_quickfix = 0

