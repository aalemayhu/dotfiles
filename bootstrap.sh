#!/usr/bin/env bash
# Set up this Mac or Linux machine from the dotfiles repo. Safe to re-run.
#
#   ./bootstrap.sh          everything: Homebrew, Brewfile, links, runtimes, ...
#   ./bootstrap.sh link     only (re)create the symlinks
#   ./bootstrap.sh check    list links that are missing or were replaced by files
#   ./bootstrap.sh fonts    only install the fonts
#
# The manual steps (logins, permissions, apps outside Homebrew) are in SETUP.md.
set -euo pipefail

dotfiles="$(cd "$(dirname "$0")" && pwd)"

# "file in this repo   where it goes, relative to $HOME"
links=(
    "shell/bashrc                 .bashrc"
    "shell/bash_profile           .bash_profile"
    "shell/env                    .shell/.env"
    "shell/aliases                .shell/.aliases"
    "shell/funcs                  .shell/.funcs"
    "ssh/config                   .ssh/config"
    "nvim                         .config/nvim"
    "ghostty/config               .config/ghostty/config"
    "zellij/config.kdl            .config/zellij/config.kdl"
    "zellij/layouts               .config/zellij/layouts"
    "kanji/kanji                  .local/bin/kanji"
    "mise/config.toml             .config/mise/config.toml"
    "claude/CLAUDE.md             .claude/CLAUDE.md"
    "claude/statusline-command.sh .claude/statusline-command.sh"
    "claude/commands              .claude/commands"
    "claude/scripts/asc-api.mjs   .claude/scripts/asc-api.mjs"
)

# macOS only
if [ "$(uname -s)" = Darwin ]; then
    links+=("ghostty/config.mac           .config/ghostty/config.mac")
fi

# sha256 of a file: macOS has shasum, most Linux distros have sha256sum
sha256() {
    if command -v sha256sum >/dev/null; then sha256sum "$1" | cut -d' ' -f1
    else shasum -a 256 "$1" | cut -d' ' -f1; fi
}

link() {
    local src="$dotfiles/$1" dst="$HOME/$2"
    [ "$(readlink "$dst" 2>/dev/null)" = "$src" ] && return
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        local backup
        backup="$dst.bak.$(date +%Y%m%d-%H%M%S)"
        mv "$dst" "$backup"
        echo "moved ~/$2 to ${backup/#$HOME/~}"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "linked ~/$2"
}

# zellij-autolock (locks zellij while nvim runs); pinned and checked against its checksum
install_zellij_autolock() {
    local version=0.3.0 sha=217e071b785981efda480b279d1a98e86da21971cf0bc7edd45f8b7c6359ab02
    local dst="$HOME/.config/zellij/plugins/zellij-autolock.wasm" tmp
    [ -f "$dst" ] && [ "$(sha256 "$dst")" = "$sha" ] && return
    tmp="$(mktemp)"
    curl -fsSL -o "$tmp" "https://github.com/fresh2dev/zellij-autolock/releases/download/$version/zellij-autolock.wasm"
    if [ "$(sha256 "$tmp")" != "$sha" ]; then
        rm -f "$tmp"
        echo "zellij-autolock: checksum mismatch, not installed" >&2
        return 1
    fi
    mkdir -p "$(dirname "$dst")"
    mv "$tmp" "$dst"
    echo "installed zellij-autolock $version"
}

# Klee One (textbook-style Japanese font, OFL) for kanji/kanji; pinned and checked against its checksum
install_klee_one() {
    local commit=a881eac792f94326957e5796541b99ac9e434a52 sha=b031ec426c23ca1143ef1f7d58bee7a79efe119ed654152f121c922202b303fd
    local dst="$HOME/.local/share/fonts/KleeOne-SemiBold.ttf" tmp
    [ -f "$dst" ] && [ "$(sha256 "$dst")" = "$sha" ] && return
    tmp="$(mktemp)"
    curl -fsSL -o "$tmp" "https://raw.githubusercontent.com/google/fonts/$commit/ofl/kleeone/KleeOne-SemiBold.ttf"
    if [ "$(sha256 "$tmp")" != "$sha" ]; then
        rm -f "$tmp"
        echo "Klee One: checksum mismatch, not installed" >&2
        return 1
    fi
    mkdir -p "$(dirname "$dst")"
    mv "$tmp" "$dst"
    echo "installed Klee One"
}

# Klee One, plus the terminal font (a Brewfile cask, so macOS only)
install_fonts() {
    install_klee_one
    [ "$(uname -s)" = Darwin ] || return 0
    local brew_bin
    brew_bin="$(find_brew)"
    if [ -z "$brew_bin" ]; then
        echo "Homebrew is not installed; run ./bootstrap.sh first" >&2
        return 1
    fi
    "$brew_bin" install --cask --quiet font-jetbrains-mono-nerd-font
}

