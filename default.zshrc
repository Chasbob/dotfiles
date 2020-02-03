if [[ "$ZPROF" = true ]]; then
  zmodload zsh/zprof
fi

export LC_ALL="en_GB.UTF-8"
export LANG="en_GB.UTF-8"

export EDITOR="vim"
export VISUAL="vim"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Declare path pointing to the dotfiles repository
if [[ -z "$DOTFILES_ROOT" ]]; then
        echo setting DOTFILES_ROOT=$HOME/dotfiles
        DOTFILES_ROOT=$HOME/dotfiles
fi

# Check if ssh-agent needs to be setup
if [ -z "$SSH_AUTH_SOCK" ]; then
        echo setting ssh agent
        eval "$(ssh-agent -s)"
        ssh-add
fi

# Change this to reflect your username.
DEFAULT_USER='charlie'


POWERLEVEL9K_SHORTEN_DIR_LENGTH=1



# Setup history
. "$DOTFILES_ROOT/hist"

# Setup zsh styles
. "$DOTFILES_ROOT/zstyles"

# Setup PATH
. "$DOTFILES_ROOT/paths"

# Setup CDPATH for directory completion
. "$DOTFILES_ROOT/cdpath"

# Setup functions
. "$DOTFILES_ROOT/funcs"

# Setup aliases
. "$DOTFILES_ROOT/aliases"

# Setup bindkeys
. "$DOTFILES_ROOT/bindkeys"

# Setup powerlevel10k
. $DOTFILES_ROOT/powerlevel10k/powerlevel10k.zsh-theme

# Setup zsh auto suggestions
. $DOTFILES_ROOT/zsh-autosuggestions/zsh-autosuggestions.zsh

# Setup colour to use for zsh suggestions
# forground colour of yellow with black
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#ffff00,bg=black,bold,underline'


# Setup zsh syntax highlighting
. $DOTFILES_ROOT/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Add zsh-completions to completions path
fpath=(
  $DOTFILES_ROOT/zsh-completions/src
  $DOTFILES_ROOT/completion
  "${fpath[@]}"
)

autoload -Uz compinit
compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# If using `p10k configure` you will need to update $DOTFILES_ROOT/p10k.zsh to reflect this
# I think it just overwrites the file so no use in linking it
source $DOTFILES_ROOT/p10k.zsh

# ZSH_AUTOSUGGEST_USE_ASYNC=true


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/charlie/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/charlie/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/charlie/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/charlie/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

if [[ "$ZPROF" = true ]]; then
  echo test
  zprof
fi