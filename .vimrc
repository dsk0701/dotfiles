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

" 検索後画面の中心に.
" nmap n nzz
" nmap N Nzz

" ステータスラインに文字コードと改行文字の種別を表示.
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P


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

" ciy でカーソル位置の単語をヤンクした文字列で置換する.
nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <silent> cy   ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
vnoremap <silent> cy   c<C-r>0<ESC>:let@/=@1<CR>:noh<CR>

" 検索時の '/' を自動でエスケープする.
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'

" --------------------------------------------------
" vimfiler
" --------------------------------------------------
let g:vimfiler_as_default_explorer = 1

" --------------------------------------------------
" unite-grep
" --------------------------------------------------
" grep のバックエンドを ag にする.
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup'
let g:unite_source_grep_recursive_opt = ''
let g:unite_source_grep_max_candidates = 200

" key-mappings.
" nnoremap <silent> gr :Unite grep::-Hn -no-quit<CR>
" nnoremap <silent> gri :Unite grep::-iHn -no-quit<CR>
" nnoremap <silent> grw :Unite grep::-wHn -no-quit<CR>

nnoremap <silent> gr :Unite grep -auto-preview<CR>
nnoremap <silent> grw :Unite grep:.:-w -no-quit -auto-preview<CR>

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
" Use neocomplcache. (Caution : conflict with the eclim.)
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
" let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
" let g:neocomplcache_enable_underbar_completion = 1

" 補完が自動で開始される文字数
" let g:neocomplcache_auto_completion_start_length = 3
" -入力による候補番号の表示
" let g:neocomplcache_enable_quick_match = 1

" 補完候補の一番先頭を選択状態にする(AutoComplPopと似た動作)
let g:neocomplcache_enable_auto_select = 1
"ポップアップメニューで表示される候補の数。初期値は100
let g:neocomplcache_max_list = 20

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scala' : $HOME.'/.vim/bundle/vim-scala/dict/scala.dict',
    \ 'java' : $HOME.'/.vim/dict/java.dict',
    \ 'c' : $HOME.'/.vim/dict/c.dict',
    \ 'cpp' : $HOME.'/.vim/dict/cpp.dict',
    \ 'javascript' : $HOME.'/.vim/dict/javascript.dict',
    \ 'ocaml' : $HOME.'/.vim/dict/ocaml.dict',
    \ 'perl' : $HOME.'/.vim/dict/perl.dict',
    \ 'php' : $HOME.'/.vim/dict/php.dict',
    \ 'scheme' : $HOME.'/.vim/dict/scheme.dict',
    \ 'vm' : $HOME.'/.vim/dict/vim.dict'
    \ }

" Japanese is not cached.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  "return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" FileType毎のOmni補完を設定
autocmd FileType python     setlocal omnifunc=pythoncomplete#Complete
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType css        setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType xml        setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType php        setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType c          setlocal omnifunc=ccomplete#Complete
autocmd FileType ruby       setlocal omnifunc=rubycomplete#Complete

" java-api-complete を使ってみる
autocmd FileType java       setlocal omnifunc=javaapi#complete

" javacomplete を使ってみる
" autocmd FileType java       setlocal omnifunc=javacomplete#Complete

" setting for using clang_complete with neocomplcache.
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_overwrite_completefunc = 1
let g:neocomplcache_force_omni_patterns.c =
  \ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp =
  \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_force_omni_patterns.objc =
  \ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.objcpp =
  \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
" clang_complete の自動呼び出しは切っておく.
let g:clang_complete_auto = 0
let g:clang_auto_select = 0

" Should be written in after/ftplugin/objc.vim ?
" let g:clang_auto_user_options = 'path, .clang_complete, ios'

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.java = '\%(\.\)\h\w*'
" let g:neocomplcache_omni_patterns.java = '[^. \t]\.\h\w*\'


" --------------------------------------------------
" neosnippet
" --------------------------------------------------
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

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

    " tag ファイル設定.
    au BufEnter *.c,*.cpp,*.m  set tags+=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/tags
    au BufEnter *.c,*.cpp,*.m  set tags+=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/tags

    au BufEnter *.java  set tags+=~/var/dev/ref/ae/src/android-2.3.1_r1/frameworks/tags

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