link_all() {
    local entry src dst
    for entry in "${links[@]}"; do
        read -r src dst <<<"$entry"
        link "$src" "$dst"
    done
    chmod 600 "$dotfiles/ssh/config"
    # mise follows the link into the repo, which it doesn't trust by default
    if command -v mise >/dev/null; then mise trust --quiet "$dotfiles/mise/config.toml"; fi

    # ~/.gitconfig stays a local file that includes the shared config, so
    # `git config --global` never rewrites the repo (or breaks a symlink).
    [ -L "$HOME/.gitconfig" ] && rm "$HOME/.gitconfig"
    git config --global --get-all include.path | grep -qxF "$dotfiles/git/gitconfig" ||
        git config --global --add include.path "$dotfiles/git/gitconfig"

    # Claude Code settings: shared part from the repo + ~/.claude/settings.private.json
    "$dotfiles/bin/claude-settings" build

    # machine-specific shell settings and secrets
    mkdir -p "$HOME/.shell"
    touch "$HOME/.shell/local"
    # ssh hosts, included from ssh/config
    mkdir -m 700 -p "$HOME/.ssh/config.d"
}

check() {
    local entry src dst status=0
    for entry in "${links[@]}"; do
        read -r src dst <<<"$entry"
        if [ "$(readlink "$HOME/$dst" 2>/dev/null)" != "$dotfiles/$src" ]; then
            echo "not linked: ~/$dst"
            status=1
        fi
    done
    git config --global --get-all include.path | grep -qxF "$dotfiles/git/gitconfig" ||
        { echo "not included: git/gitconfig in ~/.gitconfig"; status=1; }
    [ $status -eq 0 ] && echo "all links in place"
    return $status
}

find_brew() {
    local b
    for b in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew "$HOME/.linuxbrew/bin/brew"; do
        [ -x "$b" ] && { echo "$b"; return; }
    done
}

login_shell() {
    if [ "$(uname -s)" = Darwin ]; then
        dscl . -read "$HOME" UserShell | awk '{print $2}'
    else
        getent passwd "$USER" | cut -d: -f7
    fi
}

# Installing Homebrew and changing the login shell need root: ask for the
# password once, up front, and keep it cached until drop_sudo.
sudo_keepalive=
keep_sudo() {
    sudo -v
    while kill -0 "$$" 2>/dev/null; do sudo -n true; sleep 50; done >/dev/null 2>&1 &
    sudo_keepalive=$!
}

# Forget the password before running anything downloaded (mise, curl | bash, ...)
drop_sudo() {
    [ -n "$sudo_keepalive" ] || return 0
    kill "$sudo_keepalive" 2>/dev/null || true
    sudo -k
    sudo_keepalive=
}

# Homebrew's bash as the login shell (macOS's /bin/bash is 3.2 from 2007)
set_login_shell() {
    local shell="$HOMEBREW_PREFIX/bin/bash"
    [ -x "$shell" ] || return 0
    grep -qxF "$shell" /etc/shells || echo "$shell" | sudo tee -a /etc/shells >/dev/null
    if [ "$(login_shell)" != "$shell" ]; then
        sudo chsh -s "$shell" "$USER"
        echo "login shell is now $shell"
    fi
}

install() {
    # On macOS the Homebrew installer also installs the Command Line Tools
    if [ "$(uname -s)" != Darwin ]; then
        # Homebrew on Linux needs these from the distro (apt install build-essential curl git)
        local tool missing=()
        for tool in git curl gcc make; do command -v "$tool" >/dev/null || missing+=("$tool"); done
        if [ ${#missing[@]} -gt 0 ]; then
            echo "Install these with your package manager first: ${missing[*]}" >&2
            exit 1
        fi
    fi

    local brew_bin
    brew_bin="$(find_brew)"
    if [ -z "$brew_bin" ] || [ "$(login_shell)" != "$(dirname "$brew_bin")/bash" ]; then
        keep_sudo
    fi
    if [ -z "$brew_bin" ]; then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew_bin="$(find_brew)"
    fi
    eval "$("$brew_bin" shellenv)"
    # one failed entry should not stop the rest
    brew bundle --file="$dotfiles/Brewfile" || echo "brew bundle: some entries failed, see above"
    set_login_shell
    drop_sudo

    link_all
    install_zellij_autolock || true
    install_klee_one || true

    MISE_YES=1 mise install

    command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash
    [ -x "$HOME/.local/bin/nvim" ] || bash "$dotfiles/bin/install_neovim.sh"
    "$HOME/.local/bin/nvim" --headless "+Lazy! restore" +qa

    [ -f "$HOME/.ssh/id_ed25519" ] ||
        ssh-keygen -t ed25519 -C a@alemayhu.com -N '' -f "$HOME/.ssh/id_ed25519"

    echo
    echo "Done. The manual steps left are in SETUP.md."
}

case "${1:-install}" in
    install) install ;;
    link) link_all ;;
    check) check ;;
    fonts) install_fonts ;;
    *)
        echo "usage: $0 [install|link|check|fonts]" >&2
        exit 2
        ;;
esac
