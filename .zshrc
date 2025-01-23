typeset -U PATH

function safe_source() {
  [ -f "$1" ] && source "$1"
}

safe_source $HOME/.zprofile

if [ ! -d $HOME/.zsh/plugins ]; then 
  mkdir -p $HOME/.zsh && cd $HOME/.zsh
  git clone  --filter=blob:none --no-checkout https://github.com/Aisha630/configs.git .
  git sparse-checkout init --cone
  git sparse-checkout set plugins
  git checkout main
fi

# the readme for this plugin says to source it before other plugins
safe_source $HOME/.zsh/plugins/ez-compinit/ez-compinit.plugin.zsh

# Safe_source all plugins in the plugins directory
for plugin in $HOME/.zsh/plugins/*; do
  plugin_name=$(basename "$plugin")
  if [[ -d "$plugin" && "$plugin_name" != "zsh-history-substring-search" && "$plugin_name" != "ez-compinit" ]]; then
      safe_source "$plugin/$plugin_name.plugin.zsh"
      safe_source "$plugin/init.zsh"
      safe_source "$plugin/$plugin_name.zsh"
  fi
done

# This plugin should be safe_sourced last according to the author. Otherwise, it may not work as expected. Refer to the plugin's README for more information.
safe_source $HOME/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
zstyle ":completion:*:descriptions" format "[%d]"
zstyle ":completion:*:git-checkout:*" sort false

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^E" edit-command-line

# Aliases
function cc() python -c "from math import *; print($*)"
alias cc="noglob cc"
alias c="clear"
alias n="neofetch"
alias s="kitten ssh"
alias fzf='fzf --preview="bat --color=always {}"'
alias cpa="copypath"
alias cf="copyfile"
alias ls="lsd"
alias la="ls -la"
alias ..="cd .."
alias ...="cd ../.."
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log"j
alias gco="git checkout"
alias gcb="git checkout -b"
alias gcm="git commit -m"
alias gpo="git push origin"
alias gpl="git pull"
alias gcl="git clone"
alias gdf="git diff"
alias gsta="git stash"
alias gstp="git stash pop"
alias gbr="git branch"
alias grm="git rm"
alias grs="git reset"
alias grh="git reset --hard"
alias grs="git reset --soft"
alias gcp="git cherry-pick"
alias t="tree -L 2"
alias lst="ls -- tree --depth 2"
alias src="source"
alias e="exit"

neofetch

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

setopt share_history
setopt hist_ignore_dups  
setopt multios
setopt rm_star_silent
setopt auto_cd

eval "$(fzf --zsh)"
zstyle ":fzf-tab:complete:cd:*" fzf-preview 'lsd -1 --group-dirs-first --color=always $realpath'
eval "$(zoxide init zsh)"



