# Sourced for every zsh, including non-interactive; interactive-only setup goes in .zshrc

typeset -U PATH path # dedupe PATH in every shell, not just interactive ones

if command -v nvim >/dev/null; then
  export EDITOR=nvim
elif command -v vim >/dev/null; then
  export EDITOR=vim
else
  export EDITOR=vi
fi

export LS_COLORS="di=34:ln=31:so=31:pi=33:ex=31:bd=31:cd=111:su=31:sg=31:tw=31:ow=31:fi=35:*.json=36:*.txt=10:*png=33:*jpg=33:*jpeg=33"
export AUTO_NOTIFY_THRESHOLD=10
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}'"

# fzf's built-in walker ignores .gitignore; fd doesn't. guarded because debian names the binary fdfind
if command -v fd >/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND # ctrl-t blanks FZF_DEFAULT_COMMAND unless this is set too
  export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
fi
