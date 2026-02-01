#!/usr/bin/env bash
set -euo pipefail

# Portable bootstrap script for dotfiles environment.
# - Detects package manager and installs core packages
# - Installs Starship, Nerd Font (Fira Code)
# - Runs GNU Stow for available components

DOTFILES_DIR="$HOME/.dotfiles"
FONT_DIR="$HOME/.local/share/fonts"

echo "Starting environment bootstrap..."

detect_pm() {
  if command -v apt-get >/dev/null 2>&1; then echo "apt"; return; fi
  if command -v pacman >/dev/null 2>&1; then echo "pacman"; return; fi
  if command -v dnf >/dev/null 2>&1; then echo "dnf"; return; fi
  if command -v apk >/dev/null 2>&1; then echo "apk"; return; fi
  echo "unknown"
}

PM=$(detect_pm)
echo "Detected package manager: $PM"

install_packages() {
  case "$PM" in
    apt)
      sudo apt update
      sudo apt install -y git zsh tmux curl stow fzf ripgrep ca-certificates unzip
      ;;
    pacman)
      sudo pacman -Sy --noconfirm git zsh tmux curl stow fzf ripgrep unzip
      ;;
    dnf)
      sudo dnf install -y git zsh tmux curl stow fzf ripgrep unzip
      ;;
    apk)
      sudo apk add --no-cache git zsh tmux curl stow fzf ripgrep unzip
      ;;
    *)
      echo "Unknown package manager. Please install: git zsh tmux curl stow fzf ripgrep unzip" >&2
      return 1
      ;;
  esac
}

install_starship() {
  if command -v starship >/dev/null 2>&1; then
    echo "starship already installed"
    return
  fi
  echo "Installing starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
}

install_nerd_font() {
  echo "Installing Fira Code Nerd Font into $FONT_DIR"
  mkdir -p "$FONT_DIR"
  tmpdir=$(mktemp -d)
  trap 'rm -rf "$tmpdir"' EXIT
  url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$tmpdir/FiraCode.zip"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$tmpdir/FiraCode.zip" "$url"
  else
    echo "curl or wget required to download fonts" >&2
    return 1
  fi
  unzip -qq "$tmpdir/FiraCode.zip" -d "$tmpdir/fonts"
  cp -v "$tmpdir/fonts"/* "$FONT_DIR/" || true
  fc-cache -f || true
  echo "Fonts installed (if available)."
}

apply_stow() {
  if [ -d "$DOTFILES_DIR" ]; then
    echo "Applying stow for available components in $DOTFILES_DIR"
    cd "$DOTFILES_DIR"
    # Stow any existing top-level directories (safe default)
    for d in */; do
      dn=${d%/}
      if [ -d "$dn" ]; then
        echo "stowing $dn"
        stow "$dn" || true
      fi
    done
  else
    echo "$DOTFILES_DIR not found. Clone your dotfiles repo to $DOTFILES_DIR and re-run this script." >&2
  fi
}

install_vscode_extensions() {
  # Prefer extensions list in scripts/ (moved location). Fall back to vscode/extensions.txt
  local ext_file="$DOTFILES_DIR/scripts/vscode.extensions.txt"
  if [ ! -f "$ext_file" ]; then
    ext_file="$DOTFILES_DIR/vscode/extensions.txt"
  fi

  if command -v code >/dev/null 2>&1 && [ -f "$ext_file" ]; then
    echo "Installing VS Code extensions from $ext_file"
    while IFS= read -r ext || [ -n "$ext" ]; do
      ext="${ext%%#*}"    # strip comments after #
      ext="${ext## }"     # trim leading space
      ext="${ext%% }"     # trim trailing space
      [ -z "$ext" ] && continue
      echo "-> installing: $ext"
      code --install-extension "$ext" || echo "failed to install $ext"
    done < "$ext_file"
  else
    echo "VS Code CLI not found or $ext_file missing; skipping extension install"
  fi
}

main() {
  if ! install_packages; then
    echo "Package installation skipped or failed. Continue to other steps."
  fi

  install_starship || echo "starship install failed or skipped"
  install_nerd_font || echo "font install failed or skipped"

  apply_stow
  install_vscode_extensions

  echo
  echo "Bootstrap complete. Next steps:"
  echo " - Set zsh as your default shell: chsh -s $(which zsh)"
  echo " - Make sure ~/.local/bin is in your PATH if you installed starship locally."
  echo " - Restart your session to load the new shell and prompt."
}

main "$@"
