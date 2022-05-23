# 参考ページ
# http://d.hatena.ne.jp/cooldaemon/searchdiary?word=*%5Bzsh%5D
# http://hatena.g.hatena.ne.jp/hatenatech/20060517/1147833430
# http://www.ayu.ics.keio.ac.jp/~mukai/translate/zshoptions.html
# http://zshwiki.org/home/

# --------------------------------------------------------------------------------
# キー設定
# --------------------------------------------------------------------------------

# 履歴表示の後、カーソルを末尾に
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Ctrl-p, n, ↑, ↓で前方一致検索
bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end
bindkey '^[[A' history-beginning-search-backward-end # ↑キー
bindkey '^[[B' history-beginning-search-forward-end  # ↓キー

# Ctrl-rでインクリメンタルサーチ (*等でAnd検索可能に)
bindkey '^R' history-incremental-pattern-search-backward

# --------------------------------------------------------------------------------
# 補完設定
# --------------------------------------------------------------------------------

# 標準の補完設定
autoload -Uz compinit && compinit

# cache
zstyle ':completion::complete:*' use-cache 1

# ファイル補完時にも色付け
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 補完候補が複数ある時に、一覧表示する
setopt auto_list

# 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完する
setopt auto_menu

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

# auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示
setopt list_types

# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst

# 補完候補を ←↓↑→ で選択 (補完候補が色分け表示される)
zstyle ':completion:*:default' menu select=1

# Termに表示されている内容から補完
# from http://d.hatena.ne.jp/secondlife/20060108/1136650653
HARDCOPYFILE=$HOME/.screen-hardcopy
touch $HARDCOPYFILE

dabbrev-complete () {
        local reply lines=80 # 80行分
        screen -X eval "hardcopy -h $HARDCOPYFILE"
        reply=($(sed '/^$/d' $HARDCOPYFILE | sed '$ d' | tail -$lines))
        compadd - "${reply[@]%[*/=@|]}"
}

zle -C dabbrev-complete menu-complete dabbrev-complete
bindkey '^o' dabbrev-complete
bindkey '^o^_' reverse-menu-complete

# --------------------------------------------------------------------------------
# hisotry設定
# --------------------------------------------------------------------------------

# 複数の zsh を同時に使う時など history ファイルに上書きせず追加する
setopt append_history

# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_dups

# コマンドラインの先頭がスペースで始まる場合ヒストリに追加しない
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify

# シェルのプロセスごとに履歴を共有
setopt share_history

# history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store

# 履歴ファイルに時刻を記録
setopt extended_history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

# peco を使った履歴検索
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# --------------------------------------------------------------------------------
# cd設定
# --------------------------------------------------------------------------------

# 指定したコマンド名がなく、ディレクトリ名と一致した場合 cd する
setopt auto_cd

# cdでpushdに置き換え
setopt autopushd

# 重複ディレクトリはpushdしない
setopt pushd_ignore_dups

# --------------------------------------------------------------------------------
# 展開関連設定
# --------------------------------------------------------------------------------

# {a-c} を a b c に展開する機能を使えるようにする
setopt brace_ccl

# =command を command のパス名に展開する
setopt equals

# ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob

# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs

# ファイル名の展開で、辞書順ではなく数値的にソートされるようになる
setopt numeric_glob_sort

# --------------------------------------------------------------------------------
# prompt設定
# --------------------------------------------------------------------------------

# コピペの時rpromptを非表示する
setopt transient_rprompt

# プロンプト文字列で各種展開を行う
setopt prompt_subst

autoload -U colors; colors

case ${UID} in
	0)
		PROMPT='${WINDOW:+"[$WINDOW]"}%{$fg[red]%}%n@%m %#%{$reset_color%} '
		;;
	*)
		PROMPT='${WINDOW:+"[$WINDOW]"}%{$fg[green]%}%n@%m %#%{$reset_color%} '
		;;
esac
RPROMPT_DEFAULT='%{$fg[yellow]%}[%~]%{$reset_color%}'
RPROMPT=$RPROMPT_DEFAULT

# Change the window title of X terminals 
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
esac

# --------------------------------------------------------------------------------
# その他設定
# --------------------------------------------------------------------------------

# カッコの対応などを自動的に補完する
setopt auto_param_keys

# ビープ音を鳴らさないようにする
setopt NO_beep

# コマンドのスペルチェックをする
setopt correct

# Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
setopt no_flow_control
stty -ixon

