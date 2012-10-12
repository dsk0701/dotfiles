#!/bin/sh

cd $(dirname $0)

if [ ! -L $HOME/.vim ] && [ -d $HOME/.vim ]; then
    echo "Back up .vim directory."
    mv $HOME/.vim{,.BAK}
fi

for dotfile in \.?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ] && [ $dotfile != "`echo $dotfile | grep \.swp`" ]; then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done

