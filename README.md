# 🖥️ My Custom Terminal Configuration

This repository houses my personalized terminal setup, encompassing Zsh shell configurations, Kitty terminal emulator settings, Neofetch system information display customizations, and a bespoke Oh My Posh theme. The objective is to achieve a harmonious blend of aesthetics, functionality, and performance for an optimized terminal experience.

To bring this config to any ssh session, we can utilize [xxh](https://github.com/xxh/xxh.git).

---

## 🎯 Why Zsh?

[Zsh](https://www.zsh.org/) (Z shell) is a powerful and highly customizable Unix shell that offers advanced features such as:

- Command auto-completion
- Syntax highlighting
- History search
- Enhanced scripting capabilities

I chose Zsh for its flexibility and modern features, making it an excellent choice for developers and power users.

---

![Screenshot](https://drive.google.com/uc?export=view&id=1TWSRzmv2hiZpu4Q5z-doyHypL4yA2XyO)

## 🚀 Journey to the Current Setup

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

### Extracting Essential Plugins

Before removing Oh My Zsh, I identified certain plugins that were invaluable for my workflow. For example:

- **`copyfile`**: A plugin for quickly copying file paths to the clipboard.
- **`copypath`**: A plugin for copying directory paths to the clipboard.

I manually copied these plugins into my custom plugins folder (`~/.zsh/plugins/`) and ensured they worked independently.

For these two plugins, I had to change the `clipcopy` command in their respective `.zsh` files to `pbcopy` for my Mac.

---

### Current Setup: Lean and Fast

After removing Oh My Zsh, I designed my `.zshrc` to include only the necessary plugins and features:

- Direct sourcing of plugins from a custom `~/.zsh/plugins/` directory
- Optimized aliases for frequently used commands
- Integration with tools like `fzf`, `neofetch`, and `oh-my-posh`

The result? **A terminal that is significantly faster without compromising on functionality.**

---

### Plugins Overview

**1. Syntax Highlighting**

- **Location**: `~/.config/plugins/zsh-syntax-highlighting`
- **Features**:
  - Provides real-time syntax highlighting for commands, improving readability and reducing errors.

---

**2. Autosuggestions**

- **Location**: `~/.config/plugins/zsh-autosuggestions`
- **Features**:
  - Suggests commands as you type based on your command history, saving time and effort.

---

**3. History Substring Search**

- **Location**: `~/.config/plugins/zsh-history-substring-search`
- **Features**:
  - Enables searching through command history using substrings.
  - Makes it easy to recall and reuse past commands.

---

**4. Copy File and Path**

- **Locations**:
  - `~/.config/plugins/copyfile`
  - `~/.config/plugins/copypath`
- **Features**:
  - `copyfile`: Copies file contents directly to the clipboard.
  - `copypath`: Copies file paths to the clipboard.

---

**5. FZF**

- **Location**: `~/.config/plugins/fzf`
- **Features**:
  - Provides a fast, interactive fuzzy search for files, directories, and commands.
  - Integrates seamlessly with Zsh for better navigation.

---

**6. Safe Paste**

- **Location**: `~/.config/plugins/safe-paste`
- **Features**:
  - Prevents accidental execution of commands when pasting into the terminal.
  - Enhances security by requiring confirmation before running pasted commands.

---

**7. Sudo**

- **Location**: `~/.config/plugins/sudo`
- **Features**:
  - Allows quick appending of `sudo` to the beginning of a command using the `ESC` key by hitting it twice.

---

**8. Web Search**

- **Location**: `~/.config/plugins/web-search`
- **Features**:
  - Enables performing quick web searches from the terminal.

---

**9. Zoxide (Directory Jumper)**

- **Location**: Install through `brew install zoxide`
- **Features**:
  - Tracks and provides shortcuts to frequently used directories.
  - Allows quick navigation to directories based on usage history.

---

**10. Auto Notify**

- **Location**: `~/.config/plugins/auto-notify`
- **Features**:
  - Sends desktop notifications upon command completion, especially for long-running commands.

---

**11. Colorize**

- **Location**: `~/.config/plugins/colorize`
- **Features**:
  - Adds color to terminal outputs for better readability.

---

**12. Interactive CD**

- **Location**: `~/.config/plugins/zsh-interactive-cd`
- **Features**:
  - Enhances directory navigation with interactive and intuitive features.
  - Provides a visual preview of available directories.

---

**13. Navigation Tools**

- **Location**: `~/.config/plugins/zsh-navigation-tools`
- **Features**:
  - Offers advanced navigation capabilities within Zsh, such as quick file browsing and selection.

---

## 🔧 Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/yourusername/zsh-config.git
   cd zsh-config
   ```
2. Back up your existing `.zshrc`:

   ```bash
   mv ~/.zshrc ~/.zshrc.backup
   ```
3. Link the custom `.zshrc`:

   ```bash
   ln -s $(pwd)/.zshrc ~/.zshrc
   ```
4. (Optional) Customize the `ZDOTDIR` if you want to store the configuration in a custom directory:

   ```bash
   export ZDOTDIR=/path/to/this/repo
   ```
5. Restart Zsh or source the `.zshrc`:

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

## **Oh My Posh**

[Oh My Posh](https://ohmyposh.dev/) is a powerful and highly customizable prompt theme engine that works with various shells, including Zsh, Bash, and PowerShell. It enables you to create stunning and functional terminal prompts, incorporating useful information like Git status, system stats, virtual environments, and more.

#### Why I Chose Oh My Posh

- **Customizability**: Oh My Posh allows you to design a prompt that suits your workflow and aesthetic preferences.
- **Lightweight**: Unlike Oh My Zsh, which can slow down terminal performance, Oh My Posh is focused solely on prompt customization.
- **Cross-Shell Support**: The same theme can be used across different shells, ensuring consistency in appearance.

---

#### Features of My Oh My Posh Theme (`kushal.omp.json`)

All icons are sourced from [Nerd fonts](https://www.nerdfonts.com/cheat-sheet).

1. **Transient Prompt**:

   - Displays a minimal secondary prompt after command execution.
   - Reduces clutter in the terminal.
   - My transient prompt is set to `\ue780`, a clean and modern arrow-like icon.
2. **Primary Prompt**:

   - Includes system and contextual information such as:
     - **OS Icon**: Dynamically shows the operating system (e.g., macOS, Linux).
     - **Git Status**: Displays branch name, changes, and sync status.
     - **Execution Time**: Highlights long-running commands with a stopwatch icon (`\uf252`).
     - **Python Virtual Environments**: Shows the active virtual environment.
   - Designed with distinct colors and symbols for each segment to improve readability.
3. **Visual Design**:

   - Powerline-style segments with vibrant colors and icons.
   - Uses `MesloLGS NF` font for compatibility with Nerd Fonts icons.
   - Custom icons for programming languages (e.g., Python, Go, Rust).

---

#### How to Install Oh My Posh

1. **Install Oh My Posh**:

   - **macOS**:
     ```bash
     brew install oh-my-posh
     ```
   - **Linux**:
     ```bash
     sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
     sudo chmod +x /usr/local/bin/oh-my-posh
     ```
   - **Windows**:
     Follow the [Windows installation guide](https://ohmyposh.dev/docs/installation/windows).
2. **Configure the Theme**:

   - Place the `kushal.omp.json` theme file in the Oh My Posh themes directory:
     ```bash
     mkdir -p ~/.poshthemes
     cp kushal.omp.json ~/.poshthemes/
     ```
3. **Set Up Zsh Integration**:
   Add the following line to your `.zshrc` file:

   ```zsh
   eval "$(oh-my-posh init zsh --config ~/.poshthemes/kushal.omp.json)"
   ```
4. **Reload the Shell**:

   ```bash
   source ~/.zshrc
   ```

---

#### Key Benefits of My Theme:

- **Visual Clarity**: Each segment is distinctly colored for easy identification.
- **Informative**: Includes Git status, Python environments, execution time, and more at a glance.
- **Minimalistic Transient Prompt**: Keeps the terminal clean and focused after commands.

#### Documentation:

- Official Documentation: [Oh My Posh Docs](https://ohmyposh.dev/docs/)
- Theme Customization Guide: [Custom Themes](https://ohmyposh.dev/docs/themes)

## **Kitty Terminal**

[Kitty](https://sw.kovidgoyal.net/kitty/) is a fast, feature-rich, GPU-accelerated terminal emulator that excels in speed, customization, and advanced features. Its design focuses on reducing latency and maximizing usability for developers and power users.

#### Why I Chose Kitty

- **GPU Acceleration**: Offloads rendering to the GPU, making it faster than most terminal emulators.
- **Advanced Features**: Supports multiple layouts, tabs, and split windows.
- **Customization**: Offers extensive theming and font configuration options.
- **Cross-Platform**: Available for macOS, Linux, and more.

---

#### Features of My `kitty.conf`

1. **Font Customizations**:

   - Font: `MesloLGS NF`, optimized for compatibility with Nerd Fonts icons.
   - Font size: `12.0`.
   - Adjusted cell height (`135%`) for better line spacing.
   - Enabled bold, italic, and bold-italic font styles for improved readability.
2. **Scrollback History**:

   - Increased scrollback buffer to `12,000` lines, allowing extensive history review.
3. **URL Handling**:

   - Highlighted URLs in `#0087bd` with a curly underline for easy identification.
   - Configured URLs to open with the default browser.
4. **Window Layouts and Margins**:

   - Predefined layouts: `Horizontal`, `Vertical`, `Grid`.
   - Zero window borders with `10px` padding for a cleaner look.
   - Placement strategy: `center`, ensuring a visually appealing terminal alignment.
5. **Keyboard Shortcuts**:

   - `Cmd+C`: Copy to clipboard.
   - `Cmd+V`: Paste from clipboard.
   - `Cmd+K`: Clear terminal up to the cursor.
   - `Cmd+M`: Minimize window (macOS).
6. **Additional Enhancements**:

   - Enabled `copy_on_select` for easier text copying.
   - Preserved window size across sessions with `remember_window_size`.

---

#### Installation

1. **Install Kitty**:

   - **macOS**:
     ```bash
     brew install --cask kitty
     ```
   - **Linux**:
     ```bash
     sudo apt install kitty
     ```
   - For other platforms, refer to the [official installation guide](https://sw.kovidgoyal.net/kitty/binary/).
2. **Configure Kitty**:

   - Create a configuration directory:
     ```bash
     mkdir -p ~/.config/kitty
     ```
   - Copy the `kitty.conf` file to the configuration directory:
     ```bash
     cp kitty.conf ~/.config/kitty/kitty.conf
     ```
3. **Reload Configuration**:

   - Apply changes without restarting Kitty by pressing:
     - `Ctrl+Shift+F5` (or `⌘+Shift+R` on macOS).
4. **Verify Configuration**:

   - Open Kitty and check if the font, scrollback, and layout customizations are applied.

---

#### Documentation and References

- [Kitty Official Documentation](https://sw.kovidgoyal.net/kitty/)
- [Kitty Configuration Guide](https://sw.kovidgoyal.net/kitty/conf/)
- [Key Bindings in Kitty](https://sw.kovidgoyal.net/kitty/keyboard-shortcuts/)

## **Neofetch**

[Neofetch](https://github.com/dylanaraps/neofetch) is a highly configurable system information tool written in Bash. It displays essential system details alongside a custom logo or ASCII art, making it an aesthetic and informative addition to your terminal.

---

#### Why I Chose Neofetch

- **Minimal Resource Usage**: Lightweight and fast, written purely in Bash.
- **Customizability**: Allows tweaking the displayed system information, formatting, and color schemes.
- **Aesthetic Appeal**: Provides a sleek overview of system stats combined with ASCII art or logos.
- **Motivational Start**: Seeing an attractive display of system details enhances the terminal experience.

---

#### Features of My `neofetch.conf`

1. **Custom Info Sections**:

   - Displayed in a structured and visually pleasing format with separators (`` icons).
   - Sections include:
     - **Distro**: Operating system details.
     - **Memory**: Usage in percentage and in GiB.
     - **Shell**: The currently active shell.
     - **Battery**: Current charge percentage and status.
     - **CPU**: Model, speed, core count, and temperature.
     - **Uptime**: Total system uptime in a shorthand format.
2. **Visual Enhancements**:

   - Enabled bold fonts and underlining for better readability.
   - Used color blocks and bars to represent system metrics like memory and disk usage.
   - Included a custom ASCII logo for macOS (`ascii_distro="macos_small"`).
3. **Progress Bars**:

   - Disk and memory usage bars:
     - `=` for total.
     - `-` for used portions.
   - Configured bar length (`15`) and dynamic coloring (`bar_color_elapsed="distro"`).
4. **ASCII Art and Color Blocks**:

   - Displayed alongside system info for visual appeal.
   - Color-coded sections with distinct hues for different metrics.
5. **Optimizations**:

   - Enabled only the most relevant details to keep the display clean.
   - Removed unnecessary information like `kernel_shorthand` and `os_arch` to reduce clutter.

---

#### Installation

1. **Install Neofetch**:

   - **macOS**:
     ```bash
     brew install neofetch
     ```
   - **Linux** (Ubuntu/Debian):
     ```bash
     sudo apt install neofetch
     ```
2. **Configure Neofetch**:

   - Create a configuration directory:
     ```bash
     mkdir -p ~/.config/neofetch
     ```
   - Copy the `neofetch.conf` file:
     ```bash
     cp neofetch.conf ~/.config/neofetch/config.conf
     ```
3. **Run Neofetch**:

   ```bash
   neofetch
   ```

---

#### Key Customization Options

- **`ascii_distro`**: Displays an ASCII logo based on the operating system. In my setup, it uses `macos_small` for a clean macOS logo.
- **`info` Sections**: Configured to display only essential system details in a visually organized format.
- **Progress Bars**: Added color and formatted to show elapsed vs. total usage in disk and memory metrics.
- **Colors**: Tweaked to align with the terminal’s overall aesthetic.

---

#### Documentation and References

- [Neofetch GitHub Repository](https://github.com/dylanaraps/neofetch)
- [Customization Guide](https://github.com/dylanaraps/neofetch/wiki/Customizing-Info)

## **LSD Utility**

The **LSD** (LSDeluxe) utility is a modern replacement for the traditional `ls` command. It provides enhanced functionality with features like colored output, icons, tree views, and improved formatting, making directory listings more informative and visually appealing.

---

#### Why I Use LSD

- **Enhanced Readability**: Adds colors and icons for files and directories.
- **Modern Design**: Clean and aesthetically pleasing output.
- **Customizable**: Fully configurable with support for themes, colors, and more.
- **Performance**: Built with Rust, it is fast and lightweight.

---

#### Key Features in My Setup

1. **Color Customization**:

   - Different colors for files, directories, and file types (e.g., `.json` files).
   - Configured through `~/.config/lsd/colors.yaml`.
2. **Icons for File Types**:

   - Icons added next to file and directory names for quick identification.
   - Supports various icon themes.
3. **Tree View**:

   - Lists directories in a tree format using the `--tree` flag.
4. **Improved Output**:

   - Human-readable file sizes with the `--long` flag.
   - Date and time formatting for file metadata.

---

#### Installation

1. **Install LSD**:

   - **macOS**:
     ```bash
     brew install lsd
     ```
   - **Linux**:
     - Using a package manager (Debian/Ubuntu):
       ```bash
       sudo apt install lsd
       ```
     - Or via `cargo` (Rust's package manager):
       ```bash
       cargo install lsd
       ```
2. **Verify Installation**:

   ```bash
   lsd --version
   ```

---

#### Configuration

1. **Set Up Configuration Files**:

   - **Create the Config Directory**:
     ```bash
     mkdir -p ~/.config/lsd
     ```
   - **Add a Configuration File**:
     ```yaml
     # ~/.config/lsd/config.yaml
     color:
       when: always
       theme: default

     icons:
       when: always
       theme: fancy

     classic: false
     ```
2. **Set Colors for File Types**:

   - **Add `colors.yaml`**:
     ```yaml
     # ~/.config/lsd/colors.yaml
     file:
       normal: white
       symlink: cyan
       broken: red

     dir:
       normal: blue
       empty: light_blue

     exe:
       normal: green
     ```
3. **Alias `ls` to `lsd`**:
   Add this line to your `.zshrc` to replace `ls` with `lsd`:

   ```zsh
   alias ls='lsd'
   ```

   Reload your shell:

   ```bash
   source ~/.zshrc
   ```

---

#### Usage Examples

1. **Basic Listing**:

   ```bash
   lsd
   ```
2. **Detailed Listing**:

   ```bash
   lsd --long
   ```
3. **Tree View**:

   ```bash
   lsd --tree --depth 2
   ```
4. **Show Hidden Files**:

   ```bash
   lsd --all
   ```
5. **Combine Flags**:

   ```bash
   lsd --long --tree --all
   ```

---

#### Documentation

- [LSD GitHub Repository](https://github.com/lsd-rs/lsd)
- [LSD Configuration Guide](https://github.com/lsd-rs/lsd#configuration)
