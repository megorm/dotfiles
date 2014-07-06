" #Install {{{
    let neobundle_readme=expand('~/.vim/bundle/neobundle.vim/README.md')
    if !filereadable(neobundle_readme)
        echo "Installing neobundle ..."
	    echo ""
	    silent !mkdir -p ~/.vim/bundle ~/.vim/swap ~/.vim/undo
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

" Ultimate UI system for running fuzzy-search on different things {{{
NeoBundle 'Shougo/unite.vim'

let g:unite_enable_start_insert = 1
let g:unite_source_history_yank_enable = 1
let g:unite_split_rule = "botright"

" `ag` is a faster and better replacement for the standard `find`, let Unite
" use
" it if it exists and configure to properly use `.gitignore` or `.hgignore`
" files if those exist.
" To install `ag`: brew install ag
" or: https://github.com/ggreer/the_silver_searcher
if executable("ag")
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
    let g:unite_source_grep_recursive_opt = ''
endif

if exists("*unite")
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    call unite#filters#sorter_default#use(['sorter_rank'])
    call unite#set_profile('files', 'smartcase', 1)
endif
" }}}


" Auto-completion plugin integrated with Unite and vimshell {{{
NeoBundle 'Shougo/neocomplete.vim'

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#min_keyword_length = 3

" Plugin key-mappings
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return neocomplete#close_popup() . "\<CR>"
    " For no inserting <CR> key.
    return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction

" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplete#close_popup()
inoremap <expr><C-e> neocomplete#cancel_popup()
" Close popup by <Space>.
inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" No limit on the results of these searches
let g:unite_source_file_rec_max_cache_files = 0
call unite#custom#source('file_rec/async', 'max_candidates', 0)

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" }}}

" Snippets {{{
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"

smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif

" }}}

" Expand/shrink the visual selection by text-object blocks with `+` and `_` in
" the visual mode
NeoBundle 'terryma/vim-expand-region'

" Undo/Redo tree
NeoBundle 'sjl/gundo.vim'

" Insert/Delete brackets in pairs
NeoBundle 'jiangmiao/auto-pairs'

" Git wrapper
NeoBundle 'tpope/vim-fugitive'

" Fugitive menu in Unite (depends on both Fugitive and Unite.vim) {{{
let g:unite_source_menu_menus = {}
let g:unite_source_menu_menus.git = {}
let g:unite_source_menu_menus.git.description = 'git (Fugitive)'
let g:unite_source_menu_menus.git.command_candidates = [
    \['▷ git status (Fugitive)',
        \'Gstatus'],
    \['▷ git diff (Fugitive)',
        \'Gdiff'],
    \['▷ git commit (Fugitive)',
        \'Gcommit'],
    \['▷ git log (Fugitive)',
        \'exe "silent Glog | Unite quickfix"'],
    \['▷ git blame (Fugitive)',
        \'Gblame'],
    \['▷ git stage (Fugitive)',
        \'Gwrite'],
    \['▷ git checkout (Fugitive)',
        \'Gread'],
    \['▷ git rm (Fugitive)',
        \'Gremove'],
    \['▷ git mv (Fugitive)',
        \'exe "Gmove " input("destino: ")'],
    \['▷ git push (Fugitive, output buffer)',
        \'Git! push'],
    \['▷ git pull (Fugitive, output buffer)',
        \'Git! pull'],
    \['▷ git prompt (Fugitive, output buffer)',
        \'exe "Git! " input("comando git: ")'],
    \['▷ git cd (Fugitive)',
        \'Gcd'],
    \]
" }}}

" Different stuff in the menu (depends on Unite.vim) {{{
let g:unite_source_menu_menus.all = {}
let g:unite_source_menu_menus.all.description = 'All things'
let g:unite_source_menu_menus.all.command_candidates = [
    \['▷ gundo toggle undo tree', 'GundoToggle'],
    \['▷ save file', 'write'],
    \['▷ save all opened files', 'wall'],
    \['▷ make the current window the only one on the screen', 'only'],
    \['▷ open file (Unite)', 'Unite -start-insert file'],
    \['▷ open file recursively (Unite)', 'Unite -start-insert file_rec/async'],
    \['▷ open buffer (Unite)', 'Unite -start-insert buffer'],
    \['▷ open directory (Unite)', 'Unite -start-insert directory'],
    \['▷ toggle the background color', 'ToggleBG'],
    \['▷ open the shell (VimShell)', 'VimShell'],
    \['▷ open a new shell (VimShell)', 'VimShellCreate'],
    \['▷ open a new shell in a tab (VimShell)', 'VimShellTab'],
    \['▷ open a node interpreter (VimShell)', 'VimShellInteractive node'],
    \['▷ install bundles (NeoBundleInstall)', 'NeoBundleInstall'],
    \['▷ clean bundles (NeoBundleClean)', 'NeoBundleClean'],
    \['▷ update bundles (NeoBundleUpdate)', 'NeoBundleUpdate'],
    \]
