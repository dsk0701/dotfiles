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
# dein.vim
# -------------------------
DEIN_INSTALLATION_DIR=~/.cache/dein
if [ ! -e "${DEIN_INSTALLATION_DIR}" ]; then
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
    sh ./installer.sh ${DEIN_INSTALLATION_DIR}
    rm -f ./installer.sh
fi

