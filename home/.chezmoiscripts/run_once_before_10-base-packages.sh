#!/bin/bash
# Base packages from the distro; everything newer comes from mise (see 30-).
# pacman on the SER9 MAX (Arch), apt on the Pi (Raspberry Pi OS).
set -euo pipefail

if command -v pacman >/dev/null; then
  # -S --needed only installs what's missing; system upgrades stay manual (pacman -Syu).
  sudo pacman -S --needed --noconfirm \
    zsh tmux git curl wget unzip xz ca-certificates \
    base-devel tree ncdu \
    ttf-jetbrains-mono-nerd   # same font as the Mac's Ghostty, for a local terminal
elif command -v apt-get >/dev/null; then
  sudo apt-get update
  sudo apt-get install -y \
    zsh tmux git curl wget unzip xz-utils ca-certificates \
    build-essential tree ncdu fontconfig

  # apt has no Nerd Fonts, so take the same one from the upstream release.
  font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerd"
  if [ ! -d "$font_dir" ]; then
    mkdir -p "$font_dir"
    curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
      | tar -xJ -C "$font_dir"
    fc-cache -f "$font_dir"
  fi
else
  echo "No pacman or apt-get; install zsh, tmux, git and build tools by hand." >&2
  exit 1
fi

# Make zsh the login shell.
zsh_path="$(command -v zsh)"
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]; then
  sudo chsh -s "$zsh_path" "$USER"
fi