" }}}

" A lot of shortcuts for next/prev navigation, usually is [x and ]x for moving
" back and forth for X
NeoBundle 'tpope/vim-unimpaired'

" Surrond plugin! Surrond text with a pair of anything (s in normal) "{{{
NeoBundle 'tpope/vim-surround'
"}}}

" Syntax definitions "{{{
NeoBundle "slava/vim-spacebars"
NeoBundle "groenewege/vim-less"
NeoBundle "elzr/vim-json"
NeoBundle "tpope/vim-markdown"
NeoBundle "pangloss/vim-javascript"
NeoBundle "leafgarland/typescript-vim"
NeoBundle "kchmck/vim-coffee-script"
NeoBundle "hdima/python-syntax"
"}}}

" Vim JS autocompletion with type hints "{{{
NeoBundle 'marijnh/tern_for_vim'
let g:tern_show_argument_hints = 'on_move'
"}}}

" OMG OMG, shell in my VIM {{{
NeoBundle "Shougo/vimshell"
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_prompt = '$ '
" open new splits actually in new tab
let g:vimshell_split_command = "tabnew"

if has("gui_running")
  let g:vimshell_editor_command = "mvim"
endif
"}}}

" ##Visual
" Prettiness on the bottom {{{
" That weird colorful line on the bottom
NeoBundle "bling/vim-airline"
let g:airline_theme='tomorrow'
set laststatus=2
set encoding=utf-8
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1

function! AirlineOverride(...)
  let g:airline_section_a = airline#section#create(['mode'])
  let g:airline_section_b = airline#section#create_left(['branch'])
  let g:airline_section_c = airline#section#create_left(['%f'])
  let g:airline_section_y = airline#section#create([])
endfunction
autocmd VimEnter * call AirlineOverride()
" }}}

" Visually sets marks
NeoBundle "kshenoy/vim-signature"

" Colorscheme {{{
NeoBundle "Slava/vim-colors-tomorrow"
NeoBundle "tomasr/molokai"
set t_Co=256
let g:tomorrow_termcolors = 256
let g:tomorrow_termtrans = 0 " set to 1 if using transparant background
let g:tomorrow_diffmode = "high"
"let g:molokai_original = 1

try
  colorscheme tomorrow
catch
" we don't have this theme or it throws
endtry

set background=light
" }}}

call neobundle#end()

set nu

filetype plugin indent on
syntax on

set ruler
set cursorline

" Trailing
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:.
set showbreak=↪

" tabs and spaces handling
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" ##Search tweaks {{{
    set hlsearch
    set incsearch
    " Kill current search
    nnoremap <silent> <Leader>/ :nohlsearch<CR>
" }}}

" Wildmenu
set wildmenu
set wildmode=longest:full,full

" Identation
vnoremap < <gv
vnoremap > >gv
set autoindent

" Buffers tweaks
" Allow to switch from changed buffer
set hidden

" Splits tweaks {{{
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

set splitbelow
set splitright
" }}}

" Wrapping tweaks "{{{
set wrap
set linebreak
set textwidth=80
set formatoptions=cq
" }}}"

" Save undo history persistently on disk, takes extra space "{{{
if has('persistent_undo')
    set undofile
    set undodir=~/.vim/undo/
    set undolevels=100
    set undoreload=3000
endif
"}}}

" Gaming swap files "{{{
silent !mkdir ~/.vim/swap > /dev/null 2>&1
set backupdir=~/.vim/swap/
set directory=~/.vim/swap/
" }}}

" mouse
set mouse=a
set mousehide


let mapleader = ","

" Spase better
nmap <space> :

" Show/hide invisibles by <leader>l
nnoremap <leader>l :set list!<CR>

" Tab movements
nnoremap <leader>m :tabn<CR>
nnoremap <leader>n :tabp<CR>

" Save file quickly
nnoremap <leader>w :w<CR>

" When vimrc is edited, reload it
autocmd! BufWritePost .vimrc source ~/.vimrc

