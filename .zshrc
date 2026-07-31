bindkey -e # emac bindings
autoload zmv # makes moving files better

function safe_source() {
  [ -f "$1" ] && source "$1"
}

function _copy_to_clipboard(){
  if command -v pbcopy > /dev/null; then
    pbcopy
  elif command -v xclip > /dev/null; then
    xclip -selection clipboard
  elif command -v wl-copy >/dev/null; then
    wl-copy
  else
    return 1
  fi
}


# copy file contents to clipboard
function copyfile {
  local file="${1}"
  [[ $file = /* ]] || file="$PWD/$file"

  [[ -s "$file" ]] || { echo "File not found or is empty: ${file}"; return 1; }

  if cat "$file" | _copy_to_clipboard; then 
    echo "Contents of ${file} copied to clipboard."
  else
    echo "No clipboard available. Failed to copy ${file} to clipboard."
    return 1
  fi
}

# copy absolute path of file to clipboard else if no file is provided, copy the current directory's path
function copypath {
  local file="${1:-.}"

  [[ -e "${file:a}" ]] || { echo "File not found: ${file}"; return 1; }

  if print -rn "${file:a}" | _copy_to_clipboard; then
    echo "Absolute path ${file:a} copied to clipboard."
  else
    echo "No clipboard available. Failed to copy ${file:a} to clipboard."
    return 1
  fi
}

# the readme for this plugin says to source it before other plugins
safe_source $HOME/.zsh/plugins/ez-compinit/ez-compinit.plugin.zsh

eval "$(fzf --zsh)"
zstyle ":fzf-tab:complete:cd:*" fzf-preview 'lsd -1 --group-dirs first --color=always $realpath'
eval "$(zoxide init zsh)"

# source all plugins in $HOME/.zsh/plugins/
for plugin in $HOME/.zsh/plugins/*; do
  plugin_name=$(basename "$plugin")
  if [[ -d "$plugin" && "$plugin_name" != "zsh-history-substring-search" && "$plugin_name" != "ez-compinit" ]]; then
      safe_source "$plugin/$plugin_name.plugin.zsh"
      safe_source "$plugin/init.zsh"
      safe_source "$plugin/$plugin_name.zsh"
  fi
done

# This plugin should be sourced last according to the author. Otherwise, it may not work as expected. Refer to the plugin's README for more information.
safe_source $HOME/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey "$terminfo[kcud1]" history-substring-search-down

# completion settings
zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
zstyle ":completion:*:descriptions" format "[%d]"
zstyle ":completion:*:git-checkout:*" sort false

# edit command line in editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^E" edit-command-line

# Aliases
function cc() python3 -c "from math import *; print($*)"
alias cc="noglob cc"
alias c="clear"
alias n="neofetch"
alias ss="kitten ssh"
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
alias gr="git reset"
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

setopt share_history      # import + append history live, so all open shells share one list
setopt hist_ignore_dups   # skip a command if it repeats the one before it
setopt multios            # implicit tee/cat on multiple redirections (> a > b)
setopt rm_star_silent     # don't ask for confirmation on `rm *`
setopt auto_cd            # a bare directory name cd's into it
setopt NO_NOMATCH         # leave a glob with no matches as-is instead of erroring
setopt HIST_REDUCE_BLANKS # strip superfluous whitespace before saving to history
setopt HIST_EXPAND        # bash-compat alias for BANG_HIST (!! expansion) -- already zsh default
setopt HIST_VERIFY        # after a ! expansion, reload the line for editing instead of running it

HISTFILE=$HOME/.zsh_history      
SAVEHIST=100000 
HISTSIZE=5000
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=yellow,fg=black,bold'
UNDO_LIMIT_NO=40

bindkey ' ' magic-space
bindkey '^[/' undo      # Alt + /
bindkey '^[?' redo      # Alt + Shift + /
safe_source $HOME/.zsh/local.zsh # machine-specific setup, untracked

neofetch
