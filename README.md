# System Config
## Prerequisites
### Git
```sh
xcode-select --install
```

### Nix
```sh
sh <(curl -L https://nixos.org/nix/install)
```

## Installation
### Dotfiles
Copy `.dotfiles` onto local system using GNU Stow
```sh
git clone git@github.com:clm-whyte/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .
```

### Nix
Install nix-darwin
```sh
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix
```
Apply nix flake to system
```sh
darwin-rebuild switch --flake ~/.config/nix
```
