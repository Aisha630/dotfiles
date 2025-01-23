eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(oh-my-posh init zsh --config /Users/aisha/.config/oh-my-posh-theme/kushal.omp.json)"

HISTFILE=$HOME/.zsh_history      
SAVEHIST=100000 
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=yellow,fg=black,bold'

export PATH="$HOME/google-cloud-sdk/bin:$PATH"
export EDITOR="nvim"
export AUTO_NOTIFY_THRESHOLD=10
export LS_COLORS="di=34:ln=31:so=31:pi=33:ex=31:bd=31:cd=111:su=31:sg=31:tw=31:ow=31:fi=35:*.json=36:*.txt=10:*png=33:*jpg=33:*jpeg=33"
export HOMEBREW_NO_AUTO_UPDATE=1
