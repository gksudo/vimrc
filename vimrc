" .vimrc
"
" modification of a vimrc I got from sweetrb@github
"

if has('mouse')
	set mouse=a			" enable mouse in all modes
endif

set background=dark
set termguicolors
let g:materialmonokai_italic=1
colorscheme material-monokai
syntax on				" Syntax color coding 
filetype indent on		" load filetype specific indent files

set ai 					" Auto indent
set background=dark		" background is dark
set cmdheight=1			" command area is 1 row high
set nocursorline		" turn off hilighting the line the cursor is on (makes screen redraw too slow)
set noexpandtab			" do not convert tabs to spaces
set hlsearch			" turn on highlight of last search string
set ignorecase			" ignore case when searching (but see 'smartcase' below)
set incsearch			" search as characters are entered
set laststatus=2		" always display a status line for all windows
set lbr					" attempt to wrap text (line break) on whitespace instead of the exact character count
set magic				" use modern pattern matching characters 
set nu					" turn on line numbers
set showmatch			" highlight match when cursor is over a (, {, [, etc.
set si 					" Smart indent when starting a new line (ex., if prev line ends with '{')
set smartcase			" Override 'ignorecase' if search pattern contains upper case characters
set smarttab			" <Tab> at start of line inserts 'shiftwidth' blanks
set nospell				" disable spell checking (I'm a programmer not a writer)
set spl=en				" Spell check language is english (although spell check is turned off by default)
set statusline=\ %{HasPaste()}%t%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ %L\ LINES\ %=POS:%3l,%3c\ %p%%\ 
set sw=4				" Shiftwidth (how many spaces to move a line l or r using << or >>
set ts=4				" tab stops
set tw=500				" Automatically insert a newline to break lines longer than this many characters
set nowrap				" disable wrapping of long lines
set viminfo^=% 			" Remember info about open buffers on close
set wildmenu			" visual autocomplete for command line

" searching and hilighting
nnoremap ,<space> :nohlsearch<cr>	" the sequence <comma><space> turns off search higlights

" folding
set foldenable			" enable folding
set foldlevelstart=10	" start with anything less than 10 deep unfolded
set foldmethod=syntax	" use syntax to determine what should be folded
nnoremap <space> za		" space toggles folds

"-------------------------------------------------------------------
" Helper functions
"-------------------------------------------------------------------

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
		return 'PASTE MODE  '
	endif
	return ''
endfunction

" Display a string on command line (used by Visual Selection function below)
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" I don't know exactly what this does, I copied it from a .vimrc I found online
function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction
