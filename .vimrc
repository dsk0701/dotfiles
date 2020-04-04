" 参考ページ
" https://github.com/tokorom/dotfiles/blob/master/.vimrc

" dein
:source ~/.vimrc.dein

" 色を付ける.
syntax on

" undo ファイル off.
set noundofile

" ファイルタイププラグインとインデントを有効.
filetype plugin indent on

" 256色使えるように設定.
set t_Co=256

" スクロールオフセット
set scrolloff=0

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

" ウィンドウ移動時に外部の変更を反映する
augroup vimrc-checktime
  autocmd!
  autocmd WinEnter * checktime
augroup END

" 行末の空白文字、行頭のTAB文字、全角スペースをハイライト.
" master setting.
" highlight WhitespaceEOL term=underline ctermbg=DarkMagenta guibg=DarkMagenta
" autocmd BufEnter *.c,*.cpp,*.h,*.rb,*.js match ErrorMsg /\(\s\|?\)\+$/

highlight WhitespaceEOL term=underline ctermbg=DarkMagenta guibg=DarkMagenta
aug highlightIdegraphicSpace
    au!
    au Colorscheme * highlight WhitespaceEOL term=underline ctermbg=DarkMagenta guibg=DarkMagenta
    au BufEnter,BufRead *.swift,*.c,*.cpp,*.m,*.h,*.xml,*.java,*.rb,*.js,*.py,*.sh,*.bash,*.mk,Makefile let w:m1 = matchadd("WhitespaceEOL", '\s\+$')
    au BufEnter,BufRead *.swift,*.c,*.cpp,*.m,*.h,*.xml,*.java,*.rb,*.js,*.py,*.sh,*.bash,*.mk,Makefile let w:m2 = matchadd("WhitespaceEOL", '^\t')
    au BufEnter,BufRead *.swift,*.c,*.cpp,*.m,*.h,*.xml,*.java,*.rb,*.js,*.py,*.sh,*.bash,*.mk,Makefile let w:m3 = matchadd("WhitespaceEOL", '　')
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
" denite
" --------------------------------------------------
hi CursorLine ctermfg=magenta

" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
                \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
                \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
                \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
                \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
                \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
                \ denite#do_map('toggle_select').'j'
endfunction

" ファイル一覧
noremap <C-N> :Denite file/rec<CR>
" 最近使ったファイルの一覧
noremap <C-L> :Denite file_mru<CR>

" Ripgrep command on grep source
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--vimgrep', '--no-heading'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" nnoremap <silent> ,gw  :Unite grep:.:-w:<C-R><C-W> -buffer-name=grep-buffer -no-quit<CR>
nnoremap <silent> ,g  :Denite grep -buffer-name=grep-buffer <CR><C-R><C-W>
nnoremap <silent> ,gw  :Denite grep:.:-w:`expand('<cword>')` -buffer-name=grep-buffer <CR>
nnoremap <silent> ,n :Denite -resume -buffer-name=grep-buffer -cursor-pos=+1 -immediately<CR>
nnoremap <silent> ,p :Denite -resume -buffer-name=grep-buffer -cursor-pos=-1 -immediately<CR>
" 前回のGrep結果を開く
nnoremap <silent> ,gr :Denite -resume -buffer-name=grep-buffer<CR>

" --------------------------------------------------
" deoplete
" --------------------------------------------------
let g:deoplete#enable_at_startup = 1
" let g:deoplete#sources#swift#daemon_autostart = 0

" Use smartcase.
let g:deoplete#enable_smart_case = 1

" 一番上の候補を選択状態にする
set completeopt+=noinsert

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
    return pumvisible() ? deoplete#close_popup() : "\<CR>"
endfunction

" --------------------------------------------------
" php
" --------------------------------------------------
let g:neocomplete_php_locale = 'ja'

set iskeyword+=$

if !exists("g:quickrun_config")
    let g:quickrun_config = {}
endif
" let g:quickrun_config["watchdogs_checker/_"] = {
"       \ "outputter/quickfix/open_cmd" : "",
"       \ "hook/close_quickfix/enable_exit" : 1,
"       \ }
" 
" " 書き込み後にシンタックスチェックを行う
" let g:watchdogs_check_BufWritePost_enable = 1
" 
" " 一定時間キー入力がなかった場合にシンタックスチェックを行う
" " バッファに書き込み後、1度だけ行われる
" let g:watchdogs_check_CursorHold_enable = 1
" 
" call watchdogs#setup(g:quickrun_config)

" --------------------------------------------------
" ruby
" --------------------------------------------------
au FileType ruby setl expandtab tabstop=2 shiftwidth=2 softtabstop=2

" --------------------------------------------------
" Javascript
" --------------------------------------------------
au FileType javascript setl expandtab tabstop=4 shiftwidth=4 softtabstop=4

" --------------------------------------------------
" Yaml
" --------------------------------------------------
au FileType yaml setl expandtab tabstop=2 shiftwidth=2 softtabstop=2

" --------------------------------------------------
" Dockerfile
" --------------------------------------------------
au FileType dockerfile setl expandtab tabstop=2 shiftwidth=2 softtabstop=2

" --------------------------------------------------
" Json
" --------------------------------------------------
au FileType json setl expandtab tabstop=2 shiftwidth=2 softtabstop=2 conceallevel=0

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
" vim-emacscommandline
" --------------------------------------------------
let g:EmacsCommandLineSearchCommandLineMap = '<M-r>'

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


" --------------------------------------------------
" vim-markdown
" --------------------------------------------------
let g:vim_markdown_initial_foldlevel=3

" --------------------------------------------------
" vim-quickrun-markdown-gfm (GitHub flavor markdown)
" --------------------------------------------------
let g:quickrun_config = {
\   'markdown': {
\     'type': 'markdown/gfm',
\     'outputter': 'browser'
\   }
\ }

" --------------------------------------------------
" previm
" --------------------------------------------------
let g:previm_open_cmd = 'open -a Google\ Chrome'

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
    " au BufEnter *.c,*.cpp,*.m,*.h  set tags+=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk/tags

    " Android tag ファイル設定.
    " au BufEnter *.java  set tags+=~/var/dev/ref/ae/src/android-4.0.1_r1/tags

    " play framework ファイル設定.
    " au BufEnter *.java  set tags+=~/var/dev/ref/play/playframework-2.3.8/framework/src/tags

    " for grep.vim.
    if system('which gxargs')
        let Grep_Xargs_Path = 'gxargs'
    else
        let Grep_Find_Use_Xargs = 0
    endif

    " xcode-actions.vim
    autocmd FileType objc,swift,c,cpp nmap ,b <Plug>(xcode-actions-build)
    autocmd FileType objc,swift,c,cpp nmap ,r <Plug>(xcode-actions-run)
    autocmd FileType objc,swift,c,cpp nmap ,c <Plug>(xcode-actions-clean)
    autocmd FileType objc,swift,c,cpp nmap ,u <Plug>(xcode-actions-test)
    autocmd FileType objc,swift,c,cpp nmap ,o <Plug>(xcode-actions-openfile)

    " android-studio-actions.vim
    autocmd FileType java,kotlin,xml nmap ,t <Plug>(android-studio-actions-run)
    autocmd FileType java,kotlin,xml nmap ,r <Plug>(android-studio-actions-debug)
    autocmd FileType java,kotlin,xml nmap ,b <Plug>(android-studio-actions-rebuild)
    autocmd FileType java,kotlin,xml nmap ,o <Plug>(android-studio-actions-openfile)

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

