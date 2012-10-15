" vundle設定を読み込む
:silent! source <sfile>:h/.vimrc.neobundle

" 色を付ける.
syntax on

" ファイルタイププラグインとインデントを有効.
filetype plugin indent on

" 256色使えるように設定.
set t_Co=256

" テーマ.
" colorscheme koehler
colorscheme molokai

" 行番号表示.
set number

" 検索時に大文字小文字を無視.
set ignorecase

" タブ幅.
set tabstop=4

" シフト（>）幅.
set shiftwidth=4

" バックアップファイル.
set nobackup

" 全てのモードでマウス利用可能に.
set mouse=a

" C言語インデント設定.
set cin

" Javaの無名クラスを正しくインデントする設定.
set cinoptions=j1

" タブを半角スペースで入力.
set et

" タグファイルを辿って探す.
set tags=./tags;

" 検索時のハイライト.
set hlsearch

" 検索時のハイライトをESCキー連打で解除.
nnoremap <Esc><Esc> :noh<Enter>

" 無名レジスタに入るデータが*レジスタにも入るようにする.
set clipboard+=unnamed

" ツールバーを非表示.
set guioptions-=T

" 行末の空白文字、行頭のTAB文字、全角スペースをハイライト.
" master setting.
" highlight WhitespaceEOL term=underline ctermbg=DarkMagenta guibg=DarkMagenta
" autocmd BufEnter *.c,*.cpp,*.h,*.rb,*.js match ErrorMsg /\(\s\|?\)\+$/

highlight WhitespaceEOL term=underline ctermbg=DarkMagenta guibg=DarkMagenta
aug highlightIdegraphicSpace
    au!
    au Colorscheme * highlight WhitespaceEOL term=underline ctermbg=DarkMagenta guibg=DarkMagenta
    au BufEnter *.c,*.cpp,*.m,*.h,*.xml,*.java,*.rb,*.js,*.py,*.mk,Makefile let w:m1 = matchadd("WhitespaceEOL", '\s\+$')
    au BufEnter *.c,*.cpp,*.m,*.h,*.xml,*.java,*.rb,*.js,*.py,*.mk,Makefile let w:m2 = matchadd("WhitespaceEOL", '^\t')
    au BufEnter *.c,*.cpp,*.m,*.h,*.xml,*.java,*.rb,*.js,*.py,*.mk,Makefile let w:m3 = matchadd("WhitespaceEOL", '　')
aug END

" タブのキーマッピング.
nnoremap t <Nop>
nnoremap tc :tabnew<Enter>
nnoremap tq :tabclose<Enter>
nnoremap tn :tabnext<Enter>
nnoremap tp :tabprevious<Enter>

" 行頭で h を押すと折畳を閉じる。
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
" 折畳上で l を押すと折畳を開く。
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
" 行頭で h を押すと選択範囲に含まれる折畳を閉じる。
vnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
" 折畳上で l を押すと選択範囲に含まれる折畳を開く。
vnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'


" --------------------------------------------------
" vimfiler
" --------------------------------------------------
let g:vimfiler_as_default_explorer = 1

" --------------------------------------------------
" unite-grep
" --------------------------------------------------
nnoremap <silent> gr :Unite grep::-HRn -no-quit<CR>
nnoremap <silent> gri :Unite grep::-iHRn -no-quit<CR>
nnoremap <silent> grw :Unite grep::-wHRn -no-quit<CR>


" --------------------------------------------------
" unite
" --------------------------------------------------
" 入力モードで開始
let g:unite_enable_start_insert=1
" バッファ一覧
noremap <C-P> :Unite buffer<CR>
" ファイル一覧
noremap <C-N> :Unite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Unite file_mru<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
" 初期設定関数を起動する
au FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  " Overwrite settings.
endfunction

" --------------------------------------------------
" neocomplcache
" --------------------------------------------------
" Un use neocomplcache. Becase of to conflict with the eclim.
let g:neocomplcache_enable_at_startup = 0
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3

" Japanese is not cached.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'


" --------------------------------------------------
" pydiction
" --------------------------------------------------
" filetype plugin on
au FileType python let g:pydiction_location = '~/.vim/after/ftplugin/complete-dict'
" au FileType python setl autoindent
" au FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
" au FileType python setl expandtab tabstop=4 shiftwidth=4 softtabstop=4

" mac.
if has('mac')
    " 透過させる.
    aug transmission
        au!
        au FocusGained * set transparency=5
        au FocusLost * set transparency=30
    aug END

    " 勝手に改行しない.
    set formatoptions=q
    set tags+=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.1.sdk/tags

    " for grep.vim.
    if system('which gxargs')
        let Grep_Xargs_Path = 'gxargs'
    else
        let Grep_Find_Use_Xargs = 0
    endif

" windows.
elseif has('win32')
    " ref.vimの設定
    nmap ,ra :Ref alc<Space>
    " nmap ,ra :<C-u>Ref alc<Space>
    let $PATH = $PATH . ';C:\Program Files\Lynx for Win32'
    let g:ref_alc_use_cache = 1
    let g:ref_alc_start_linenumber = 33
    let g:ref_alc_encoding = 'Shift-JIS'
    " filetypeが分からんならalc
    call ref#register_detection('_', 'alc')

    " Cygwinのgrepを使う場合の設定.
    set grepprg=c:/cygwin1.7/bin/grep\ -nH
    let $CYGWIN='nodosfilewarning'


    " grep.vimの設定.
    let Grep_Path = 'C:\GnuWin32\bin\grep.exe'
    let Fgrep_Path = 'C:\GnuWin32\bin\grep.exe -F'
    let Egrep_Path = 'C:\GnuWin32\bin\grep.exe -E'
    let Grep_Find_Path = 'C:\GnuWin32\bin\find.exe'
    let Grep_Xargs_Path = 'C:\GnuWin32\bin\xargs.exe'
    let Grep_Shell_Quote_Char = '"'
    let Grep_Skip_Dirs = '.svn'

    " 改行コードの設定.
    set fileformat=unix

endif

