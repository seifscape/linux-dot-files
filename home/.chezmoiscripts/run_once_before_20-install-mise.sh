#!/bin/bash
# mise installs to ~/.local/bin, which .zshenv puts on PATH.
set -euo pipefail

if ! command -v mise >/dev/null && [ ! -x "$HOME/.local/bin/mise" ]; then
  curl -fsSL https://mise.run | sh
fi
