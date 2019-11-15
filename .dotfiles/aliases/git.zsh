#!/bin/sh

alias gc="git commit"
alias gs="git status"
alias ga="git add"
alias ggo="git remote get-url origin"

function fix-author(){
        git filter-branch -f --env-filter '

        OLD_EMAIL="charles.defreitas@progressiveaccess.com"
        CORRECT_EMAIL="charles@defreitas.io"

        if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
        then
            export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
        fi
        if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
        then
            export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
        fi
        ' --tag-name-filter cat -- --branches --tags
}
