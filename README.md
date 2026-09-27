# linux dot files

The terminal from [macos-dot-files](https://github.com/seifscape/macos-dot-files),
on Ubuntu Server: a Raspberry Pi 5 (arm64) and a UM890 (x86_64). Managed with
[chezmoi](https://www.chezmoi.io).

## Setup on a new machine

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -b ~/.local/bin -- init --apply seifscape/linux-dot-files
```

It asks for your git name and email, then:

1. installs zsh, tmux, git and build tools with apt, and makes zsh the login shell
2. installs [mise](https://mise.jdx.dev)
3. writes the dotfiles and pulls the shared ones from macos-dot-files
4. `mise install` for every CLI tool, then `sheldon lock` and `bat cache --build`

Log out and back in (for the zsh login shell), then open tmux and press
`prefix + I` to install tmux plugins.

If `mise install` stops on a GitHub rate limit, `export GITHUB_TOKEN=...`
and run `chezmoi apply` again.

## What lives where

This repo holds only what has to differ on Linux. Everything else is pulled
from macos-dot-files by [`.chezmoiexternal.toml.tmpl`](home/.chezmoiexternal.toml.tmpl),
so there is one real copy of each file and nothing to keep in sync by hand.

| Here | Pulled from macos-dot-files |
|------|-----------------------------|
| `.zshrc` — mise activates first, it provides every tool | `.aliases` `.functions` `.exports` `.zsh_bindings` |
| `.zprofile` — mise shims instead of Homebrew | starship, tmux, nvim, atuin, btop, delta, gh-dash |
| `.gitconfig` — no Sourcetree or credential manager | `dev-updates.sh`, `.gitignore_global` |
| `mise/config.toml` — runtimes plus the CLI tools Homebrew gives the Mac | |
| `sheldon/plugins.toml` — fzf via `fzf --zsh`, not `/opt/homebrew` | |

Also pulled as externals: TPM, the Catppuccin delta themes and the Catppuccin
bat themes, which are manual clones on the Mac.

## Daily use

| Task | Command |
|------|---------|
| Pull changes from both repos | `chezmoi update` |
| Force-refresh the shared files now | `chezmoi apply --refresh-externals` |
| Edit a file owned by this repo | `chezmoi edit ~/.zshrc`, then `chezmoi apply` |
| See what would change | `chezmoi diff` |

Shared files are edited **on the Mac**, in macos-dot-files, and pushed. Editing
`~/.aliases` on a server is overwritten on the next update. Externals refresh
once a day on their own.

To try Mac-side changes before merging them, point the externals at a branch:

```bash
chezmoi apply --refresh-externals --override-data '{"macosRef":"my-branch"}'
```
