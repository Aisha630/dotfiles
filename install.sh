#!/bin/bash
PLUGIN_DIR="$HOME/.zsh/plugins"

declare -A plugins=(
    ["auto-notify"]="https://github.com/MichaelAquilina/zsh-auto-notify.git"
    ["ez-compinit"]="https://github.com/zdharma-continuum/zinit-annex-ez-compinit.git"
    ["fast-syntax-highlighting"]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
    ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab.git"
    ["safe-paste"]="https://github.com/zdharma-continuum/safe-paste.git"
    ["sudo"]="https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo"
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
    ["zsh-history-substring-search"]="https://github.com/zsh-users/zsh-history-substring-search.git"
)

install_zsh() {
    if ! command -v zsh &>/dev/null; then
        echo "Zsh is not installed. Installing Zsh..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt update && sudo apt install -y zsh || sudo yum install -y zsh || sudo dnf install -y zsh
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install zsh
        else
            echo "Unsupported OS. Please install Zsh manually."
            exit 1
        fi

        if command -v zsh &>/dev/null; then
            echo "Zsh installed successfully!"
        else
            echo "Failed to install Zsh. Please install it manually."
            exit 1
        fi
    else
        echo "Zsh is already installed."
    fi
}

install_zsh
mkdir -p "$PLUGIN_DIR"

echo "Installing Zsh plugins in $PLUGIN_DIR..."

for plugin in "${!plugins[@]}"; do
    plugin_path="$PLUGIN_DIR/$plugin"
    repo_url="${plugins[$plugin]}"

    if [ ! -d "$plugin_path" ]; then
        echo "Installing '$plugin' from $repo_url..."
        git clone "$repo_url" "$plugin_path"
        if [ $? -eq 0 ]; then
            echo "Successfully installed '$plugin'."
        else
            echo "Failed to install '$plugin'."
        fi
    fi
done

echo "All plugins are installed!"
