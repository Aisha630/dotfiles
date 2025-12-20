
# Dotfiles

My personal terminal setup: Zsh config + a small set of CLI tools, plus app configs for Kitty, tmux, Neofetch, LSD, and an Oh My Posh theme file.

This repo intentionally avoids large frameworks (e.g. Oh My Zsh) and instead sources a few targeted plugins directly from `~/.zsh/plugins/`.

## What you get

- **Zsh**: plugins, aliases, completion tweaks, history settings, helper functions (clipboard helpers, etc.)
- **Tooling**: `lsd`, `fzf`, `zoxide`, `bat`, `kitty`, `neofetch`, `neovim`, `tmux`
- **Configs** (copied into `~/.config/`):
  - `kitty/` (`kitty.conf`, `ssh.conf`)
  - `tmux/` (`tmux.conf`)
  - `lsd/`
  - `neofetch/`
  - `oh-my-posh-theme/` (theme JSON)

## Quick start (automated)

This installs dependencies + clones Zsh plugins + copies `.config/` into your home directory.

```bash
git clone https://github.com/Aisha630/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

Notes:

- The installer logs to `~/.zsh_install.log`.
- `install.sh` currently **copies** `./.config` to `~/.config` (it does not use symlinks).
- You still need to place the repo’s `.zshrc` at `~/.zshrc` (see the next section).

## Dotfiles placement (Stow or copy)

### Option A: GNU Stow (symlinks)

If you prefer symlinks, install Stow and stow the repo from inside it:

```bash
brew install stow
cd ~/.dotfiles
stow .
```

### Option B: Plain copy (no symlinks)

```bash
cp ~/.dotfiles/.zshrc ~/.zshrc
cp -R ~/.dotfiles/.config/* ~/.config/
```

## Zsh plugin layout

Plugins live under `~/.zsh/plugins/` and are cloned by `install.sh`:

- `auto-notify`
- `ez-compinit`
- `fast-syntax-highlighting`
- `fzf-tab`
- `zsh-autosuggestions`
- `zsh-history-substring-search`
- `zsh-sudo`

In `~/.zshrc`, **`ez-compinit` is sourced first** and **`zsh-history-substring-search` is sourced last** (as recommended by their authors).

## Customization

- `~/.zsh/local.zsh` is sourced if present — put machine-specific secrets/paths there.
- `EDITOR` prefers `nvim`, falls back to `vim`, then `vi`.

## Troubleshooting

- If startup is slow, check what’s being executed in `~/.zshrc` (it runs `neofetch` on shell start).
- If plugin features don’t work, verify the plugin directories exist in `~/.zsh/plugins/` and re-run `./install.sh`.
- If `ls` output looks wrong, confirm `lsd` is installed (this config aliases `ls` to `lsd`).

## Repo layout

```
.
├── .config/
│   ├── kitty/
│   ├── lsd/
│   ├── neofetch/
│   ├── oh-my-posh-theme/
│   └── tmux/
├── .zshrc
├── install.sh
└── README.md
```
