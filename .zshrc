alias vim="nvim"
alias ls="eza --oneline --all --icons"
alias cat="bat"
alias cd="z"
alias update="softwareupdate -ia && cd ~/.dotfiles/.config/nix/ && nix flake update && darwin-rebuild switch --flake . && cd"

# Activate Mise
eval "$(mise activate zsh)"

# Setup zoxide
eval "$(zoxide init zsh)"

# Enable Starship prompt - keep at end of file
eval "$(starship init zsh)"
