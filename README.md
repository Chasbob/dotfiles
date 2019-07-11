# Dotfiles

This is my oh my zsh and powerlevel 9k setup, setup as described [here](https://www.atlassian.com/git/tutorials/dotfiles).\
This repository contains copies of [oh my zsh](https://github.com/robbyrussell/oh-my-zsh) and [Powerlevel9k](https://github.com/bhilburn/powerlevel9k).

## Install

### Easy

This method should work as long as you don't already have any of the files, you can just rename them before hand though.
`curl https://raw.githubusercontent.com/Chasbob/dotfiles/master/docs/install.sh | sh`

### The Other Way

1. zsh must be installed on the system
2. clone the repository as a bare repository into your home\
    `git clone --bare https://github.com/Chasbob/dotfiles.git $HOME/.cfg`
3. Define the config aliase\
    `alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'`
4. Checkout the actual content from the bare repository to your $HOME:
    `config checkout`

    ```bash
    error: The following untracked working tree files would be overwritten by checkout:
        .gitignore
    Please move or remove them before you can switch ranches.
    Aborting
    ```

    This is because your $HOME folder might already have some stock configuration files which would be overwritten by Git. The solution is simple: back up the files if you care about them, remove them if you don't care. Here is a rough shortcut to move all the offending files automatically to a backup folder:

    ```sh
    mkdir -p .config-backup && \
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
    xargs -I{} mv {} .config-backup/{}
    ```

    Re-run the check out if you had problems:
    config checkout

5. Set the flag showUntrackedFiles to no on this specific (local) repository:\
    `config config --local status.showUntrackedFiles no`  

To add further files:

```bash
config status
config add .vimrc
config commit -m "Add vimrc"
config add .bashrc
config commit -m "Add bashrc"
config push
```