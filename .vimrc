color desert
set ts=4
set background=dark
syntax on
set number
set expandtab
set hlsearch
set autoread
set incsearch
set autoindent
set cursorline
set backspace=eol,indent,start
set expandtab
" To support tab backforward
set softtabstop=4

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

let g:SupperTabRetainCompletionType=2
