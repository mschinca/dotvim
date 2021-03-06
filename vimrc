" ******************** PATHOGEN ********************

" It is essential for pathogen to be called before enabling filetype
" detection, so we place its configuration at the top of the file.

" Load pathogen (http://github.com/tpope/vim-pathogen)
call pathogen#runtime_append_all_bundles()

" Load help tags
call pathogen#helptags()



" ******************** GENERAL SETTINGS ********************

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Keep a backup file
set backup

" Keep 50 lines of command line history
set history=50

" Show the cursor position all the time
set ruler

" Display incomplete commands
set showcmd

" Enable incremental searching
set incsearch

" Don't use Ex mode, use Q for formatting
map Q gq

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif



" ******************** AUTOCOMMANDS ********************

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " For all text files set 'textwidth' to 78 characters.
  au FileType text  setlocal textwidth=78

  " Ruby source code: set 2-space indentation
  au FileType ruby  setlocal ts=8 sw=2 sts=2 expandtab
  au FileType eruby setlocal ts=8 sw=2 sts=2 expandtab

  " Ruby source code: automatically add shabang to new files
  au BufNewFile *.rb 0put ='#!/usr/bin/env ruby' | norm G

  " R source code: set 2-space indentation
  au FileType r     setlocal ts=8 sw=2 sts=2 expandtab

  " HTML source code: set 2-space indentation
  au FileType html  setlocal ts=8 sw=2 sts=2 expandtab
  au FileType xhtml setlocal ts=8 sw=2 sts=2 expandtab

  " Bourne shell source code: set 4-space indentation
  au FileType sh    setlocal ts=8 sw=4 sts=4 expandtab
  au FileType sh    setlocal makeprg=bash\ '%'

  " Bourne shell source code: automatically add shabang to new files
  au BufNewFile *.sh 0put ='#!/bin/bash' | norm G

  " Syntax of these languages is fussy over tabs Vs spaces
  au FileType make  setlocal ts=8 sts=8 sw=8 noexpandtab
  au FileType yaml  setlocal ts=2 sts=2 sw=2 expandtab

  " Enable cursor line highlighting only in the current window
  au WinLeave * set nocursorline
  au WinEnter * set cursorline

  " OmniCppComplete
  " au FileType c++
  "   \ set tags+=~/.vim/bundle/omnicppcomplete/tags/std_cpp_tags
  "   \ " set tags+=~/.vim/bundle/omnicppcomplete/tags/ns3_tags
  "   \ " build tags of your own project with Ctrl-F12
  "   \ " map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
  "   \ " use +l to have completion work for local variables as well
  "   \ " map <C-F12> :!ctags -R --c++-kinds=+pl --fields=+iaS --extra=+q .<CR>
  "   \ let OmniCpp_NamespaceSearch = 1
  "   \ let OmniCpp_GlobalScopeSearch = 1
  "   \ let OmniCpp_ShowAccess = 1
  "   \ let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
  "   \ let OmniCpp_MayCompleteDot = 1 " autocomplete after .
  "   \ let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
  "   \ let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
  "   \ let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
  "   \ " automatically open and close the popup menu / preview window
  "   \ au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
  "   \ set completeopt=menuone,menu,longest,preview

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

else

  set autoindent	" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		\ | wincmd p | diffthis
endif



" ******************** EDITING ********************

" TODO: check whether we should disable this for old versions of Vim
" Highlight line where cursor is placed
set cursorline

" Use line numbers
set number

" Set minimum width of number field
set numberwidth=5

" Be more liberal with hidden buffers
set hidden

" Toggle paste mode with F9
set pastetoggle=<F9>

" C-A fixes text paste problems (seems to work with endwise)
" TODO: check if * is the undo register
inoremap <silent> <C-a> <ESC>u:set paste<CR>p="*:set nopaste<CR>gi

" Allow to override the following settings via modelines
let g:secure_modelines_allowed_items = [
            \ "syntax",      "syn",
            \ "textwidth",   "tw",
            \ "softtabstop", "sts",
            \ "tabstop",     "ts",
            \ "shiftwidth",  "sw",
            \ "expandtab",   "et",   "noexpandtab", "noet",
            \ "filetype",    "ft",
            \ "foldmethod",  "fdm",
            \ "readonly",    "ro",   "noreadonly", "noro",
            \ "rightleft",   "rl",   "norightleft", "norl"
            \ ]



" ******************** INVISIBLE CHARACTERS ********************

" This configuration was taken from vimcasts.org (episode 1)

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" Show invisible characters by default
set list



" ******************** WHITESPACE AND INDENTATION ********************

" This configuration is taken (in part) from vimcasts.org (episodes 4 and 5)

function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Strip trailing spaces
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>

" Re-indent the whole file
nmap _= :call Preserve("normal gg=G")<CR>

" Remove blank lines
nmap __ :%g/^$/d<CR>

" Smarter indentation functions
nmap <A-Left>  <<
nmap <A-Right> >>
vmap <A-Left>  <gv
vmap <A-Right> >gv



" ******************** COLORS ********************

" Set colors for dark blackground
set background=dark

" Set color scheme (requires csapprox)
colorscheme ir_black
" For presentations:
" colorscheme ironman

" Tell CSApprox to use the Konsole palette
let g:CSApprox_konsole=1
" Silent CSApprox if it cannot load
g:CSApprox_verbose_level

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc




" ******************** SCRATCH.VIM ********************

" Map <Leader>s to toggle scratch
function! ToggleScratch()
  if expand('%') == g:ScratchBufferName
    quit
  else
    Sscratch
  endif
endfunction

map <Leader>s :call ToggleScratch()<CR>



" ******************** VIM-R-PLUGIN2 ********************

" Disable '_' to ' -> ' completion in Vim-R-Plugin2
let g:vimrplugin_underscore = 1



" ******************** NERDTREE ********************

" Toggle (open/close) NERDTree with F12
inoremap <F12> <C-O>:NERDTreeToggle<CR>
nnoremap <F12> :NERDTreeToggle<CR>
vnoremap <F12> :NERDTreeToggle<CR>



" ******************** NERDCOMMENTER ********************

" Smart un/comment of whole lines in visual mode
let NERDCommentWholeLinesInVMode=2

" Insert an extra space after the left delimiter and before the right delimiter
let NERDSpaceDelims=1

" To comment:   ,cl
" To uncomment: ,cu



" ******************** BUFFERS, WINDOWS AND TABS ********************

" This configuration is taken (in part) from vimcasts.org (episodes 7 and 8)

" Window navigation shortcuts
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Commands to move windows around
" nmap <silent> <A-Up>    :wincmd k<CR>
" nmap <silent> <A-Down>  :wincmd j<CR>
" nmap <silent> <A-Left>  :wincmd h<CR>
" nmap <silent> <A-Right> :wincmd l<CR>

" Tab navigation shortcuts
" map <C-1> 1gt
" map <C-2> 2gt
" map <C-3> 3gt
" map <C-4> 4gt
" map <C-5> 5gt
" map <C-6> 6gt
" map <C-7> 7gt
" map <C-8> 8gt
" map <C-9> 9gt
" map <C-0> :tablast<CR>
" By default:
" map <C-PgUp>   gt
" map <C-PgDown> gT

" Other interesting tab management commands
" :tabc[lose]	Close the current tab page and all its windows
" :tabo[nly]	Close all tabs apart from the current one
" :tabmove	Move current tab to the end
" :tabmove 0	Move current tab to the beginning
" :tabmove 1	Move current tab to become the 2nd tab



" ******************** FUZZYFINDER ********************

