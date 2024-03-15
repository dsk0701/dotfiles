" 参考ページ
" https://github.com/tokorom/dotfiles/blob/master/.vimrc

" dein
:source ~/.vimrc.dein

" basic
:source ~/.vimrc.basic

" --------------------------------------------------
" ddu
" ddu-ui-ff
" --------------------------------------------------
call ddu#custom#patch_global(#{
    \   ui: 'ff',
    \   sources: [
    \     #{
    \         name: 'file_rec',
    \         params: #{
    \           ignoredDirectories: ['.git', 'vendor', 'build'],
    \         },
    \     },
    \   ],
    \   sourceOptions: #{
    \     _: #{
    \       matchers: ['matcher_substring'],
    \     },
    \   },
    \   filterParams: #{
    \     matcher_substring: #{
    \       highlightMatched: 'Search',
    \     },
    \   },
    \   kindOptions: #{
    \     file: #{
    \       defaultAction: 'open',
    \     },
    \   },
    \   uiParams: #{
    \     ff: #{
    \       split: 'floating',
    \       startFilter: v:true,
    \       prompt: '> ',
    \     }
    \   },
    \   actionOptions: #{
    \     narrow: #{
    \       quit: v:false,
    \     },
    \   },
    \ })

" --------------------------------------------------
" ddu-ui-ff
" --------------------------------------------------
autocmd FileType ddu-ff call s:ddu_ff_my_settings()
function s:ddu_ff_my_settings() abort
  nnoremap <buffer> <CR>
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'open'})<CR>
  nnoremap <buffer> v
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'vsplit'}})<CR>
  nnoremap <buffer> V
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'botright vsplit'}})<CR>
  nnoremap <buffer> i
  \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
  nnoremap <buffer> p
  \ <Cmd>call ddu#ui#do_action('preview')<CR>
  nnoremap <buffer> q
  \ <Cmd>call ddu#ui#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_ff_filter_my_settings()
function s:ddu_ff_filter_my_settings() abort
  inoremap <buffer> <CR>
  \ <Esc><Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
  inoremap <buffer> <Esc>
  \ <Esc><Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
  nnoremap <buffer> <CR>
  \ <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
endfunction

nmap <silent> <C-n> <Cmd>call ddu#start()<CR>
nmap <silent> <C-l> <Cmd>call ddu#start(#{ sources: [#{ name: 'file_old' }] })<CR>

" --------------------------------------------------
" ddu-ui-filer
" ddu-column-filename
" --------------------------------------------------
call ddu#custom#patch_local('filer', #{
    \   ui: 'filer',
    \   sources: [#{ name: 'file', params: {} }],
    \   sourceOptions: #{
    \     _: #{
    \       columns: ['filename'],
    \     },
    \   },
    \   uiParams: #{
    \     filer: #{
    \       split: 'floating',
    \     }
    \   },
    \   actionOptions: #{
    \     narrow: #{
    \       quit: v:false,
    \     },
    \   },
    \ })

autocmd FileType ddu-filer call s:ddu_filer_my_settings()
function s:ddu_filer_my_settings() abort
  nnoremap <buffer><silent><expr> <CR>
  \ ddu#ui#get_item()->get('isTree', v:false) ?
  \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow'})<CR>" :
  \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'tabe'}})<CR>"
  " 一番右側に開く
  " \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'botright vsplit'}})<CR>"
  " nnoremap <buffer> <CR>
  " \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
  nnoremap <buffer><silent> ..
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': '..'}})<CR>
  nnoremap <buffer> <Space>
  \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
  nnoremap <buffer> o
  \ <Cmd>call ddu#ui#do_action('expandItem', #{ mode: 'toggle' } )<CR>
  nnoremap <buffer> q
  \ <Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer><silent> c
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'copy'})<CR>
  nnoremap <buffer><silent> p
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'paste'})<CR>
  nnoremap <buffer><silent> d
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'delete'})<CR>
  nnoremap <buffer><silent> r
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'rename'})<CR>
  nnoremap <buffer><silent> mv
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'move'})<CR>
  nnoremap <buffer><silent> t
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'newFile'})<CR>
  nnoremap <buffer><silent> mk
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'newDirectory'})<CR>
  nnoremap <buffer><silent> yy
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'yank'})<CR>
  " toggle hidden files.
  nnoremap <buffer> .
  \ <Cmd>call ddu#ui#do_action('updateOptions', #{
  \   sourceOptions: #{
  \     _: #{
  \       matchers: ToggleHidden(),
  \     },
  \   },
  \ })<CR>
  \<Cmd>call ddu#ui#do_action('redraw')<CR>
  function! ToggleHidden()
    const current = ddu#custom#get_current(b:ddu_ui_name)
    const source_options = get(current, 'sourceOptions', {})
    const source_options_all = get(source_options, '_', {})
    const matchers = get(source_options_all, 'matchers', [])
    return empty(matchers) ? ['matcher_hidden'] : []
  endfunction
endfunction

nmap <silent> ,d <Cmd>call ddu#start(#{ name: 'filer' })<CR>

" --------------------------------------------------
" ddu-source-rg
" --------------------------------------------------
call ddu#custom#patch_local('grep', #{
    \   sources: [#{ name: 'rg', params: {} }],
    \ })

nnoremap ,g
  \ <Cmd>call ddu#start(#{
  \   name: 'grep',
  \   sourceParams: #{
  \     rg: #{
  \       args: ['--column'],
  \       input: input('Pattern: '),
  \     },
  \   },
  \ })<CR>

nnoremap ,gw
  \ <Cmd>call ddu#start(#{
  \   name: 'grep',
  \   sourceParams: #{
  \     rg: #{
  \       args: ['-w', '--column'],
  \       input: input('Pattern: ', expand('<cword>')),
  \     },
  \   },
  \ })<CR>

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
let g:dartfmt_options = ['-l 120']
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

