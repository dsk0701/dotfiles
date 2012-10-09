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

ErrorCheck patch -d .vim/bundle/cocoa.vim -p1 < cocoa.vim.objcpp.patch

# submodule_dirs=`git submodule | awk '{print $2}'`
# 
# for submodule_dir in ${submodule_dirs}
# do
#     pushd ${submodule_dir}
# 
#     git status | grep "Not currently on any branch"
# 
#     if [ $? -eq 0 ]; then
#         git branch -a | grep master
#         if [ $? -eq 0 ]; then
#             ErrorCheck git checkout master
#         fi
#     fi
# 
#     popd
# done

