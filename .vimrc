let g:ruby_path = system('echo $HOME/.rbenv/shims')

if has('nvim')
    let s_editor_root=expand("~/.config/nvim")
else
    let s_editor_root=expand("~/.vim")
endif

" Environment {
    " Basics {
        set nocompatible        " Must be first line
        set shell=/bin/zsh
    " }
" }

" Use bundles config {
    if filereadable(expand("~/.vimrc.bundles"))
        source ~/.vimrc.bundles
    endif
" }

" General {
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=                  " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    set encoding=utf-8
    scriptencoding utf-8

    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set nobackup
    set nowritebackup
    set noswapfile
    set history=1000                    " Store a ton of history (default is 20)
    set nospell                           " Spell checking off
    set hidden                          " Allow buffer switching without saving
    set colorcolumn=120                 " Set right margin

    " set cursor to the first line in git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " Restore cursor to file position in previous editing session
    function! ResCur()
        if line("'\"") <= line("$")
            normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END
" }

" Vim UI {
    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    let g:CSApprox_hook_post = ['hi clear SignColumn']

    set ruler                   " Show the ruler
    set showcmd                 " Show partial commands in status line and

    set laststatus=2

    set nu                          " Line numbers on
    set incsearch                   " Find as you type search
    set ignorecase                  " Case insensitive search
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

    set wildignore+=*/tmp/*
    set wildignore+=*/.sass-cache/*

    set rnu
    au BufEnter * :set rnu
    au BufLeave * :set nu
    au WinEnter * :set rnu
    au WinLeave * :set nu
    au InsertEnter * :set nu
    au InsertLeave * :set rnu
    au FocusLost * :set nu
    au FocusGained * :set rnu
" }

" Formatting {
    set nowrap                      " Do not wrap long lines
    set shiftwidth=2                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=2                   " An indentation every four columns
    set softtabstop=2               " Let backspace delete indent
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee
    autocmd BufNewFile,BufRead *.hamlc set filetype=haml
" }

" Key (re)Mappings {
  let mapleader = ','

  map .. <c-^>

  " disable recording
  map q <Nop>

  map <C-J> <C-W>j
  map <C-K> <C-W>k
  map <C-L> <C-W>l
  map <C-H> <C-W>h

  map <C-_> <Leader>c<Space>

  " Wrapped lines goes down/up to next row, rather than next line in file.
  noremap j gj
  noremap k gk

  " Visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv

  " Map <Leader>ff to display all lines with keyword under cursor
  " and ask which one to jump to
  nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

  " Easier horizontal scrolling
  map zl zL
  map zh zH
  map <Leader>m :CtrlPBuffer<CR>
  map <Leader>s :w<CR>
  map <Leader>v <C-w>v
  map <Leader>h <C-w>s
  " Refresh tags file
  map <Leader>ct :!ctags -R .<CR>
  map <Leader>a :Ack
  " use AckGrep
  " open current buffer file location
  map <Leader>r :NERDTreeFind<CR>
" }

" Plugins {
"
    " CTRLP {
        let g:ctrlp_use_caching = 0
        if executable('ag')
          set grepprg=ag\ --nogroup\ --nocolor

          let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
        else
          let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
          let g:ctrlp_prompt_mappings = {
                \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
                \ }
        endif

        let g:ctrlp_root_markers = ['.ruby-version']
        let g:ctrlp_show_hidden=1
        let g:ctrlp_match_window = 'bottom'
        let g:ctrlp_switch_buffer = 1
        let g:ctrlp_working_path_mode = 0
    " }

    " PIV {
        let g:DisableAutoPHPFolding = 0
        let g:PIVAutoClose = 0
    " }

    " Misc {
        let g:NERDShutUp=1
        let b:match_ignorecase = 1
    " }

    " AutoCloseTag {
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>ac <Plug>ToggleAutoCloseMappings
    " }

    " NerdTree {
        map <C-e> :NERDTreeToggle<CR>
        map <leader>e :NERDTreeFind<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '\.idea', '\.sass-cache']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let g:nerdtree_tabs_open_on_gui_startup=0
        let NERDTreeShowLineNumbers=1
    " }

    " indent_guides {
        let g:indent_guides_auto_colors = 0
        let g:indent_guides_start_level = 2
        let g:indent_guides_guide_size = 1
        let g:indent_guides_enable_on_vim_startup = 1
        autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=#1c1c1c ctermbg=234
        autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#1c1c1c ctermbg=234
    " }

    " vim-airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols , , , , , , and .in the statusline
        " segments add the following to your .vimrc.before.local file:
        "   let g:airline_powerline_fonts=1
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
        if !exists('g:airline_theme')
            "let g:airline_theme = 'ubaryd'
        endif
        if !exists('g:airline_powerline_fonts')
            " Use the default set of separators with a few customizations
            let g:airline_left_sep='›'  " Slightly fancier than '>'
            let g:airline_right_sep='‹' " Slightly fancier than '<'
        endif
        let g:airline_powerline_fonts=1
        let g:Powerline_symbols='unicode'
    " }

    " Syntastic {
      let g:syntastic_check_on_open=0
      let g:syntastic_enable_signs=0
      let g:syntastic_echo_current_error=0
    " }
" }

" GUI Settings {
    if has('nvim')
      set termguicolors
      let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    else
      set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
    endif
    colorscheme railscasts
" }

" Auto save {
    "let g:auto_save = 1
    "let g:auto_save_in_insert_mode = 0  " do not save while in insert mode"
" }

" Functions {
    " Initialize NERDTree as needed {
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
    " }

    " Shell command {
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " }
" }
"
" Performance {
    "set lazyredraw
    "set ttyfast
    let loaded_matchparen = 1 " disable parenthes highlighting
" }
" Hardmode {
    autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
    nnoremap <leader>H <Esc>:call ToggleHardMode()<CR>
    let g:HardMode_level = 'wannabe'
" }
" Hardtime {
    let g:hardtime_default_on = 1
" }
" Easymotion {
"
    let g:EasyMotion_do_mapping = 0 " Disable default mappings

    " Jump to anywhere you want with minimal keystrokes, with just one key binding.
    " `s{char}{label}`
    nmap s <Plug>(easymotion-overwin-f)
    " or
    " `s{char}{char}{label}`
    " Need one more keystroke, but on average, it may be more comfortable.
    "nmap s <Plug>(easymotion-overwin-f2)

    " Turn on case insensitive feature
    let g:EasyMotion_smartcase = 1

    " JK motions: Line motions
    map <Leader>j <Plug>(easymotion-j)
    map <Leader>k <Plug>(easymotion-k)
" }
