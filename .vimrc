set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Bundle 'Valloric/YouCompleteMe'
Bundle 'a.vim'
Bundle 'wincent/Command-T'
Bundle 'scrooloose/nerdtree'
Bundle 'godlygeek/tabular'
Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Mizuchi/STL-Syntax'
Bundle 'majutsushi/tagbar'
Bundle 'SirVer/ultisnips'
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'vim-scripts/cscope.vim'

" Vim environment options
syntax on
set nowrap
set expandtab
set number
set tabstop=2
set shiftwidth=2
set visualbell
set noerrorbells
set cursorline
color desert
set background=dark
set hlsearch
set autoread
set incsearch
set autoindent
set backspace=eol,indent,start
set tabstop=4
set softtabstop=4
set shiftwidth=4
" This trigger takes advantage of the fact that the quickfix window can be
" " easily distinguished by its file-type, qf. The wincmd J command is
" " equivalent to the Ctrl+W, Shift+J shortcut telling Vim to move a window to
" " the very bottom (see :help :wincmd and :help ^WJ).
autocmd FileType qf wincmd J

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

nnoremap <silent> <F5> :TagbarToggle<CR>
nnoremap <silent> <F6> :NERDTreeToggle<CR>

function! NERDTreeQuit()
  redir => buffersoutput
  silent buffers
  redir END
"                     1BufNo  2Mods.     3File           4LineNo
  let pattern = '^\s*\(\d\+\)\(.....\) "\(.*\)"\s\+line \(\d\+\)$'
  let windowfound = 0

  for bline in split(buffersoutput, "\n")
    let m = matchlist(bline, pattern)

    if (len(m) > 0)
      if (m[2] =~ '..a..')
        let windowfound = 1
      endif
    endif
  endfor

  if (!windowfound)
    quitall
  endif
endfunction
autocmd WinEnter * call NERDTreeQuit()

if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out  
    " else add the database pointed to by environment variable 
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose  

    nmap <F8> :cn<cr>
    nmap <F7> :cp<cr>

    set cscopequickfix=s-,c-,d-,i-,t-,e-

    " QuickFix open and close
    nnoremap <F11> :copen<CR>
    nnoremap <F12> :cclose<CR>


    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.  
    "

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>  
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>  :copen<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>  :copen<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>  :copen<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>  
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR> :copen<CR><CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>  :copen<CR><CR>


    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>  

    nmap <C-]>s :scs find s <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-]>g :scs find g <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-]>c :scs find c <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-]>t :scs find t <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-]>e :scs find e <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-]>f :scs find f <C-R>=expand("<cfile>")<CR><CR> 
    nmap <C-]>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>   
    nmap <C-]>d :scs find d <C-R>=expand("<cword>")<CR><CR> 


    " Hitting CTRL-space *twice* before the search type does a vertical 
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-]><C-]>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-]><C-]>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-]><C-]>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-]><C-]>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-]><C-]>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-]><C-]>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>   
    nmap <C-]><C-]>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR> 
    nmap <C-]><C-]>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout 
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout 
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100

endif

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
let g:EasyMotion_leader_key='<Space>'

set tags=./tags,tags;
nnoremap <Leader>oc :e %<.c<CR>
nnoremap <Leader>oC :e %<.cpp<CR>
nnoremap <Leader>oh :e %<.h<CR>
let g:ctrlp_working_path_mode = 0
