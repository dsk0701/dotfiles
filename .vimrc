" 参考ページ
" https://github.com/tokorom/dotfiles/blob/master/.vimrc

" vundle設定を読み込む
:silent! source <sfile>:h/.vimrc.neobundle

" 色を付ける.
syntax on

" undo ファイル off.
set noundofile

" ファイルタイププラグインとインデントを有効.
filetype plugin indent on

" 256色使えるように設定.
set t_Co=256

" テーマ.
" colorscheme koehler
colorscheme molokai
" molokai の Search だけ見難いので変更
au Colorscheme * highlight Search term=reverse cterm=reverse gui=reverse guifg=#455354 guibg=fg

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

" USキーボードで:と;を入れ替える.
nnoremap ; :
nnoremap : ;

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
    au BufEnter,BufRead *.swift,*.c,*.cpp,*.m,*.h,*.xml,*.java,*.rb,*.js,*.py,*.mk,Makefile let w:m1 = matchadd("WhitespaceEOL", '\s\+$')
    au BufEnter,BufRead *.swift,*.c,*.cpp,*.m,*.h,*.xml,*.java,*.rb,*.js,*.py,*.mk,Makefile let w:m2 = matchadd("WhitespaceEOL", '^\t')
    au BufEnter,BufRead *.swift,*.c,*.cpp,*.m,*.h,*.xml,*.java,*.rb,*.js,*.py,*.mk,Makefile let w:m3 = matchadd("WhitespaceEOL", '　')
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
nnoremap <silent> ciy ciw<C-r>0<ESC>
nnoremap <silent> cy   ce<C-r>0<ESC>
vnoremap <silent> cy   c<C-r>0<ESC>

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
if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nocolor --nogroup'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_grep_max_candidates = 200
endif

" key-mappings.
nnoremap <silent> ,ug :Unite grep::-n:<C-R><C-W> -buffer-name=grep-buffer -no-quit<CR>
nnoremap <silent> ,ugi :Unite grep::-in:<C-R><C-W> -buffer-name=grep-buffer -no-quit<CR>
nnoremap <silent> ,ugw :Unite grep::-wn:<C-R><C-W> -buffer-name=grep-buffer -no-quit<CR>
nnoremap <silent> ,uga :Unite grep::-n:<C-R><C-W> -auto-preview -buffer-name=grep-buffer -no-quit<CR>

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
" 前回のバッファを開く
nnoremap <silent> ,ur :UniteResume<CR>


" --------------------------------------------------
" neocomplete
" --------------------------------------------------
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions',
    \ 'scala' : $HOME.'/.vim/bundle/vim-scala/dict/scala.dict',
    \ 'java' : $HOME.'/.vim/dict/java.dict',
    \ 'c' : $HOME.'/.vim/dict/c.dict',
    \ 'cpp' : $HOME.'/.vim/dict/cpp.dict',
    \ 'javascript' : $HOME.'/.vim/dict/javascript.dict',
    \ 'ocaml' : $HOME.'/.vim/dict/ocaml.dict',
    \ 'perl' : $HOME.'/.vim/dict/perl.dict',
    \ 'php' : $HOME.'/.vim/dict/php.dict',
    \ 'vm' : $HOME.'/.vim/dict/vim.dict'
    \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  " return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css        setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python     setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml        setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType php        setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType c          setlocal omnifunc=ccomplete#Complete
autocmd FileType ruby       setlocal omnifunc=rubycomplete#Complete
" java-api-complete を使ってみる
autocmd FileType java       setlocal omnifunc=javaapi#complete
let g:javaapi#delay_dirs = [
  \ 'java-api-javax',
  \ 'java-api-org',
  \ 'java-api-android',
  \ ]

" javacomplete を使ってみる
" autocmd FileType java       setlocal omnifunc=javacomplete#Complete

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php =
\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.c =
\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.cpp =
\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl =
\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'


" setting for using clang_complete with neocomplete.
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#force_omni_input_patterns.c =
      \ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:neocomplete#force_omni_input_patterns.cpp =
      \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
let g:neocomplete#force_omni_input_patterns.objc =
      \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
let g:neocomplete#force_omni_input_patterns.objcpp =
      \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_use_library = 1
let g:clang_user_options = '-std=c++11'

" neocomplete objc dictionary.
call neocomplete_ios_dictionary#configure_ios_dict()

" neocomplete swift dictionary.
call neocomplete_swift_dictionary#configure_swift_dict()

" 辞書補完の設定
set complete+=k

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
" lightline
" --------------------------------------------------
scriptencoding utf-8
set encoding=utf-8
set gfn=Ricty\ Regular\ for\ Powerline:h14

" setting for patched font.
let left_sep = ''
let left_sub_sep = ''
let right_sep = ''
let right_sub_sep = ''

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'MyModified',
      \   'readonly': 'MyReadonly',
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \ },
      \ 'separator': { 'left': left_sep, 'right': right_sep },
      \ 'subseparator': { 'left': left_sub_sep, 'right': right_sub_sep }
      \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? ' '._ : ''
  endif
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0


" --------------------------------------------------
" markdown
" --------------------------------------------------
let g:vim_markdown_initial_foldlevel=2

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

    " iOS tag ファイル設定.
    au BufEnter *.c,*.cpp,*.m,*.h  set tags+=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk/tags

    " Android tag ファイル設定.
    au BufEnter *.java  set tags+=~/var/dev/ref/ae/src/android-4.0.1_r1/tags

    " for grep.vim.
    if system('which gxargs')
        let Grep_Xargs_Path = 'gxargs'
    else
        let Grep_Find_Use_Xargs = 0
    endif

    " clang_complete setting for objective-c
    let g:clang_complete_getopts_ios_sdk_directory = '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk/'

    " libclang の パス設定
    let s:clang_library_path='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib'
    if isdirectory(s:clang_library_path)
        let g:clang_library_path=s:clang_library_path
    endif

    " xcode-actions.vim
    if neobundle#tap('xcode-actions.vim')
    function! neobundle#tapped.hooks.on_source(bundle)
    "-----------------------------------------------------------------------------

    augroup xcode-actions.vim
      autocmd!
      autocmd FileType objc,swift,c,cpp nmap ,b <Plug>(xcode-actions-build)
      autocmd FileType objc,swift,c,cpp nmap ,r <Plug>(xcode-actions-run)
      autocmd FileType objc,swift,c,cpp nmap ,c <Plug>(xcode-actions-clean)
      autocmd FileType objc,swift,c,cpp nmap ,u <Plug>(xcode-actions-test)
      autocmd FileType objc,swift,c,cpp nmap ,o <Plug>(xcode-actions-openfile)
    augroup END

    "-----------------------------------------------------------------------------
    endfunction
    call neobundle#untap()
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

