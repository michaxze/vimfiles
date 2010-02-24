" Runtime load bundle directory
call pathogen#runtime_prepend_subdirectories(expand('~/.vim/bundles'))
call pathogen#runtime_append_all_bundles()

" Disable vi compatibility
set nocompatible

" No need for the Error Bell in any form, thanks
set noerrorbells
set novisualbell
 
" Use filetype appropriate indent
filetype plugin indent on
 
" Automatically indent
set autoindent
set smartindent
 
" Always try and do syntax highlighting
syntax on

" Use spaces instead of tabs at the start of the line
set smarttab
set expandtab

" No backups
set nobackup

" Always show line numbers
set number
 
" Reset the window title in non-GUI mode to something a little more helpful.
set title

" Set to auto read when a file is changed from an external source
set autoread
 
" Use a manual foldmethod so that folds persist in files
set foldmethod=marker
 
" Tab completion in command mode shows all possible completions, shell style.
set wildmenu
set wildmode=list:longest

" A split will default to being creating under or to the right of the current.
set splitbelow splitright

" Make backspace work in insert mode
set backspace=indent,eol,start

" Make NERDCommenter add a space before/after comments
let NERDSpaceDelims=1

" Let Syntastic throw down error gang signs
let g:syntastic_enable_signs=1

" Set map leader
let mapleader = ","

" theme
set background=dark
if has("gui_running")
  colorscheme slate
  set columns=101 lines=60
  set transparency=8
endif
 
set guifont=Monaco:h15

" My anal whitespace rules and commands {{{

" Show trailing whitespace as little blue dots, and also make hard tabs visible.
" set list listchars=tab:>·,trail:·

" Catch trailing whitespace ,s
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" Command to collapse all multi-line occurrences of whitespace into one line.
cabbrev dpcompact %s/^\n\+/\r/

" Command to trim any trailing whitespace from lines.
cabbrev dpunwhite %s/\s\+$//

" }}}

" Custom normal/insert mode mappings {{{
 
" Remap jj or jk or to be the same as Esc to leave Insert mode.
imap ii <Esc>
 
" Map ,, and ;; to insert/append a single character
" Found at VimTips Wiki: http://vim.wikia.com/wiki/Insert_a_single_character
nmap ,, i_<esc>r
nmap ;; a_<esc>r
 
" Create directional shortcuts for moving among between splits
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-l> <C-W>l
nmap <C-h> <C-W>h
 
" Make it easy to update/reload .vimrc
nmap <leader>s :source ~/.vimrc<CR>
nmap <leader>vi :tabe ~/.vimrc<CR>

" }}}

" Search Related options {{{
 
" Highlight searched terms
set hlsearch
 
" bind \ to clear highlighting, though search term remains and 'n' works
map <silent> \ :silent nohlsearch<CR>
 
" Use incremental search
set incsearch
 
" Searches are case insensitive, unless upper case letters are used
set ignorecase
set smartcase
 
" Jamis Buck's plugin for FuzzyFinder that is TextMate-esque
" http://github.com/jamis/fuzzyfinder_textmate/tree/master
map <leader>t :FuzzyFinderTextMate<CR>
 
" Use ack instead of grep
set grepprg=ack
 
" Fancy 'Ack' command to search through the whole current directory
" and open up a new quickfix window with the results.
" source: http://blog.ant0ine.com/2007/03/ack_and_vim_integration.html
" function! Ack(args)
" let grepprg_bak=&grepprg
" set grepprg=ack\ -H\ --nocolor\ --nogroup
" execute "silent! grep " . a:args
" botright copen
" let &grepprg=grepprg_bak
" endfunction
" command! -nargs=* -complete=file Ack call Ack(<q-args>)
 
" Search for visually selected text using */#, basically identically
" to how it's done in non-visual mode.
" Source: http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
        \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
        \gvy/<C-R><C-R>=substitute(
        \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
        \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
        \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
        \gvy?<C-R><C-R>=substitute(
        \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
        \gV:call setreg('"', old_reg, old_regtype)<CR>
 
" }}}
 
" Language Options {{{

autocmd FileType ruby set omnifunc=rubycomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS


" }}}

" Ruby specific options {{{
 
" This will highlight trailing whitespace and tabs preceded by a space character
let ruby_space_errors = 1
 
" Syntax highlight ruby operators (+, -, etc)
let ruby_operators = 1
 
" Ruby Autocomplete stuff
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
 
" Specky bindings {{{
let g:speckyRunRdocKey = ",sr"
let g:speckySpecSwitcherKey = ",sx"
let g:speckyRunSpecKey = ",ss"
let g:speckyVertSplit = 1
" TODO: What is this app?
" let g:speckyRunRdocCmd = "fri -L -f plain"
" }}}
 
" }}}
 
" rails.vim specific options {{{
 
" Have a separate Rails menu in gvim
let g:rails_menu=2
 
" have rails.vim by default edit database.yml, not the README
let g:rails_default_file='config/routes.rb'
 
" use Safari to preview
"command -bar -nargs=1 OpenURL :!open <args>

" Turn off rails bits of statusbar
let g:rails_statusline=0

" NERDTree {{{
  let NERDChristmasTree = 1
  let NERDTreeHighlightCursorline = 1
  let NERDTreeShowBookmarks = 1
  let NERDTreeShowHidden = 1
  let NERDTreeIgnore = ['.vim$', '\~$', '.svn$', '\.git$', '.DS_Store']
  nmap <F2> :NERDTreeToggle<CR>
  map nt :NERDTreeToggle<CR>
" }}}

" TagList {{{
  let Tlist_GainFocus_On_ToggleOpen = 1
  let Tlist_Process_File_Always = 1
  let Tlist_Inc_Winwidth = 0
  let Tlist_Enable_Fold_Column = 0 "Disable drawing the fold column
  let Tlist_Use_SingleClick = 1 "Single click tag selection
  let Tlist_Use_Right_Window = 1
  let Tlist_Exit_OnlyWindow = 1 "Exit if only the taglist is open
  let Tlist_File_Fold_Auto_Close = 1 " Only auto expand the current file
  let Tlist_Ctags_Cmd = '/opt/local/bin/ctags'
  nmap <F3> :TlistToggle<CR>
  " nmap <F4> :BufExplorer<CR>
  " nmap <F5> :bw<CR>
" }}}

" GUI related options {{{
 
" Don't show me a toolbar in a GUI Version of Vim
set guioptions-=T
 
" Don't show scrollbars
set guioptions-=r
set guioptions-=L
set guioptions-=T
 
" Use console dialogs in GUI Vim, the dialogue boxes are just silly
if has("gui_gtk")
  set guioptions+=c
endif
 
" }}}

" Status Line {{{

set laststatus=2
set statusline=\ "
set statusline+=%f\ " file name
set statusline+=[
set statusline+=%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&fileformat}] " file format
set statusline+=%h%1*%m%r%w%0* " flag
set statusline+=%{fugitive#statusline()} " git status
set statusline+=%= " right align
set statusline+=%-14.(%l,%c%V%)\ %<%P " offset
" Title: update the title of the window?
set title
" Title String: what will actually be displayed
set titlestring=VIM:\ %-25.55F\ %a%r%m titlelen=70

" }}}

