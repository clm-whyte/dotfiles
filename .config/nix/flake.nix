{
  description = "Calum Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      ...
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;
          
          documentation.enable = false;
          
          system.primaryUser = "calum";

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          users.users.calum.home = "/Users/calum";
          users.users.calum.packages = [
            # Command Line Tools
            pkgs.starship
            pkgs.git
            pkgs.stow
            pkgs.tmux
            pkgs.neovim
            pkgs.nixfmt
            pkgs.mise
            pkgs.eza
            pkgs.bat
            pkgs.zoxide
            pkgs.fzf
            pkgs.tldr
          ];

          homebrew = {
            enable = true;
            caskArgs.appdir = "/Users/calum/Applications";
            brews = [
              "grafana"
              "podman"
              "podman-compose"
            ];

            casks = [
              "copilot-cli"
              "discord"
              "ente"
              "ghostty"
              "iina"
              "the-unarchiver"
              "notion"
              "brave-browser"
              "obsidian"
              "visual-studio-code"
              "steam"
              "spotify"
              "miro"
            ];
            # TODO: restore "zap" once nix-darwin supports Homebrew >=4.6,
            # which removed the `brew bundle --cleanup` switch (see
            # https://github.com/LnL7/nix-darwin/issues after Homebrew 4.6.0).
            onActivation.cleanup = "none";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
          };

          system.defaults = {
            dock.autohide = true;
            dock.show-recents = false;
            dock.persistent-apps = [
              "/Users/calum/Applications/Brave Browser.app"
              "/Users/calum/Applications/Ghostty.app"
              "/Users/calum/Applications/Obsidian.app"
              "/Users/calum/Applications/Spotify.app"
              "/Users/calum/Applications/Miro.app"
            ];
            finder.FXPreferredViewStyle = "clmv";
            loginwindow.GuestEnabled = false;
            controlcenter.Sound = true;
          };

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Calums-MacBook-Pro
      darwinConfigurations."Calums-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "calum";

              autoMigrate = true;
            };
          }
        ];
      };
    };
}
