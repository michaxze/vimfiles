  scriptencoding utf-8
 
" Change <Leader>
  let mapleader = ","
 
" set hidden to not loose undo history
  set hidden
 
" Set temporary directory (don't litter local dir with swp/tmp files)
  set directory=/tmp/
 
" When scrolling off-screen do so 3 lines at a time, not 1
  set scrolloff=3
 
" These two enable syntax highlighting
  set nocompatible
  syntax on
  
" have one hundred lines of command-line (etc) history:
  set history=100
 
" Show us the command we're typing
  set showcmd
 
" Highlight matching parens
  set showmatch
  set completeopt=menu,preview
  
" Use the tab complete menu
  set wildmenu
  set wildmode=list:longest,full
 
" have the mouse enabled all the time:
  set mouse=a
 
" * Text Formatting -- General
 
" don't make it look like there are line breaks where there aren't:
  set nowrap
 
" use indents of 2 spaces, and have them copied down lines:
  set expandtab
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
 
  set autoindent
  set smartindent "helps with backspacing because of expandtab
  
" Set to auto read when a file is changed from the outside
  set autoread
 
" * Search & Replace
 
" show the `best match so far' as search strings are typed:
  set incsearch
 
" assume the /g flag on :s substitutions to replace all matches in a line:
  set gdefault
 
" enable line numbers
  set number
  setlocal numberwidth=3
 
" * File Browsing
 
" Settings for explorer.vim
  let g:explHideFiles='^\.'
 
" Settings fo rnetrw
  let g:netrw_list_hide='^\.,\~$'
 
" Enable the tab bar
  set showtabline=2 " 2=always
 
" Make backspace work in insert mode
  set backspace=indent,eol,start
 
" Remember last position in file
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
 
" Make it easy to update/reload .vimrc
  nmap <leader>s :source ~/.vimrc<CR>
  nmap <leader>vi :tabe ~/.vimrc<CR>
  
" Tab navigation
  nmap <leader>tn :tabnext<CR>
  nmap <leader>tp :tabprevious<CR>
  nmap <leader>te :tabedit
 
" Remap F1 from Help to ESC. No more accidents
  nmap <F1> <Esc>
  map! <F1> <Esc>
 
" <leader>f to startup an ack search
  map <leader>f :Ack<Space>
 
" SHELL
  command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
 
  function! s:RunShellCommand(cmdline)
    botright new
 
    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal noswapfile
    setlocal nowrap
    setlocal filetype=shell
    setlocal syntax=shell
 
    call setline(1,a:cmdline)
    call setline(2,substitute(a:cmdline,'.','=','g'))
    execute 'silent $read !'.escape(a:cmdline,'%#')
    setlocal nomodifiable
    1
  endfunction
 
  nmap <leader>sh :Shell
 
" Fuzzy find files in project a la TextMate
  nmap <leader>t :FuzzyFinderTextMate<CR>
  let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**"
  let g:fuzzy_matching_limit = 40
  
" Use FuzzyFinder to replace built-in tag navigation :tag and <C-]>:
  nnoremap <silent> <C-f><C-t> :FuzzyFinderTag!<CR>
  nnoremap <silent> <C-]> :FuzzyFinderTag! <C-r>=expand('<cword>')<CR><CR>
  
  " Add RebuildTagsFile function/command
  function! s:RebuildTagsFile()
    !ctags -R --exclude=coverage --exclude=vendor *
  endfunction
  command! -nargs=0 RebuildTagsFile call s:RebuildTagsFile()
 
" Run file with...
  nmap <leader>sf :Shell script/spec -fn %<CR>
  nmap <leader>st :Shell ruby %<CR>
  
" Quick, jump out of insert mode while no one is looking
  imap ii <Esc>
 
" Nice statusbar
  set laststatus=2
  set statusline=\ "
  set statusline+=%f\ " file name
  set statusline+=[
  set statusline+=%{strlen(&ft)?&ft:'none'}, " filetype
  set statusline+=%{&fileformat}] " file format
  set statusline+=%h%1*%m%r%w%0* " flag
  set statusline+=%= " right align
  set statusline+=%-14.(%l,%c%V%)\ %<%P " offset
 
" Title: update the title of the window?
  set title
 
" Title String: what will actually be displayed
  set titlestring=VIM:\ %-25.55F\ %a%r%m titlelen=70
 
" Turn off rails bits of statusbar
  let g:rails_statusline=0
 
