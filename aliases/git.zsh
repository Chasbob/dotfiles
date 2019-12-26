#!/bin/sh

alias gc="git commit"
alias gs="git status"
alias ga="git add"
alias ggo="git remote get-url origin"

function fix-author(){
    git filter-branch --env-filter '
    WRONG_EMAIL="$1"
    NEW_NAME="$2"
    NEW_EMAIL="$3"

    if [ "$GIT_COMMITTER_EMAIL" = "$WRONG_EMAIL" ]
    then
        echo "$GIT_COMMITTER_EMAIL"
        export GIT_COMMITTER_NAME="$NEW_NAME"
        export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
    fi
    if [ "$GIT_AUTHOR_EMAIL" = "$WRONG_EMAIL" ]
    then
        export GIT_AUTHOR_NAME="$NEW_NAME"
        export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
    fi
    ' --tag-name-filter cat -- --branches --tags
}

function git-sign-history(){
    # $1 is the branch to process
    # currently hard coded for dotfiles repo
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME rebase --exec '/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME commit --amend --no-edit -n -S' -i "$1"
}
