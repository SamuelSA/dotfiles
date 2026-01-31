# Shell organization
```
Kitty
 + Zsh
   + Starship
     + tmux
       + fzf / bat / eza / rg
```

## Kitty
https://sw.kovidgoyal.net/kitty/

### Fonts
https://www.nerdfonts.com/#home
Using Fira Code
Installed with `apt get`

## Starship
https://starship.rs/

## dotfiles
Structure:
```
dotfiles/
├── zsh/
│   └── .zshrc
├── tmux/
│   └── .tmux.conf
├── kitty/
│   └── .config/kitty/kitty.conf
├── git/
│   └── .gitconfig
└── README.md
```

### Stow
Manages links to ´dot files´
```
cd ~/dotfiles
stow tmux
```

## SSH

### Id
```
❯ ssh-keygen -t ed25519 -C "samuel.savin@wanadoo.fr"
❯ eval "$(ssh-agent -s)"
❯ ssh-add ~/.ssh/id_ed25519

```