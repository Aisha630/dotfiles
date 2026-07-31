# Dotfiles

Zsh configuration plus app configs for kitty, tmux, lsd, fastfetch, and an Oh My Posh
prompt theme.

No framework. Instead of Oh My Zsh, a handful of plugins are cloned into
`~/.zsh/plugins/` and sourced directly, which keeps interactive shell startup at
roughly 80 ms on an M-series Mac.

## Contents

| Path | Purpose |
| --- | --- |
| `.zshenv` | Environment for *every* zsh, including non-interactive ones |
| `.zshrc` | Interactive setup: plugins, aliases, keybindings, completion, history |
| `.config/kitty/` | `kitty.conf`, `ssh.conf` |
| `.config/tmux/` | `tmux.conf` (expects TPM, which `install.sh` clones) |
| `.config/lsd/` | `config.yaml`, `colors.yaml` |
| `.config/fastfetch/` | `config.jsonc`, with the ASCII logo embedded |
| `.config/oh-my-posh-theme/` | `aysha.omp.json` prompt theme |
| `install.sh` | Installs CLI tools, clones plugins, copies `.config` |

## Requirements

- **bash 4 or newer** to run `install.sh`. It uses associative arrays, and macOS
  still ships bash 3.2 as `/bin/bash`. The script checks this up front and exits
  with instructions rather than failing halfway through.

  ```bash
  brew install bash
  ```

  It does not need to be your login shell. `#!/usr/bin/env bash` picks up the newer
  one as long as Homebrew's `bin` precedes `/bin` on `PATH`.
- `git`, plus Homebrew on macOS or `apt` / `dnf` / `pacman` on Linux.

## Install

```bash
git clone https://github.com/Aisha630/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

Then link the shell files, which `install.sh` does not touch (see
[Linking](#linking-versus-copying)):

```bash
ln -sf dotfiles/.zshrc  ~/.zshrc
ln -sf dotfiles/.zshenv ~/.zshenv
exec zsh
```

### What install.sh does

- Installs zsh if missing, and offers to `chsh` to it.
- Installs `lsd`, `fzf`, `zoxide`, `bat`, `fastfetch`, `neovim`, `tmux`, `htop`,
  `fd`, `ripgrep`, `superfile`.
- Copies `./.config` into `~/.config`, backing up any existing `~/.config` to
  `~/.config.backup.<timestamp>` first.
- Clones the seven Zsh plugins into `~/.zsh/plugins/`, pulling updates if a
  plugin is already present.
- Clones TPM into `~/.config/tmux/plugins/tpm` and NvChad into `~/.config/nvim`,
  skipping either if the directory already exists.
- Logs everything to `~/.zsh_install.log`.

### What it does not do

These are deliberate gaps, listed so nothing looks broken when it is merely absent:

- **Does not install `oh-my-posh`**, even though the theme ships here. Install it
  separately (`brew install oh-my-posh`) and initialise it from `~/.zsh/local.zsh`.
- **Does not install `kitty`**, even though `kitty.conf` ships here.
- **Does not place `.zshrc`, `.zshenv`, or `.zprofile`.** Link those by hand.
- **Does not create `~/.zsh/local.zsh`**, which is intentionally untracked.

## How the shell config is layered

Zsh reads these in a fixed order, and putting a setting in the wrong file is the
usual cause of "it works in my terminal but not in scripts":

| File | Read by | Holds |
| --- | --- | --- |
| `.zshenv` | every zsh, including scripts and `zsh -c` | `PATH` dedup, `EDITOR`, `LS_COLORS`, fzf command vars |
| `.zprofile` | login shells only | login-time setup, e.g. Homebrew `shellenv` |
| `.zshrc` | interactive shells | plugins, aliases, keybindings, completion, history, `setopt` |
| `~/.zsh/local.zsh` | sourced at the end of `.zshrc` | per-machine paths, toolchains, secrets |

`EDITOR` lives in `.zshenv` specifically so `git` and `sudoedit` inherit it when
invoked non-interactively. Anything interactive-only belongs in `.zshrc`.

`~/.zsh/local.zsh` and `.zprofile` are deliberately not tracked here. `local.zsh`
is sourced at the end of `.zshrc` if it exists, and is the escape hatch for
anything that should not live in a shared repo: per-machine `PATH` entries,
language toolchains, credentials, tool completions, and the `oh-my-posh init`
call. Create it if you want one; nothing breaks if you do not.

Guard anything in there that is expensive or machine-dependent, so the same file
stays portable:

```zsh
if command -v some-tool >/dev/null; then
  # setup for a tool that is not on every machine
fi
```

## Linking versus copying

`install.sh` **copies** `.config`. That is fine for bootstrapping a new machine but
means edits made in `~/.config` never flow back to the repo, and the two copies
drift apart.

Symlinking instead makes drift impossible, and is what this machine uses:

```bash
ln -sf dotfiles/.zshrc  ~/.zshrc
ln -sf dotfiles/.zshenv ~/.zshenv
for f in kitty/kitty.conf kitty/ssh.conf tmux/tmux.conf lsd/config.yaml \
         fastfetch/config.jsonc oh-my-posh-theme/aysha.omp.json; do
  mkdir -p ~/.config/"${f%/*}"
  ln -sf ../../dotfiles/.config/"$f" ~/.config/"$f"
