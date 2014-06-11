" テーマ.
colorscheme molokai

" ウィンドウサイズ設定.
set lines=100
set columns=150

"フォント設定.
" mac.
if has('mac')
    " Non patched font.
    " set gfn=Osaka-Mono:h14

    " Patched font.
    set gfn=Ricty\ Regular\ for\ Powerline:h14
    " set gfn=Anonymice\ Powerline:h14
    " set gfn=DejaVu\ Sans\ Mono\ for\ Powerline:h14
    " set gfn=Droid\ Sans\ Mono\ for\ Powerline:h14
    " set gfn=Inconsolata\ for\ Powerline:h14
    " set gfn=Literation\ Mono\ Powerline:h14
else
    set gfn=DejaVu\ Sans\ Mono\ 10
endif

"自動的に日本語入力(IM)をオンにする機能を無効
set imdisable

