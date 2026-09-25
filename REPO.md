**Shell Setup**

- **Overview:** A compact local shell environment using `kitty`, `zsh` (with `starship` prompt), `tmux` and several utilities (`fzf`, `bat`, `exa`, `rg`). This repo holds the dotfiles and a helper script to bootstrap a new system.

**Key Links:**

- **Kitty:** https://sw.kovidgoyal.net/kitty/
- **Starship:** https://starship.rs/
- **Nerd Fonts (Fira Code):** https://www.nerdfonts.com/
- **GNU Stow:** https://www.gnu.org/software/stow/

**Dotfiles Structure**

- `zsh/` — ` .zshrc`
- `tmux/` — `.tmux.conf`
- `kitty/` — `.config/kitty/kitty.conf`
- `git/` — `.gitconfig`
- `onedrive/` — `.config/onedrive/{config,sync_list}`
- `REPO.md` — this file

Use `stow` to create symlinks from the dotfiles directory into your home directory. Example:

```
cd ~/.dotfiles
stow tmux zsh kitty git
stow --no-folding onedrive
```

**Quick manual steps**

- Install packages (Debian/Ubuntu example):

```
sudo apt update && sudo apt install -y git zsh tmux curl stow fzf ripgrep
```

- Install `starship` prompt:

```
curl -sS https://starship.rs/install.sh | sh -s -- -y
```

- Install Nerd Font (Fira Code) and refresh font cache (the script automates this).

**SSH keys**

Generate an SSH keypair and add it to the agent:

```
ssh-keygen -t ed25519 -C "your.email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

**Notes & Troubleshooting**

- The bootstrap script attempts to detect the package manager (`apt`, `pacman`, `dnf`, `apk`) and will run a best-effort install for common packages. Some package names vary across distributions; inspect the script and adjust the package lists if needed.
- If a package is unavailable in your distro repos, the script will print manual steps instead of failing silently.
- After running the script, verify your default shell is `zsh` with `chsh -s $(which zsh)` and re-login.

**Visual Studio Code**

- **Settings & Keys:** The repo includes a `vscode` package with user settings and keybindings at `vscode/.config/Code/User/`.
- **Stow:** Use `stow vscode` (from the dotfiles root) to symlink VS Code settings into `~/.config/Code/User/` after you merge any local settings.
- **Extensions:** A curated list is available at `vscode/extensions.txt`. The bootstrap script will attempt to install these extensions automatically if the `code` CLI is available.

- **Quick extension install:**

```bash
xargs -n1 code --install-extension < vscode/extensions.txt
```

- **Docs:** https://code.visualstudio.com/docs and CLI: https://code.visualstudio.com/docs/editor/command-line

**OneDrive**

- **Config:** The `onedrive` package holds the OneDrive Client for Linux configuration at `onedrive/.config/onedrive/` (`config` and `sync_list`).
- **Stow — always with `--no-folding`:**

```
cd ~/.dotfiles
stow --no-folding onedrive
```

- **Why `--no-folding` is mandatory here:** the client writes its OAuth tokens (`refresh_token`, `access_token`) and its sync database (`items.sqlite3`) _inside_ `~/.config/onedrive`, alongside the stowed config. Plain `stow` folds that directory into a single symlink aimed into this repo, so those files — including live credentials — would be created directly in the git working tree. `scripts/.local/bin/dotfiles-add` runs plain `stow`, so it must **not** be used for this package.
- **Requires onedrive >= v2.5.6** (`use_recycle_bin`) — Debian 13 ships 2.5.4-1, too old; Debian 14 ships 2.5.10. Upstream build: `home:/npreining:/debian-ubuntu-onedrive`.
- **Docs:** https://github.com/abraunegg/onedrive/blob/master/docs/application-config-options.md

**License / Attribution**

Keep your dotfiles under your preferred license if you share them. This repository contains personal configuration snippets and install helpers.

---

Last updated: 2026-09-25
