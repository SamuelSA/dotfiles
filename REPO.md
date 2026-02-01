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
- `README.md` — this file

Use `stow` to create symlinks from the dotfiles directory into your home directory. Example:

```
cd ~/.dotfiles
stow tmux zsh kitty git
```

**Bootstrap script**

- A portable helper script is provided at `scripts/setup_env.sh` to install required packages, Nerd Font (Fira Code), `starship`, and to run `stow` for the available components. See `scripts/setup_env.sh` for details and run like:

```
bash scripts/setup_env.sh
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

**License / Attribution**

Keep your dotfiles under your preferred license if you share them. This repository contains personal configuration snippets and install helpers.

----

Last updated: 2026-02-01
