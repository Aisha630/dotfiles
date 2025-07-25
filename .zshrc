typeset -U PATH

function safe_source() {
  [ -f "$1" ] && source "$1"
}

safe_source $HOME/.zprofile

function copyfile {
  local file="${1}"
  [[ $file = /* ]] || file="$PWD/$file"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    cat "$file" | pbcopy
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cat "$file" | xclip -selection clipboard
  fi

  echo "Contents of ${file} copied to clipboard."
}

function copypath {
  local file="${1:-.}"
  [[ $file = /* ]] || file="$PWD/$file"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    print -n "${file:a}" | pbcopy
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -n "${file:a}" | xclip -selection clipboard
  fi
  echo "Absolute path ${file:a} copied to clipboard."
}

# the readme for this plugin says to source it before other plugins
safe_source $HOME/.zsh/plugins/ez-compinit/ez-compinit.plugin.zsh

eval "$(fzf --zsh)"
# make tab completions better
zstyle ":fzf-tab:complete:cd:*" fzf-preview 'lsd -1 --group-dirs first --color=always $realpath'
eval "$(zoxide init zsh)"

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
alias ss="kitten ssh"
alias fzf='fzf --preview="bat --style=numbers --color=always {}"'
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
alias gl="git log"
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
alias tre="tree -L 2"
alias src="source"
alias e="exit"
alias tl="tmux ls"
alias ta="tmux attach -t"
alias tn="tmux new -s"
alias tk="tmux kill-session -t"
alias tks="tmux kill-server"

neofetch

setopt share_history
setopt hist_ignore_dups  
setopt multios
setopt rm_star_silent
setopt auto_cd
setopt NO_NOMATCH

