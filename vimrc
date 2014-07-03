" #Install {{{
    let neobundle_readme=expand('~/.vim/bundle/neobundle.vim/README.md')
    if !filereadable(neobundle_readme)
        echo "Installing neobundle ..."
	    echo ""
	    silent !mkdir -p ~/.vim/bundle ~/.vim/tmp/swap ~/.vim/tmp/backup
	    silent !git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
    endif

"}}}

" #Bundles {{{
if has('vim_starting')
    set nocompatible " Be iMproved

    
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

"}}}

NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \         'windows' : 'make -f make_mingw32.mak',
      \         'cygwin' : 'make -f make_cygwin.mak',
      \         'mac' : 'make -f make_mac.mak',
      \         'unix' : 'make -f make_unix.mak',
      \     },
      \ }


call neobundle#end()

set nu

filetype plugin indent on
syntax on

" colors
set t_Co=256

" tabs and spaces handling
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" mouse
set mouse=a
set mousehide 

" always show status bar
set ls=2

" Spase better
nmap <space> :

" When vimrc is edited, reload it
autocmd! BufWritePost .vimrc source ~/.vimrc

