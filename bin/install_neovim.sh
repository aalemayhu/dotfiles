#!/usr/bin/env bash
# Install the latest stable prebuilt Neovim release into ~/.local.
# Re-run to upgrade.
set -euo pipefail

prefix="${HOME}/.local"
base_url="https://github.com/neovim/neovim/releases/download/stable"

case "$(uname -s)-$(uname -m)" in
  Linux-x86_64) asset="nvim-linux-x86_64" ;;
  Linux-aarch64 | Linux-arm64) asset="nvim-linux-arm64" ;;
  Darwin-arm64) asset="nvim-macos-arm64" ;;
  Darwin-x86_64) asset="nvim-macos-x86_64" ;;
  *)
    echo "Unsupported platform: $(uname -s)-$(uname -m)" >&2
    exit 1
    ;;
esac

# Download and extract in a fresh, empty directory.
workdir="$(mktemp -d)"
trap 'rmdir "${workdir}" 2>/dev/null || true' EXIT
curl -fL --proto '=https' --tlsv1.2 -o "${workdir}/${asset}.tar.gz" "${base_url}/${asset}.tar.gz"
mkdir "${workdir}/extract"
tar -xzf "${workdir}/${asset}.tar.gz" -C "${workdir}/extract"

mkdir -p "${prefix}/opt" "${prefix}/bin"
# Replace any previous install of this asset with the new one.
if [ -d "${prefix}/opt/${asset}" ]; then
  mv "${prefix}/opt/${asset}" "${prefix}/opt/${asset}.old.$$"
fi
mv "${workdir}/extract/${asset}" "${prefix}/opt/${asset}"
ln -sfn "${prefix}/opt/${asset}/bin/nvim" "${prefix}/bin/nvim"

echo "Installed: $("${prefix}/bin/nvim" --version | head -1)"
echo "Old install (if any) left at ${prefix}/opt/${asset}.old.* - delete it when happy."
# Leftover temp files (tarball, extract dir) live under ${workdir}; the OS cleans /tmp.
