#!/usr/bin/env bash

setup-zsh(){
    cd "$DOTFILES_ROOT" || return
    submodules=(powerlevel10k zsh-autosuggestions zsh-completions zsh-syntax-highlighting)
    git submodule update --init "${submodules[@]}"
    echo DOTFILES_ROOT="$DOTFILES_ROOT" | cat - "$DOTFILES_ROOT"/header.zshrc > "$DOTFILES_ROOT"/.zshrc

    if [ -f "$HOME"/.zshrc ]; then
        mkdir -p dotfile-backups
        mv "$HOME"/.zshrc dotfile-backups
    fi
    ln -s "$DOTFILES_ROOT"/.zshrc ~/.zshrc
}
setup-tmux(){
    git submodule update --init tmux
    if [ -f "$HOME/.tmux" ]; then
        mkdir -p dotfile-backups
        mv ~/.tmux dotfile-backups
    fi

    ln -s "$DOTFILES_ROOT"/tmux ~/.tmux

    if [ -f "$HOME/.tmux.conf" ]; then
        mkdir -p dotfile-backups
        mv ~/.tmux.conf dotfile-backups
    fi
    ln -s ~/.tmux/.tmux.conf ~/.tmux.conf

    if [ -f "$HOME/.tmux.conf.local" ]; then
        mkdir -p dotfile-backups
        mv ~/.tmux.conf.local dotfile-backups
    fi
    cp ~/.tmux/.tmux.conf.local ~/
}

setup-vim(){
    git submodule update --init vim/Vundle.vim
    if [ -f "$HOME/.vimrc" ]; then
        mkdir -p dotfile-backups
        mv ~/.vimrc dotfile-backups
    fi
    ln -s "$DOTFILES_ROOT"/.vimrc ~/.vimrc
    mkdir -p ~/.vim/bundle
    if [ -d "$HOME/.vim/bundle/Vundle.vim" ]; then
        mkdir -p dotfile-backups
        mv "$HOME/.vim/bundle/Vundle.vim" dotfile-backups/
    fi
    ln -s "$DOTFILES_ROOT"/vim/Vundle.vim ~/.vim/bundle
    vim +PluginInstall +qall
}

interactive(){
    while true; do
        read -rep $'Do you wish to install this configuration? (Yes [Yy], No [Nn]): ' yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes [Yy] or no [Nn].";;
        esac
    done

    while true; do
        read -rep $'Setup ZSH? (Yes [Yy], No [Nn]): ' yn
        case $yn in
            [Yy]* ) setup-zsh; break;;
            [Nn]* ) break;;
            * ) echo "Please answer yes [Yy] or no [Nn].";;
        esac
    done

    while true; do
        read -rep $'Setup tmux? (Yes [Yy], No [Nn]): ' yn
        case $yn in
            [Yy]* ) setup-tmux; break;;
            [Nn]* ) break;;
            * ) echo "Please answer yes [Yy] or no [Nn].";;
        esac
    done

    while true; do
        read -rep $'Setup vim? (Yes [Yy], No [Nn])\n' yn
        case $yn in
            [Yy]* ) setup-vim; break;;
            [Nn]* ) break;;
            * ) echo "Please answer yes [Yy] or no [Nn].";;
        esac
    done
}
DOTFILES_ROOT="$( cd "$(dirname "$0")" || echo "cd failed" ; pwd -P)"
if [ "$1" == "-y" ]; then
    START=$PWD
    cd "$DOTFILES_ROOT" || return
    setup-zsh
    setup-tmux
    setup-vim
    cd "$START" || return
else
    interactive
fi

