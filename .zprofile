eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(oh-my-posh init zsh --config /Users/aisha/.config/oh-my-posh-theme/aysha.omp.json)"

HISTFILE=$HOME/.zsh_history      
SAVEHIST=100000 
HISTSIZE=5000
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=yellow,fg=black,bold'

export PATH="$HOME/google-cloud-sdk/bin:/usr/local/go/bin:$PATH:$HOME/go/bin"
export EDITOR="nvim"
export AUTO_NOTIFY_THRESHOLD=10
export LS_COLORS="di=34:ln=31:so=31:pi=33:ex=31:bd=31:cd=111:su=31:sg=31:tw=31:ow=31:fi=35:*.json=36:*.txt=10:*png=33:*jpg=33:*jpeg=33"
export HOMEBREW_NO_AUTO_UPDATE=1

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# pnpm
export PNPM_HOME="/Users/aisha/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
