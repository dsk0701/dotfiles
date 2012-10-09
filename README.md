dotfiles
========

- .zshrc, .zshrc.local, .vimrc, .gvimrc, etc... various dotfiles.
- cocoa.vim.objcpp.patch is a patch for the cocoa.vim to treat objective-c/cpp.
- install_dotfiles.sh is a script for installing the dotfiles.
- setup_vimplugin.sh is a script for setting up the vim plugins (cocoa.vim.objcpp.patch is applied).

how to use
--------

    $ cd
    $ git clone https://github.com/dsk0701/dotfiles.git
    $ sh dotfiles/install_dotfiles.sh
    $ sh dotfiles/setup_vimplugin.sh

notice
--------

- don't forget to make [vimproc](https://github.com/Shougo/vimproc) on your system

