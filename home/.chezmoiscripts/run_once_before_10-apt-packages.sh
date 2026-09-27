#!/bin/bash
# Base packages from apt; everything newer comes from mise (see 30-).
set -euo pipefail

sudo apt-get update
sudo apt-get install -y \
  zsh tmux git curl wget unzip xz-utils ca-certificates \
  build-essential tree ncdu

# Make zsh the login shell.
zsh_path="$(command -v zsh)"
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]; then
  sudo chsh -s "$zsh_path" "$USER"
fi
