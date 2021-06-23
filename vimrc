"	my vimrc file.
"
"	vimrc locations:
"	for MS-Windows:  ~/vimfiles/_vimrc; VIM=%USERPROFILE%\vim\vim8x.
"	for Unix/cygwin:  symlink as ~/.vimrc and ~/.vim.

"	Get the defaults that most users want.  TODO: already autoloaded?
source $VIMRUNTIME/defaults.vim

"	core settings, in case a plugin borks or stuck in bad vbox term.
set ts=4 sts=4 sw=4 noet nobk nowb tw=120 nowrap
let g:python_recommended_style = 0
syntax on

" *************************** PLUGINS **************************

set rtp+=~/.vim/autoload/plug.vim
"	set plug='~/.vim/autoload/plug.vim'
"	set rtp+=$plug
"	TODO: add curl cmd to download plug.vim and plug.txt
"		curl -O $plug https://TBS.github.com/TBS/plug.vim
"		curl -O ~/.vim/doc/plug.txt https://TBS.github.com/TBS/plug.txt
"	unset plug

"	filetype off; done by plug#begin().
"	plug.vim requires git and github access.
call plug#begin('~/.vim/plugged')	" make default dir explicit
"	get the plug binary.
Plug 'junegunn/fzf'
"	fzf-vim also adds :Ag and :Rg
Plug 'junegunn/fzf-vim'
"	colorizer now does stuff I don't want, so vim-css-color.
Plug 'ap/vim-css-color'
"	alternate between hdr/code files; [ch]{,xx,pp}, [._]ada, .ad[sb], etc.
Plug 'vim-scripts/a.vim'
"	colors tsv files; use vts on modeline to set col width.
Plug 'mechatroner/rainbow_csv'
"	html/xml/xsl & css
Plug 'mattn/emmet-vim'
"	neovim only.
"	if executable('nvim') then
"	Plug 'pgdouyon/vim-accio'		" compile/make.  lighter than neomake.
"	endif
"	color scheme goes last.
Plug 'vim-scripts/darkblack.vim'
call plug#end()

" filetype plugin indent on; done by plug#end().

" rainbow_csv comment char
let g:rainbow_comment_prefix="#"

"	load each plugin cfg file
"	for cfg in glob(~/.vim/*.cfg.vim)
"		source cfg
"	end

" *********************** END PLUGINS **************************

"	FZF plugin also has :AG and :RG, but not always available.
if executable('rg')
	set grepprg=rg\ --vimgrep
	set grepformat^=%f:%l:%c:%m
elif executable('ag'):
	"ag data includes col no; in quickfix buffer format.
	" TODO: put data in qf buffer
	set grepprg=ag\ --vimgrep
endif

if has('persistent_undo')
	" don't keep an undo file (undo changes after closing).  FS litter.
	set noundofile
endif

"	Switch on highlighting the last used search pattern.  annoying.
"	if &t_Co > 2
"	  set hlsearch
"	endif

" strip trailing ws. star is a glob, so it can be fname-based.
" to not strip "test*" files, change * to [^\(test\)]* .
autocmd BufWritePre * %s/\s\+$//e

" Put these in an autocmd group, so that we can delete them easily.  TODO: why?
augroup vimrcEx
  au!
  " For all text files set 'textwidth' to 120 characters.
  autocmd FileType text setlocal textwidth=120 nowrap
augroup END

" matchit plugin improves % command, but not backwards compatible (7.x?).
" bang "!" means plugin won't be loaded here, but during initialization (after rc finishes).
if has('syntax') && has('eval')
  packadd! matchit
endif

"	----------------------------------------------------------------------------------

" do not keep a backup file
set nobackup nowritebackup

syntax on

" tabs, god damn it!
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

" disable all the damn pep crap.
let g:python_recommended_style = 0

"	for TSV vts values.
set modeline
set modelines=2
set nomodelineexpr

" use true terminal colors (neovim and vim 8).
set termguicolors

"	vim7: force 256 colors in gui AND in console.  ignored by neovim.
" set t_Co=256

" console font is some monospace:14; guifont in .gvimrc.

set belloff=all		" no beeps or blinks

" show all non-printable chars (>0x7e) as hex "<xx>"
" FIXME: set encoding=latin1/ascii fails.
set isprint=
set display+=uhex
syntax match nonascii "[\x7f-\xff]"
highlight nonascii guifg=White guibg=Red cterm=underline ctermfg=8 ctermbg=9

" disable all comment autoinsertion.
" TODO: test this.
" TODO: bind key to toggle on/off
" autocmd Filetype * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" mapleader = SEMICOLON.  home row, but uncommon compared to space/comma/dot.
let mapleader=';'

" set shiftround		always indent shiftwidth * i.  only if softtabstop!=0
"set copyindent
set preserveindent

" no viminfo file
set viminfo=

set textwidth=120
set colorcolumn=80
set nowrap

" TODO: set formatoptions=qrn1
" set title titlestring=%F

" disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" disable F1 help key.  bumped too often when hitting escape.
inoremap <F1> <nop>
nnoremap <F1> <nop>
vnoremap <F1> <nop>

map F8 !python %
map F9 !make
map F10 :retab!			" tabify

" reformat all paras in file to 70 wide.  from vim help.
" only used on word/html text dumps.
map F12 set tw=70gggqG

" netrw keeps a history file under ~/.vim/ dir.  AARGH!
" disable history, relocate it to ~/.cache, and delete if found.
let g:netrw_dirhistmax = 0
let g:netrw_home="~/.cache/vim"		" TODO: check for cache dir.
" TODO: chokes on ~ and HOME
" au VimLeave * if filereadable("~/.vim/.netrwhist") call delete("~/.vim/.netrwhist") endif

" nvim can't find colorscheme.  2015 bug; still there 2016/12/13.
" at end s.t. all other options load.
if !has("nvim")
	colorscheme darkblack
endif

" highlight hides syntax colors.
" highlight current line (easier to find cursor):
"	set cursorline
"	hi cursorline cterm=none term=none
"	autocmd WinEnter * setlocal cursorline
"	autocmd WinLeave * setlocal nocursorline
"	highlight CursorLine guibg=#303000 ctermbg=234
hi clear CursorLine
hi CursorLine ctermbg=black guibg=black gui=underline cterm=underline
set cursorline

augroup setgenie
  au!
  au BufNewFile *.gs setlocal filetype="genie"
  au BufRead *.gs setlocal filetype="genie"
augroup END

"	look for tags files from cwd up to home.
set tags+=./tags;$HOME

"	end
