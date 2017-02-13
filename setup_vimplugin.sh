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
BUNDLE_DIR=~/.vim/bundle
if [ ! -e "${BUNDLE_DIR}/neobundle.vim" ]; then
    mkdir -p ${BUNDLE_DIR}
    ErrorCheck git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi

# -------------------------
# dein.vim
# -------------------------
DEIN_DIR=~/.vim/dein
if [ ! -e "${DEIN_DIR}" ]; then
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
    sh ./installer.sh ${DEIN_DIR}
    rm -f ./installer.sh
fi

