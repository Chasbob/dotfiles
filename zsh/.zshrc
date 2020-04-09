# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# If using `p10k configure` you will need to update p10k.zsh to reflect this
# I think it just overwrites the file so no use in linking it
. "$ZDOTDIR/p10k.zsh"

# Check if ssh-agent needs to be setup
if [ -z "$SSH_AUTH_SOCK" ]; then
        echo setting ssh agent
        eval "$(ssh-agent -s)"
        ssh-add
fi

# Add zsh-completions to completions path
fpath=(
  "$ZDOTDIR/zsh-completions/src"
  "$ZDOTDIR/completion"
  "${fpath[@]}"
)

# Setup completions
autoload -Uz compinit
compinit

# Change this to reflect your username.
DEFAULT_USER='charlie'

# Setup history
. "$ZDOTDIR/hist"

# Setup zsh styles
. "$ZDOTDIR/zstyles"

# Setup PATH
. "$ZDOTDIR/paths"

# Setup CDPATH for directory completion
. "$ZDOTDIR/cdpath"

# Setup functions
. "$ZDOTDIR/funcs"

# Setup aliases
. "$ZDOTDIR/aliases"

# Setup bindkeys
. "$ZDOTDIR/bindkeys"

# Setup powerlevel10k
. "$ZDOTDIR/powerlevel10k/powerlevel10k.zsh-theme"

# Setup zsh auto suggestions
. "$ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
# Setup interactive cd
. "$ZDOTDIR/zsh-interactive-cd.plugin.zsh"

. "$ZDOTDIR/forgit.plugin.zsh"

# Setup colour to use for zsh suggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#ffff00,bold,underline'


# Setup zsh syntax highlighting
. "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# https://sdkman.io/install
export SDKMAN_DIR="$HOME/.config/sdkman"
[[ -s "$HOME/.config/sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.config/sdkman/bin/sdkman-init.sh"

# https://github.com/pindexis/marker
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

# direnv hook
# https://direnv.net/docs/installation.html
eval "$(direnv hook zsh)"
