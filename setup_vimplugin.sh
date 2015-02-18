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
# cocoa
# -------------------------
# ErrorCheck patch -d .vim/bundle/cocoa.vim -p1 < cocoa.vim.objcpp.patch

# -------------------------
# neobundle
# -------------------------
mkdir -p ~/.vim/bundle
ErrorCheck git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

# -------------------------
# pydiction
# -------------------------
pydiction_dir=~/.vim/bundle/pydiction
pydiction_after_dir=~/.vim/after/ftplugin
django_modules="
    pydiction.py
    django
    django.contrib
    django.contrib.admin
    django.db
    django.db.models
    django.db.models.fields
    django.forms
    django.forms.extras
    django.http
    django.shortcuts
    django.utils
"

which django-admin
if [ $? -eq 0 ]; then
    ErrorCheck mkdir -p temp
    ErrorCheck mkdir -p ${pydiction_after_dir}
    cp ${pydiction_dir}/* ${pydiction_after_dir}/.

    pushd temp
    django-admin startproject django_compl

    pushd django_compl
    cp ${pydiction_dir}/complete-dict ${pydiction_dir}/pydiction.py .
    sed -i -e "2a\import settings\nfrom django.core.management import setup_environ\nsetup_environ(settings)" \
        pydiction.py
    python ${django_modules}

    cp complete-dict ${pydiction_after_dir}/.

    popd
    popd
    rm -rf temp
fi

