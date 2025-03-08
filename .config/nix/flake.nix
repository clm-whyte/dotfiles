{
  description = "Calum Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util, nix-homebrew, ... }:
  let
    configuration = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
	  # Command Line Tools
	  pkgs.starship
	  pkgs.git
	  pkgs.stow
	  pkgs.tmux
	  pkgs.neovim

	  # Web Tools
	  pkgs.brave

	  # Organisation Tools
	  pkgs.obsidian
        ];
      
      homebrew = {
        enable = true;
	casks = [
	  "ghostty"
	  "google-drive"
	];
	onActivation.cleanup = "zap";
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
      };

      system.defaults = {
        dock.autohide = true;
	dock.show-recents = false;
	dock.persistent-apps = [
	  "${pkgs.brave}/Applications/Brave Browser.app"
	  "/Applications/Ghostty.app"
	  "${pkgs.obsidian}/Applications/Obsidian.app"
	];
	finder.FXPreferredViewStyle = "clmv";
	loginwindow.GuestEnabled = false;
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
	mac-app-util.darwinModules.default
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
