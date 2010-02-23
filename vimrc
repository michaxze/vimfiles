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
 
" Highlight the line that the cursor is on.
set cursorline

" Always show line numbers
set number
 
" Reset the window title in non-GUI mode to something a little more helpful.
set title
 
" Use a manual foldmethod so that folds persist in files
set foldmethod=marker
 
" Tab completion in command mode shows all possible completions, shell style.
set wildmenu
set wildmode=list:longest

" A split will default to being creating under or to the right of the current.
set splitbelow splitright
 
" Make NERDCommenter add a space before/after comments
let NERDSpaceDelims=1

" Let Syntastic throw down error gang signs
let g:syntastic_enable_signs=1

" Fancy statusline {{{
" All the code in this fold from the following 3 blog posts:
" http://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
" http://got-ravings.blogspot.com/2008/10/vim-pr0n-conditional-stl-highlighting.html
" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html
" + the help file for vim-fugitive
 
" Always display a statusline
set laststatus=2
 
"Add the variable with the name a:varName to the statusline. Highlight it as
"'error' unless its value is in a:goodValues (a comma separated string)
function! AddStatuslineFlag(varName, goodValues)
  set statusline+=[
  set statusline+=%#error#
  exec "set statusline+=%{RenderStlFlag(".a:varName.",'".a:goodValues."',1)}"
  set statusline+=%*
  exec "set statusline+=%{RenderStlFlag(".a:varName.",'".a:goodValues."',0)}"
  set statusline+=]
endfunction
 
"returns a:value or ''
"
"a:goodValues is a comma separated string of values that shouldn't be
"highlighted with the error group
"
"a:error indicates whether the string that is returned will be highlighted as
"'error'
function! RenderStlFlag(value, goodValues, error)
  let goodValues = split(a:goodValues, ',')
  let good = index(goodValues, a:value) != -1
  if (a:error && !good) || (!a:error && good)
    return a:value
  else
    return ''
  endif
endfunction
 
" Fancy statusline.
set statusline=%t "tail of the filename
set statusline+=%m "modified flag
call AddStatuslineFlag('&ff', 'unix') "fileformat
call AddStatuslineFlag('&fenc', 'utf-8') "file encoding
set statusline+=%h "help file flag
set statusline+=%r "read only flag
set statusline+=%y "filetype
 
" From syntastic plugin
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
 
" From Fugitive plugin
set statusline+=%{fugitive#statusline()}
 
set statusline+=%#error# "display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%{StatuslineTabWarning()} "warnings for mixed tabs and other issues
set statusline+=%{StatuslineTrailingSpaceWarning()} "warning if there is any trailing whitespace in the file
set statusline+=%*
set statusline+=%= "left/right separator
set statusline+=%c, "cursor column
set statusline+=%l/%L "cursor line/total lines
set statusline+=\ %p "percent through file
 
"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning
 
"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0
 
        if tabs && spaces
            let b:statusline_tab_warning = '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction
 
"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning
 
"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction
 
" }}}

" My anal whitespace rules and commands {{{
 
" Show trailing whitespace as little blue dots, and also make hard tabs visible.
set list listchars=tab:>·,trail:·
 
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
 
" Ruby specific options {{{
 
" This will highlight trailing whitespace and tabs preceded by a space character
let ruby_space_errors = 1
 
" Syntax highlight ruby operators (+, -, etc)
let ruby_operators = 1
 
augroup myrubyfiletypes
" Clear old autocmds in this group
        autocmd!
 
" autoindent with two spaces, always expand tabs
        autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 ts=2 et
augroup END
 
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
command -bar -nargs=1 OpenURL :!open <args>
 
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
 
" Nice window title
if has('title') && (has('gui_running') || &title)
        set titlestring=
        set titlestring+=%f\ " file name
        set titlestring+=%h%m%r%w " flags
        set titlestring+=\ -\ %{v:progname} " program name
        set titlestring+=\ -\ %{substitute(getcwd(),\ $HOME,\ '~',\ '')} " working directory
endif
 
"}}}
