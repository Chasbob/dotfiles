# Dotfiles

This is my oh my zsh and powerlevel 9k setup, setup as described [here](https://www.atlassian.com/git/tutorials/dotfiles).\
This repository contains copies of [oh my zsh](https://github.com/robbyrussell/oh-my-zsh) and [Powerlevel9k](https://github.com/bhilburn/powerlevel9k).

## Install

**Files that would have been overwriten are moved to `dotfile-backups` within the repository**

1. `git clone https://github.com/Chasbob/dotfiles.git`
2. `./dotfiles/install.sh`

For step 2 you can run `./dotfiles/install.sh -y` to accept all options and run without being prompted.


## Testing

You can use docker to test the setup with `docker run --rm -ti chasbob/dotfiles:master`