done
```

GNU Stow (`brew install stow`) automates the same thing if you prefer.

Be aware that the two approaches conflict: **re-running `install.sh` on a
symlinked machine replaces the symlinks with plain copies.** Either link by hand
and skip `install.sh` afterwards, or accept copies.

## Zsh plugins

Cloned into `~/.zsh/plugins/` and sourced by a loop in `.zshrc`:

- `ez-compinit` - defers `compinit` to the first Tab press, which is most of why
  startup is fast. **Sourced first**, as its README requires.
- `fast-syntax-highlighting`
- `zsh-autosuggestions`
- `fzf-tab` - replaces completion menus with fzf
- `auto-notify` - desktop notification for commands over
  `AUTO_NOTIFY_THRESHOLD` seconds
- `zsh-sudo` - press Esc twice to prefix the line with `sudo`
- `zsh-history-substring-search` - **sourced last**, as its README requires

## Keybindings

| Key | Action |
| --- | --- |
| Up / Down | history substring search on what you have typed |
| Ctrl-R | fzf history search |
| Ctrl-T | fzf file picker, with a `bat` preview |
| Alt-C | fzf directory jump |
| Ctrl-E | edit the current command line in `$EDITOR` |
| Alt-/ | undo |
| Alt-Shift-/ | redo |
| Esc Esc | prefix the line with `sudo` |
| Tab | fzf-backed completion |

Emacs bindings are active (`bindkey -e`).

## Notable behaviour

- `ls` is `lsd`; `l` and `la` build on it.
- `rm` is `rm -i`, so it prompts per file. Note `rm -rf` bypasses that, and
  `rm_star_silent` disables the `rm *` confirmation.
- `DOT_GLOB` is set, so globs match dotfiles. Combined with the above, be
  deliberate with `rm *`.
- `cc` is a calculator: `cc 2/3` prints `0.666...` via `python3` with `math`
  imported, so `sqrt(2)` and `pi` work. `noglob` is applied so `*` needs no quoting.
- `cpa` / `cf` copy a path or a file's contents to the clipboard, working across
  `pbcopy`, `xclip`, and `wl-copy`.
- `mkcd foo/bar` creates the directory and enters it.
- `auto_cd` is on, so a bare directory name changes into it.
- fzf uses `fd` as its source when `fd` is present, so `.gitignore` is respected.
  All three of `FZF_DEFAULT_COMMAND`, `FZF_CTRL_T_COMMAND`, and
  `FZF_ALT_C_COMMAND` are set, because fzf's zsh integration blanks
  `FZF_DEFAULT_COMMAND` for the Ctrl-T and Alt-C widgets.
- History is shared live across open shells, with `HISTSIZE` equal to `SAVEHIST`
  so the file can actually reach the configured size.
- `EDITOR` prefers `nvim`, then `vim`, then `vi`.

## Troubleshooting

**Slow startup.** Time it with `for i in 1 2 3; do time zsh -i -c exit; done`.
The usual culprits are `eval "$(some-tool completion)"` calls, each of which forks
a process and parses a script on every single shell. Cache the output to a file
once, `zcompile` it, and `source` that instead, regenerating only when the tool's
binary is newer than the cache. The fetch tool at the end of `.zshrc` also costs
real time on every shell, including each new tmux pane. To find where the time
actually goes, add `zmodload zsh/zprof` at the top of `.zshrc` and `zprof` at the
bottom.

**Slow prompt in a large repo.** The Oh My Posh git segment needs
`"fetch_status": true` to report ahead/behind, and that scans the working tree, so
its cost scales with file count. In a 12,000-file repo it adds roughly 70 ms per
prompt. Enabling git's filesystem monitor cuts that by about two thirds while
keeping the indicators:

```bash
git config --global core.fsmonitor true
git config --global core.untrackedCache true
```

**Prompt shows no git status.** The git segment renders only what its `template`
references. `.BranchStatus` reports commits relative to upstream, not file edits:
`≡` means in sync, `↑2` and `↓2` mean ahead and behind. Working-tree edits live in
`.Working` and `.Staging`, which this theme deliberately omits.

**Plugin features missing.** Confirm the directories exist under
`~/.zsh/plugins/` and re-run `./install.sh`, which pulls updates for plugins that
are already cloned.

**`ls` output looks wrong.** Confirm `lsd` is installed, since `ls` is aliased to it.

**Glyphs render as boxes.** The prompt and `lsd` icons need a Nerd Font. This setup
uses MesloLGS Nerd Font Mono, set in `kitty.conf`.

**`install.sh` exits immediately.** Check the bash version. See
[Requirements](#requirements).

## Layout

```
.
├── .config/
│   ├── fastfetch/
│   ├── kitty/
│   ├── lsd/
│   ├── oh-my-posh-theme/
│   └── tmux/
├── .zshenv
├── .zshrc
├── install.sh
└── README.md
```