# シェルが終了しても裏ジョブに HUP シグナルを送らないようにする
setopt NO_hup

# コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments

# 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs

# 8 ビット目を通すようになり、日本語のファイル名などを見れるようになる
setopt print_eightbit

# 文字列末尾に改行コードが無い場合でも表示する
unsetopt promptcr

# screen のステータスラインにコマンド表示する
preexec () {
  [ ${STY} ] && echo -ne "\ek${1%% *}\e\\"
}

# --------------------------------------------------------------------------------
# 環境変数
# --------------------------------------------------------------------------------

# timeの表示をbashっぽくする
export TIMEFMT=$'%J : \n real\t%*Es\n user\t%*Us\n sys \t%*Ss\n cpu \t%P'

export GIT_EDITOR="nvim"
export SVN_EDITOR="vim"
export PATH=$HOME/bin:$PATH
export RUBYOPT="$RUBYOPT -Ku"

# ant file encoding.
export ANT_OPTS=-Dfile.encoding=UTF8

# 重複したPATHを削除
typeset -U path

# --------------------------------------------------------------------------------
# alias
# --------------------------------------------------------------------------------
#
# colors for ls.
alias d="ls --color"
alias ls="ls --color=auto -F"
unset LS_COLORS

alias grep='grep --color=auto'
#alias cp="cp -i"
alias rm="rm -i"
alias mv="mv -i"
alias google="w3m www.google.co.jp"

# unixtime to localtime
alias -g TIME="| awk '{print strftime(\"%Y-%m-%d %H:%M:%S\",\$1)}'"
alias -g UTIME="| awk '{print strftime(\"%Y-%m-%d %H:%M:%S %Z\",\$1,1)}'"  # UTC (from awk 3.1.6)

# java relationship.
alias javac='javac -J-Dfile.encoding=UTF-8'
alias java='java -Dfile.encoding=UTF-8'

# mac
case "${OSTYPE}" in
    freebsd*|darwin*)
        # override colors for ls.
        alias ls="ls -G -w"

        # updatedb
        alias updatedb="sudo /usr/libexec/locate.updatedb"

        # ls color 設定
        export LSCOLORS=gxfxcxdxbxegedabagacad

        # HomeBrew 設定
        # arm64のパッケージを優先的に使用する。
        path=(
            /opt/homebrew/bin(N-/)
            /usr/local/bin(N-/)
            $path
        )
        if (( $+commands[sw_vers] )) && (( $+commands[arch] )); then
            # [[ -x /usr/local/bin/brew ]] && alias brew="arch -arch x86_64 /usr/local/bin/brew"
            alias x64='exec arch -x86_64 /bin/zsh'
            alias a64='exec arch -arm64e /bin/zsh'

            ARCH=$(uname -m)
            if [[ $ARCH == arm64 ]]; then
                echo "Current Architecture: $ARCH"
                eval $(/opt/homebrew/bin/brew shellenv)
            elif [[ $ARCH == x86_64 ]]; then
                echo "Current Architecture: $ARCH"
                eval $(/usr/local/bin/brew shellenv)
            fi
        else
            # homebrew のパスに*-configがあると正常に動かないかもしれないというbrew doctorのwarning対策
            # https://qiita.com/tsukapah/items/40462aa2311ce6269571
            alias brew="env PATH=${PATH/\/Users\/${USER}\/\.pyenv\/shims:/} brew"
        fi

        # macvim 設定
        MACVIM_DIR="/Applications/MacVim.app/Contents/MacOS"
        if [ -d ${MACVIM_DIR} ]; then
            alias vim='env LANG=ja_JP.UTF-8 ${MACVIM_DIR}/Vim "$@"'
            alias gvim='env LANG=ja_JP.UTF-8 ${MACVIM_DIR}/mvim "$@"'
            alias gvimdiff='env LANG=ja_JP.UTF-8 ${MACVIM_DIR}/mvimdiff "$@"'
            alias ctags='${MACVIM_DIR}/ctags "$@"'
        fi
        ;;
esac

# rbenv
which rbenv > /dev/null 2>&1 && eval "$(rbenv init -)"

# pyenv
which pyenv > /dev/null 2>&1 && eval "$(pyenv init --path)" && eval "$(pyenv init -)"

# nodenv
which nodenv > /dev/null 2>&1 && eval "$(nodenv init -)"

# jenv
which jenv > /dev/null 2>&1 && eval "$(jenv init -)"

# flutter
export PATH=$PATH:~/bin/flutter/bin

# local設定の読み込み
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