nnoremap <silent> <LocalLeader>h :FufHelp<CR>
nnoremap <silent> <LocalLeader>2 :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> <LocalLeader>@ :FufFile<CR>
nnoremap <silent> <LocalLeader>3 :FufBuffer<CR>
nnoremap <silent> <LocalLeader>4 :FufDirWithCurrentBufferDir<CR>
nnoremap <silent> <LocalLeader>$ :FufDir<CR>
nnoremap <silent> <LocalLeader>5 :FufChangeList<CR>
nnoremap <silent> <LocalLeader>6 :FufMruFile<CR>
nnoremap <silent> <LocalLeader>7 :FufLine<CR>
nnoremap <silent> <LocalLeader>8 :FufBookmark<CR>
nnoremap <silent> <LocalLeader>* :FuzzyFinderAddBookmark<CR><CR>
nnoremap <silent> <LocalLeader>9 :FufTaggedFile<CR>

let g:fuf_modesDisable = []



" ******************** FILE OPENING SHORTCUTS ********************

" This configuration was taken from vimcasts.org (episode 14)

" Shortcuts to open files from the same directory as the file in the current
" buffer. Additionally, this allows to expand the directory of the current
" file anywhere at the command line by pressing %%.
cnoremap %% <C-R>=expand('%:h').'/'<CR>
map <Leader>ew :e %%
map <Leader>es :sp %%
map <Leader>ev :vsp %%
map <Leader>et :tabe %%




" ******************** MATCHIT ********************

" This configuration was taken from vimcasts.org
" (http://vimcasts.org/blog/2010/12/a-text-object-for-ruby-blocks/)

runtime macros/matchit.vim



" ******************** GUNDO.VIM ********************

nnoremap <F5> :GundoToggle<CR>



" ******************** TABULAR ********************

" This configuration was taken from vimcasts.org (episode 29)

" To align text using Tabular:
" :Tabularize /{pattern}
" (also remember to use \zs, a special pattern that captures the first
" character after the matched text)

let mapleader=','
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif



" ******************** FUGITIVE ********************

" This configuration is taken from vimcasts.org (episodes 31-35)

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Map '..' to go up a level to the parent directory, but only for buffers
  " containing a git blob or tree
  autocmd User fugitive
    \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
    \   nnoremap <buffer> .. :edit %:h<CR> |
    \ endif

  " Autoclean fugitive buggers
  autocmd BufReadPost fugitive://* set bufhidden=delete

endif " has("autocmd")

" Show current git branch
" set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P



" ******************** RVM ********************

" Add RVM information to status line
" set statusline+=%{rvm#statusline_ft_ruby()}

" Always show status line
" set laststatus=2



" ******************** RAILS.VIM ********************

" open URLs w/ firefox
command! -bar -nargs=1 OpenURL :!firefox <args>



" ******************** STILL TO CHECK ********************

" Avoid deleting words in insert mode
imap <C-w> <C-o><C-w>


" Setup RSense
"let g:rsenseHome = expand("~") . "/opt/rsense"


" Clear lines
"noremap <Leader>clr :s/^.*$//<CR>:nohls<CR>


" TODO: Decide how to properly deal with backup and swap files
" set backup " make backup files
" set backupdir=~/.vim/backup " where to put backup files
" set directory=~/.vim/tmp " directory to place swap files in


" To change current file format:
" :set fileformat=unix|dos|mac


" set formatoptions=rq " Automatically insert comment leader on return,
"                      " and let gq format comments


" Other plugins to consider
"  1) yankring (http://www.vim.org/scripts/script.php?script_id=1234)
"  2) taglist (http://www.vim.org/scripts/script.php?script_id=273)
"  4) space (http://github.com/scrooloose/vim-space)
"  5) conque (http://www.vim.org/scripts/script.php?script_id=2771)
"  6) showmarks (http://www.vim.org/scripts/script.php?script_id=152)
"  7) vim-markdown (http://github.com/sukima/vim-markdown)
"  8) textile.vim (http://github.com/timcharper/textile.vim)
"  9) unimpaired (http://github.com/tpope/vim-unimpaired)
" 10) delimitMate (http://github.com/Raimondi/delimitMate)
" 11) JSON.vim (http://www.vim.org/scripts/script.php?script_id=1945)



