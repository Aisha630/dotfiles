# 🖥️ My Custom Terminal Configuration

This repository houses my personalized terminal setup, encompassing Zsh shell configurations, Kitty terminal emulator settings, Neofetch system information display customizations, LSD (LSDeluxe) configurations, and a custom Oh My Posh theme. The objective is to achieve a harmonious blend of aesthetics, functionality, and performance for an optimized terminal experience.

## Dotfiles Management with GNU Stow

I use [GNU Stow](https://www.gnu.org/software/stow/) to manage my dotfiles. This repository is what I upload to GitHub, and I manually use `stow` to symlink the configuration directories and files into my home directory (e.g., `~/.config`, `/.zshrc` etc).

**Example usage:**

```bash
cd ~/dotfiles
stow .
```

This approach keeps my home directory clean and makes it easy to update or remove configurations.

If you want to use this method, make sure you have `stow` installed (`brew install stow` on macOS).

To bring this config to any ssh session, we can utilize [xxh](https://github.com/xxh/xxh)

## Repository Structure

```
├── .config/
│   ├── kitty/          # Kitty terminal emulator configuration
│   ├── lsd/            # LSD (LSDeluxe) color and display settings
│   ├── neofetch/       # Neofetch system info display config
│   └── oh-my-posh-theme/  # Custom Oh My Posh theme (heavily inspired by kushal.omp.json)
├── .zprofile           # Zsh login shell configuration
├── .zshrc              # Zsh interactive shell configuration
├── install.sh          # Automated installation script
└── README.md           # This file
```

---

## Quick Start

### Automated Installation

The easiest way to set up this configuration is using the provided installation script:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

The install script will:

- Detect your operating system and package manager
- Install Zsh (if not already installed)
- Install required tools: `lsd`, `fzf`, `zoxide`, `bat`, `kitty`, `neofetch`, `oh-my-posh`
- Install and configure Zsh plugins
- Offer to set Zsh as your default shell

### Manual Installation

If you prefer manual installation, see the [detailed installation section](#-installation) below.

---

## Why Zsh?

[Zsh](https://www.zsh.org/) (Z shell) is a powerful and highly customizable Unix shell that offers advanced features such as:

- Command auto-completion
- Syntax highlighting
- History search
- Enhanced scripting capabilities

I chose Zsh for its flexibility and modern features, making it an excellent choice for developers and power users.

---

![My File](https://drive.google.com/uc?export=view&id=1FZAXmt2VturbdY5C8RPmNv73mLExTjTW)![Screenshot](https://drive.google.com/uc?export=view&id=1TWSRzmv2hiZpu4Q5z-doyHypL4yA2XyO)

## Journey to the Current Setup

### Initial Setup: Oh My Zsh

Initially, I used [Oh My Zsh](https://ohmyz.sh/), a popular open-source framework for managing Zsh configurations. Oh My Zsh provides a wide array of themes and plugins that enhance the terminal experience. Some key benefits of Oh My Zsh:

- Easy installation and management of plugins
- A large community with extensive resources
- Pre-configured themes for aesthetics and productivity

#### Why I Removed Oh My Zsh

While Oh My Zsh is great, I found it to be **too heavy** for my needs. Specifically:

1. **Slow Terminal Startup**: Oh My Zsh added noticeable delays to the terminal startup time.
2. **Redundant Features**: Many of its features were overkill for my use case, and I wanted a leaner setup.

---

### Current Setup: Lean and Fast

After removing Oh My Zsh, I designed my `.zshrc` to include only the necessary plugins and features:

- Direct sourcing of plugins from a custom `~/.zsh/plugins/` directory
- Optimized aliases for frequently used commands
- Integration with tools like `fzf`, `neofetch`, and `oh-my-posh`

The result? **A terminal that is significantly faster without compromising on functionality.**

---

### Plugins Overview

The configuration includes the following optimized Zsh plugins:

**1. Fast Syntax Highlighting**

- **Location**: `~/.zsh/plugins/fast-syntax-highlighting`
- **Features**: High-performance syntax highlighting for commands, improving readability and reducing errors.

**2. Autosuggestions**

- **Location**: `~/.zsh/plugins/zsh-autosuggestions`
- **Features**: Suggests commands as you type based on your command history, saving time and effort.

**3. History Substring Search**

- **Location**: `~/.zsh/plugins/zsh-history-substring-search`
- **Features**: Enables searching through command history using substrings with arrow keys.

**4. FZF Tab Completion**

- **Location**: `~/.zsh/plugins/fzf-tab`
- **Features**: Replaces default tab completion with fuzzy search interface.

**5. Auto Notify**

- **Location**: `~/.zsh/plugins/auto-notify`
- **Features**: Sends desktop notifications upon command completion, especially for long-running commands.

**6. EZ Compinit**

- **Location**: `~/.zsh/plugins/ez-compinit`
- **Features**: Optimized completion initialization for faster shell startup.

**7. Additional Tools**

The configuration also includes these essential command-line tools:

- **Zoxide**: Smart directory jumper that learns your habits (`z` command)
- **FZF**: Command-line fuzzy finder for files, history, and more
- **Bat**: Enhanced `cat` command with syntax highlighting
- **LSD**: Modern replacement for `ls` with colors and icons

---

## Installation

### Option 1: Automated Installation (Recommended)

1. Clone this repository:

   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```
2. Make the install script executable and run it:

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

The script will automatically:

- Detect your OS and package manager (Homebrew, apt, dnf, pacman)
- Install Zsh if not present
- Install all required tools and dependencies
- Clone and configure Zsh plugins
- Set up logging in `~/.zsh_install.log`

### Option 2: Manual Installation

If you prefer to install components manually:

1. **Install Dependencies**:

   ```bash
   # macOS
   brew install zsh lsd fzf zoxide bat kitty neofetch oh-my-posh

   # Ubuntu/Debian
   sudo apt install zsh lsd fzf zoxide bat kitty neofetch

   # Install oh-my-posh separately
   sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
   sudo chmod +x /usr/local/bin/oh-my-posh
   ```
2. **Clone Zsh Plugins**:

   ```bash
   mkdir -p ~/.zsh/plugins

   # Clone each plugin
   git clone https://github.com/MichaelAquilina/zsh-auto-notify.git ~/.zsh/plugins/auto-notify
   git clone https://github.com/mattmc3/ez-compinit.git ~/.zsh/plugins/ez-compinit
   git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ~/.zsh/plugins/fast-syntax-highlighting
   git clone https://github.com/Aloxaf/fzf-tab.git ~/.zsh/plugins/fzf-tab
   git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/plugins/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.zsh/plugins/zsh-history-substring-search
   ```
3. **Copy Configuration Files**:

   ```bash
   # Copy Zsh configuration
   cp .zshrc ~/.zshrc
   cp .zprofile ~/.zprofile

   # Copy application configs
   mkdir -p ~/.config
   cp -r .config/kitty ~/.config/
   cp -r .config/lsd ~/.config/
   cp -r .config/neofetch ~/.config/
   cp -r .config/oh-my-posh-theme ~/.config/
   ```
4. **Set Zsh as Default Shell** (if needed):

   ```bash
   chsh -s $(which zsh)
   ```
5. **Restart your terminal or source the configuration**:

   ```bash
   source ~/.zshrc
   ```

---

### ⚙️ Key Variables

#### Environment

- `HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND`: Customizes the highlight color for history substring matches.

## What is `.zprofile`?

The `.zprofile` file is executed during the **login** phase of a Zsh shell session. This makes it ideal for setting environment variables and configurations that need to be available globally, even when scripts or non-interactive shell sessions run.

In contrast to `.zshrc`, which is executed for **interactive** shells, `.zprofile` is best suited for login-specific setups.

#### How I Use `.zprofile`

In this configuration, `.zprofile` is used to set:

- **Environment Variables**: Global paths and variables that need to be consistent across sessions.
- **Initialization Commands**: Commands that should run only once when the shell starts as a login shell.
- **Custom `ZDOTDIR`**: Redirects Zsh to use a custom directory for its configuration files.

#### Example `.zprofile`:

```zsh
# Set ZDOTDIR to use a custom configuration directory
export ZDOTDIR="$HOME/.config/zsh"

# Add custom paths
export PATH="$HOME/bin:$PATH"

# Initialize environment variables for tools like Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set default editor
export EDITOR="nvim"

# Load the .zshrc explicitly
source "$ZDOTDIR/.zshrc"
```

#### Why Use `.zprofile`?

1. **Environment Setup**: Variables like `PATH`, `EDITOR`, or `LANG` are set once and globally.
2. **Compatibility**: Ensures non-interactive or script sessions also have the necessary environment variables.
3. **Separation of Concerns**: Keeps login-related configurations distinct from interactive shell settings.

#### Why Separate `.zprofile` and `.zshrc`?

Keeping `.zprofile` and `.zshrc` separate allows for cleaner and more maintainable configurations:

- **`.zprofile`**: Global setup for login shells, environment variables, and system-wide commands.
- **`.zshrc`**: Interactive shell configurations, such as aliases, functions, and prompts.

This separation ensures that login-only settings do not clutter the interactive session configuration and vice versa.

### Installation Logs

The automated installer creates logs at `~/.zsh_install.log` for debugging failed installations.
