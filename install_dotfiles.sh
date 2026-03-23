#!/bin/bash

cd $(dirname $0)

back_up_dirs=".vim .tmux .config"

for dir in $back_up_dirs
do
    if [ ! -L $HOME/$dir ] && [ -d $HOME/$dir ]; then
        echo "Back up $dir directory."
        mv $HOME/$dir{,.BAK}
    fi
done

for dotfile in \.?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ] && [ $dotfile != "`echo $dotfile | grep \.swp`" ]; then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done

