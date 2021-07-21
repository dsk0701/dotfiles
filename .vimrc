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

" パターンに大文字が含まれているときに限り、大文字と小文字が区別されるように
set ignorecase smartcase

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

" ciy でカーソル位置の単語をヤンクした文字列で置換する.
nnoremap <silent> ciy ciw<C-r>0<ESC>
nnoremap <silent> cy   ce<C-r>0<ESC>
vnoremap <silent> cy   c<C-r>0<ESC>

" 検索時の '/' を自動でエスケープする.
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'

" --------------------------------------------------
" defx
" --------------------------------------------------
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> E
  \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('preview')
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open_tree', 'toggle')
  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
  \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
  \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
  \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
  \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
  \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
  \ defx#do_action('change_vim_cwd')
endfunction

" netrwをdefxで置き換える
function! s:hijack_directory() abort
  let path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  keepjumps keepalt bwipeout %
  execute printf('keepjumps keepalt Defx %s', fnameescape(path))
endfunction

function! s:suppress_netrw() abort
  if exists('#FileExplorer')
    autocmd! FileExplorer *
  endif
endfunction

augroup defx-hijack
  autocmd!
  autocmd VimEnter * call s:suppress_netrw()
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END

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

" Change file/rec command.
" For ripgrep
call denite#custom#var('file/rec', 'command',
    \ ['rg', '--files', '--glob', '!.git', '--color', 'never'])

" Ripgrep command on grep source
call denite#custom#var('grep', {
    \ 'command': ['rg'],
    \ 'default_opts': ['-i', '--vimgrep', '--no-heading'],
    \ 'recursive_opts': [],
    \ 'pattern_opt': ['--regexp'],
    \ 'separator': ['--'],
    \ 'final_opts': [],
    \ })

nnoremap <silent> ,g  :Denite grep <CR><C-R><C-W>
nnoremap <silent> ,gw  :Denite grep:.:-w:`expand('<cword>')` <CR>
" 前回のGrep結果を開く
nnoremap <silent> ,gr :Denite -resume <CR>

let s:floating_window_width_ratio = 1.0
let s:floating_window_height_ratio = 0.7

call denite#custom#option('default', {
\ 'auto_action': 'preview',
\ 'floating_preview': v:true,
\ 'preview_height': float2nr(&lines * s:floating_window_height_ratio),
\ 'preview_width': float2nr(&columns * s:floating_window_width_ratio / 2),
\ 'prompt': '% ',
\ 'split': 'floating',
\ 'vertical_preview': v:true,
\ 'wincol': float2nr((&columns - (&columns * s:floating_window_width_ratio)) / 2),
\ 'winheight': float2nr(&lines * s:floating_window_height_ratio),
\ 'winrow': float2nr((&lines - (&lines * s:floating_window_height_ratio)) / 2),
\ 'winwidth': float2nr(&columns * s:floating_window_width_ratio / 2),
\ })


" --------------------------------------------------
" deoplete
" --------------------------------------------------
let g:deoplete#enable_at_startup = 1
" let g:deoplete#sources#swift#daemon_autostart = 0

" Use smartcase.
call deoplete#custom#option('smart_case', v:true)

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
" vim-markdown
" --------------------------------------------------
" 行頭で h を押すと折畳を閉じる。
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
" 折畳上で l を押すと折畳を開く。
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
" 行頭で h を押すと選択範囲に含まれる折畳を閉じる。
vnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
" 折畳上で l を押すと選択範囲に含まれる折畳を開く。
vnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'

" 改行時にインデントがおかしくなってしまうのを回避
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

" --------------------------------------------------
" Swift completion
" --------------------------------------------------
" let g:lsp_signature_help_enabled = 1
" let g:lsp_diagnostics_enabled = 1
" let g:lsp_diagnostics_echo_cursor = 1
" Xcode、Toolchainどちらsourcekit-lspでもimport UIKitでno such module 'UIKit'エラー
" let g:lsp_settings = {
" \  'sourcekit-lsp': {'cmd': ['xcrun', 'sourcekit-lsp']}
" \  'sourcekit-lsp': {'cmd': ['xcrun', '--toolchain', 'org.swift.533202101251a', 'sourcekit-lsp']}
" \}

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
" Dart
" --------------------------------------------------
let g:dart_style_guide = 2
let g:dart_format_on_save = 1
highlight link dartUserType Normal

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
      \   'fugitive': 'LightlineFugitive',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'mode': 'LightlineMode',
      \ },
      \ 'separator': { 'left': left_sep, 'right': right_sep },
      \ 'subseparator': { 'left': left_sub_sep, 'right': right_sub_sep }
      \ }

function! LightlineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'defx' && exists('*FugitiveHead')
      let mark = ' '  " edit here for cool mark
      let branch = FugitiveHead()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

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

