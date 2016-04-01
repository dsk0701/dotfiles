#!/bin/sh

ErrorCheck()
{
    $*
    if [ $? -ne 0 ]; then
        echo "------- Error Command : $* -------"
        exit 1
    fi
}

cd $(dirname $0)

ErrorCheck git submodule init
ErrorCheck git submodule update

# -------------------------
# neobundle
# -------------------------
mkdir -p ~/.vim/bundle
ErrorCheck git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