" TagList {{{
  let Tlist_GainFocus_On_ToggleOpen = 1
  let Tlist_Process_File_Always = 1
  let Tlist_Inc_Winwidth = 0
  let Tlist_Enable_Fold_Column = 0 "Disable drawing the fold column
  let Tlist_Use_SingleClick = 1 "Single click tag selection
  let Tlist_Use_Right_Window = 1
  let Tlist_Exit_OnlyWindow = 1 "Exit if only the taglist is open
  let Tlist_File_Fold_Auto_Close = 1 " Only auto expand the current file
  nmap <F3> :TlistToggle<CR>
  nmap <F4> :BufExplorer<CR>
  nmap <F5> :bw<CR>
 
" NERDTree {{{
  let NERDChristmasTree = 1
  let NERDTreeHighlightCursorline = 1
  let NERDTreeShowBookmarks = 1
  let NERDTreeShowHidden = 1
  let NERDTreeIgnore = ['.vim$', '\~$', '.svn$', '.git$']
  nmap <F2> :NERDTreeToggle<CR>
 
" NERDComment {{{
  let NERDShutUp = 1
  " bind command-/ to toggle comment
  " requires NERD Commenter to be installed: http://www.vim.org/scripts/script.php?script_id=1218
  nmap <D-/> ,c<Space>
  vmap <D-/> ,c<Space>
  imap <D-/> <C-O>,c<Space>
 
" IRB {{{
  autocmd FileType irb inoremap <buffer> <silent> <CR> <Esc>:<C-u>ruby v=VIM::Buffer.current;v.append(v.line_number, eval(v[v.line_number]).inspect)<CR>
  nnoremap <leader>irb :<C-u>below new<CR>:setfiletype irb<CR>:set syntax=ruby<CR>:set buftype=nofile<CR>:set bufhidden=delete<CR>i
 
" Turn on language specific omnifuncs
  autocmd FileType ruby set omnifunc=rubycomplete#Complete
  autocmd FileType python set omnifunc=pythoncomplete#Complete
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
  autocmd FileType php set omnifunc=phpcomplete#CompletePHP
  autocmd FileType c set omnifunc=ccomplete#Complete
 
" load user settings
  runtime user_settings.vim
"
"
"       ,L  = "Last updated" - insert time stamp and delete old time stamp
map     ,L mz1G/Last update: */e+1<CR>D:r!date<CR>kJ


"interactive spell check
" works only in non-gui mode for now
map #sp :w<CR>:!ispell %<CR>:e %<CR> 

"     dictionary: english words first
set   dictionary=/usr/dict/words,/usr/dict/extra.words
"

" Define "del" char to be the same as backspace (saves a LOT of trouble!)
map <C-V>127 <C-H>

"
"     autowrite: "on" saves a lot of trouble
set   autowrite

"
"     backup:  backups are for wimps  ;-)
set nobackup

"
" comments default: sr:/*,mb:*,el:*/,://,b:#,:%,:XCOMM,n:>,fb:-
set comments=b:#,:%,:\",fb:-,n:>,n:),n:\"
"
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

if has("autocmd")

  " Enabled file type detection and file-type specific plugins.
  " filetype plugin on indent
  filetype plugin on

  " Drupal *.module and *.engine files.
  augroup module
    autocmd BufRead                     *.module,*.engine set filetype=php
  augroup END

  " Python code.
  augroup python
    autocmd BufReadPre,FileReadPre      *.py set tabstop=4
    autocmd BufReadPre,FileReadPre      *.py set expandtab
  augroup END

  " Ruby code.
  augroup ruby
    autocmd BufReadPre,FileReadPre      *.rb set tabstop=2
    autocmd BufReadPre,FileReadPre      *.rb set expandtab
  augroup END

  " PHP code.
  augroup php
    autocmd BufReadPre,FileReadPre      *.php set tabstop=4
    autocmd BufReadPre,FileReadPre      *.php set expandtab
  augroup END

  " Java code.
  augroup java
    autocmd BufReadPre,FileReadPre      *.java set tabstop=4
    autocmd BufReadPre,FileReadPre      *.java set expandtab
  augroup END

  " ANT build.xml files.
  augroup xml
    autocmd BufReadPre,FileReadPre      build.xml set tabstop=4
  augroup END

  " (J)Flex files.
  augroup lex
    " autocmd BufRead,BufNewFile          *.flex,*.jflex set filetype=lex
    autocmd BufRead,BufNewFile          *.flex,*.jflex set filetype=jflex
  augroup END 

  " (Nu)SMV files.
  augroup smv
    autocmd BufRead,BufNewFile          *.smv set filetype=smv 
  augroup END

 au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/plugin/yaml.vim
 au! BufRead,BufNewFile *.haml         setfiletype haml 
 au BufRead,BufNewFile *.js set ft=javascript.jquery
endif

