#!/bin/bash
# Base packages from the distro; everything newer comes from mise (see 30-).
# pacman on the SER9 MAX (Arch), apt on the Pi (Raspberry Pi OS).
set -euo pipefail

if command -v pacman >/dev/null; then
  sudo pacman -Syu --needed --noconfirm \
    zsh tmux git curl wget unzip xz ca-certificates \
    base-devel tree ncdu
elif command -v apt-get >/dev/null; then
  sudo apt-get update
  sudo apt-get install -y \
    zsh tmux git curl wget unzip xz-utils ca-certificates \
    build-essential tree ncdu
else
  echo "No pacman or apt-get; install zsh, tmux, git and build tools by hand." >&2
  exit 1
fi

# Make zsh the login shell.
zsh_path="$(command -v zsh)"
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]; then
  sudo chsh -s "$zsh_path" "$USER"
fi
