# dotfiles

My Mac setup: shell, git, Neovim, Ghostty, zellij, mise and Claude Code
config, plus a `Brewfile` with every app and CLI I use.

Use this at your own risk and don't expect any support from me if you break
your default setup.

## New Mac

```sh
git clone https://github.com/aalemayhu/dotfiles.git ~/src/github.com/aalemayhu/dotfiles
cd ~/src/github.com/aalemayhu/dotfiles
./bootstrap.sh
```

Then work through [SETUP.md](SETUP.md) for the parts a script can't do
(logins, permissions, apps outside Homebrew). Claude Code can walk you through
it: run `claude` in this directory and say "follow SETUP.md".

## Day to day

| Command      | What it does                                                    |
| ------------ | --------------------------------------------------------------- |
| `make update`| Upgrade Homebrew, mise runtimes, Neovim + plugins, Claude Code  |
| `make dump`  | Refresh the `Brewfile` after installing something new           |
| `make check` | Show missing links and Brewfile entries that aren't installed   |
| `make link`  | Recreate the symlinks only                                      |
| `make fonts` | Install the fonts (Klee One, JetBrains Mono Nerd Font)          |
| `make claude-save` | Copy Claude Code settings changes back into the repo     |

## Layout

| Path             | Linked to                                                    |
| ---------------- | ------------------------------------------------------------ |
| `shell/`         | `~/.bashrc`, `~/.bash_profile`, `~/.shell/`                  |
| `git/gitconfig`  | included from `~/.gitconfig` (which stays a local file)      |
| `nvim/`          | `~/.config/nvim`                                             |
| `claude/`        | `~/.claude/` (CLAUDE.md, statusline, commands)               |
| `ghostty/`, `zellij/`, `mise/` | `~/.config/…`                                  |
| `ssh/config`     | `~/.ssh/config`                                              |

Machine-specific settings and secrets go in `~/.shell/local` and
`~/.gitconfig`, and ssh hosts in `~/.ssh/config.d/`, which are not in git.

`~/.claude/settings.json` is a regular file built by `bin/claude-settings`
from `claude/settings.json` plus `~/.claude/settings.private.json`, which holds
the permission rules that name servers and accounts (not in git). After
changing settings from inside Claude Code, run `make claude-save` to bring
the shared part back into the repo.
