#!/usr/bin/env bash
set -euo pipefail

plugin_dir="$HOME/.zsh/plugins"
log_file="$HOME/.zsh_install.log"

readonly red='\033[0;31m'
readonly green='\033[0;32m'
readonly yellow='\033[1;33m'
readonly blue='\033[0;34m'
readonly nc='\033[0m'

log()   { echo -e "${green}[info]${nc} $1" | tee -a "$log_file"; }
warn()  { echo -e "${yellow}[warn]${nc} $1" | tee -a "$log_file"; }
error() { echo -e "${red}[error]${nc} $1" | tee -a "$log_file" >&2; }

detect_package_manager() {
  if [[ "$ostype" == "darwin"* ]]; then
    command -v brew >/dev/null && { echo brew; return; }
    error "homebrew not found. please install it first."; exit 1
  elif [[ "$ostype" == "linux-gnu"* ]]; then
    if   command -v apt   >/dev/null; then echo apt
    elif command -v dnf   >/dev/null; then echo dnf
    elif command -v pacman>/dev/null; then echo pacman
    else error "no supported package manager found"; exit 1; fi
  else
    error "unsupported os: $ostype"; exit 1
  fi
}

pkg_manager=$(detect_package_manager)

cp -r ./.config ~/

# ---- plugin map ----
declare -a plugins=(
  ["auto-notify"]="https://github.com/michaelaquilina/zsh-auto-notify.git"
  ["ez-compinit"]="https://github.com/mattmc3/ez-compinit.git"
  ["fast-syntax-highlighting"]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
  ["fzf-tab"]="https://github.com/aloxaf/fzf-tab.git"
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
  ["zsh-history-substring-search"]="https://github.com/zsh-users/zsh-history-substring-search.git"
  ["zsh-sudo"]="https://github.com/none9632/zsh-sudo.git"
)

install_package() {
  local package="$1"
  if command -v "$package" >/dev/null 2>&1; then
    log "$package is already installed"
    return 0
  fi
  log "installing $package..."
  case "$pkg_manager" in
    brew)
      brew install "$package"
      if [[ "$package" == "fzf" ]]; then
        "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish
      fi
      ;;
    apt)
      sudo apt update
      sudo apt install -y "$package"
      ;;
    dnf)
      sudo dnf install -y "$package"
      ;;
    pacman)
      sudo pacman -sy --noconfirm "$package"
      ;;
    *) error "unsupported package manager: $pkg_manager"; return 1;;
  esac
}

install_zsh() {
  if command -v zsh >/dev/null 2>&1; then
    log "zsh is already installed"
    return 0
  fi
  log "installing zsh..."
  install_package zsh
  if command -v zsh >/dev/null 2>&1; then
    log "zsh installed successfully!"
    if [[ "${shell:-}" != *"zsh"* ]]; then
      warn "zsh is not your default shell. current shell: ${shell:-unknown}"
      read -p "set zsh as your default shell? (y/n): " -r
      if [[ $reply =~ ^[yy]$ ]]; then chsh -s "$(command -v zsh)"; log "default shell changed to zsh. restart your terminal."; fi
    fi
  else
    error "failed to install zsh"; exit 1
  fi
}

install_tools() {
  log "installing required tools…"
  local tools=(lsd fzf zoxide bat neofetch neovim tmux htop fd ripgrep superfile atuin) # TODO: Change fd to fd-find for linux
  local failed=()
  for tool in "${tools[@]}"; do
    if ! install_package "$tool"; then failed+=("$tool"); fi
  done
  if [[ ${#failed[@]} -gt 0 ]]; then error "failed to install: ${failed[*]}"; else log "all tools installed successfully!"; fi
}

clone_tpm() {
  local tpm_dir="$home/.config/tmux/plugins/tpm"
  if [[ -d "$tpm_dir" ]]; then
    log "tmux plugin manager (tpm) already installed"
    return 0
  fi
  log "installing tmux plugin manager (tpm)…"
  if git clone --quiet https://github.com/tmux-plugins/tpm "$tpm_dir"; then
    log "tpm installed successfully!"
  else
    error "failed to install tpm"; 
  fi
}

clone_nvchad(){
  local nvim_config_dir="$home/.config/nvim"
  if [[ -d "$nvim_config_dir" ]]; then
    log "nvchad already installed"
    return 0
  fi
  log "installing nvchad…"
  if git clone --quiet https://github.com/nvchad/nvchad "$nvim_config_dir"; then
    log "nvchad installed successfully!"
  else
    error "failed to install nvchad"; 
  fi  
}

clone_plugin() {
  local plugin="$1" repo_url="$2" plugin_path="$plugin_dir/$plugin"
  if [[ -d "$plugin_path" ]]; then
    log "plugin '$plugin' exists, updating…"
    if (cd "$plugin_path" && git pull --quiet); then log "updated '$plugin'"; else warn "failed to update '$plugin'"; fi
    return 0
  fi
  log "installing '$plugin' from $repo_url…"
  if git clone --quiet --depth 1 "$repo_url" "$plugin_path"; then log "installed '$plugin'"; else error "failed to install '$plugin'"; return 1; fi
}

install_plugins() {
  log "creating plugin dir: $plugin_dir"
  mkdir -p "$plugin_dir"
  log "installing zsh plugins…"
  local failed=()
  for plugin in "${!plugins[@]}"; do
    if ! clone_plugin "$plugin" "${plugins[$plugin]}"; then failed+=("$plugin"); fi
  done
  if [[ ${#failed[@]} -gt 0 ]]; then warn "failed plugins: ${failed[*]}"; fi
  log "plugin installation completed!"
}

main() {
  log "os: $ostype"
  log "package manager: $pkg_manager"
  log "log file: $log_file"

  if ! command -v git >/dev/null 2>&1; then error "git is required but not installed"; exit 1; fi

  install_zsh
  install_tools
  install_plugins

  log "installation completed successfully!"
  echo
  echo -e "${green}next steps:${nc}"
  echo "1) restart your terminal or run: exec zsh"
}

main "$@"
