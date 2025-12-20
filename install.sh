#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$HOME/.zsh/plugins"
LOG_FILE="$HOME/.zsh_install.log"

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log()   { echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"; }
error() { echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE" >&2; }

detect_package_manager() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    command -v brew >/dev/null && { echo brew; return; }
    error "Homebrew not found. Please install it first."; exit 1
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if   command -v apt   >/dev/null; then echo apt
    elif command -v dnf   >/dev/null; then echo dnf
    elif command -v pacman>/dev/null; then echo pacman
    else error "No supported package manager found"; exit 1; fi
  else
    error "Unsupported OS: $OSTYPE"; exit 1
  fi
}

PKG_MANAGER=$(detect_package_manager)

cp -r ./.config ~/

# ---- plugin map ----
declare -A plugins=(
  ["auto-notify"]="https://github.com/MichaelAquilina/zsh-auto-notify.git"
  ["ez-compinit"]="https://github.com/mattmc3/ez-compinit.git"
  ["fast-syntax-highlighting"]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
  ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab.git"
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
  log "Installing $package..."
  case "$PKG_MANAGER" in
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
      sudo pacman -Sy --noconfirm "$package"
      ;;
    *) error "Unsupported package manager: $PKG_MANAGER"; return 1;;
  esac
}

install_zsh() {
  if command -v zsh >/dev/null 2>&1; then
    log "Zsh is already installed"
    return 0
  fi
  log "Installing Zsh..."
  install_package zsh
  if command -v zsh >/dev/null 2>&1; then
    log "Zsh installed successfully!"
    if [[ "${SHELL:-}" != *"zsh"* ]]; then
      warn "Zsh is not your default shell. Current shell: ${SHELL:-unknown}"
      read -p "Set zsh as your default shell? (y/N): " -r
      if [[ $REPLY =~ ^[Yy]$ ]]; then chsh -s "$(command -v zsh)"; log "Default shell changed to zsh. Restart your terminal."; fi
    fi
  else
    error "Failed to install Zsh"; exit 1
  fi
}

install_tools() {
  log "Installing required tools…"
  local tools=(lsd fzf zoxide bat kitty neofetch neovim tmux)
  local failed=()
  for tool in "${tools[@]}"; do
    if ! install_package "$tool"; then failed+=("$tool"); fi
  done
  if [[ ${#failed[@]} -gt 0 ]]; then error "Failed to install: ${failed[*]}"; else log "All tools installed successfully!"; fi
}

clone_tpm() {
  local tpm_dir="$HOME/.config/tmux/plugins/tpm"
  if [[ -d "$tpm_dir" ]]; then
    log "Tmux Plugin Manager (TPM) already installed"
    return 0
  fi
  log "Installing Tmux Plugin Manager (TPM)…"
  if git clone --quiet https://github.com/tmux-plugins/tpm "$tpm_dir"; then
    log "TPM installed successfully!"
  else
    error "Failed to install TPM"; 
  fi
}

clone_nvchad(){
  local nvim_config_dir="$HOME/.config/nvim"
  if [[ -d "$nvim_config_dir" ]]; then
    log "NvChad already installed"
    return 0
  fi
  log "Installing NvChad…"
  if git clone --quiet https://github.com/NvChad/NvChad "$nvim_config_dir"; then
    log "NvChad installed successfully!"
  else
    error "Failed to install NvChad"; 
  fi  
}

clone_plugin() {
  local plugin="$1" repo_url="$2" plugin_path="$PLUGIN_DIR/$plugin"
  if [[ -d "$plugin_path" ]]; then
    log "Plugin '$plugin' exists, updating…"
    if (cd "$plugin_path" && git pull --quiet); then log "Updated '$plugin'"; else warn "Failed to update '$plugin'"; fi
    return 0
  fi
  log "Installing '$plugin' from $repo_url…"
  if git clone --quiet --depth 1 "$repo_url" "$plugin_path"; then log "Installed '$plugin'"; else error "Failed to install '$plugin'"; return 1; fi
}

install_plugins() {
  log "Creating plugin dir: $PLUGIN_DIR"
  mkdir -p "$PLUGIN_DIR"
  log "Installing Zsh plugins…"
  local failed=()
  for plugin in "${!plugins[@]}"; do
    if ! clone_plugin "$plugin" "${plugins[$plugin]}"; then failed+=("$plugin"); fi
  done
  if [[ ${#failed[@]} -gt 0 ]]; then warn "Failed plugins: ${failed[*]}"; fi
  log "Plugin installation completed!"
}

main() {
  log "OS: $OSTYPE"
  log "Package Manager: $PKG_MANAGER"
  log "Log file: $LOG_FILE"

  if ! command -v git >/dev/null 2>&1; then error "Git is required but not installed"; exit 1; fi

  install_zsh
  install_tools
  install_plugins

  log "Installation completed successfully!"
  echo
  echo -e "${GREEN}Next steps:${NC}"
  echo "1) Restart your terminal OR run: exec zsh"
}

main "$@"
