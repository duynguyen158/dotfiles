{
  description = "Duy Nguyen's Nix System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Zed uses nil as Nix language server
    nil.url = "github:oxalica/nil";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nix-homebrew,
      nixpkgs,
      nil,
      home-manager,
      ...
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # Enable installing packages with an unfree license
          nixpkgs.config.allowUnfree = true;

          nix = {
            settings = {
              experimental-features = [
                "nix-command"
                "flakes"
              ];
            };
          };

          # List Nix packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          # Can include both CLI tools and GUI applications
          environment.systemPackages = [
            pkgs.cookiecutter
            pkgs.curl
            pkgs.ffmpeg
            pkgs.git
            pkgs.home-manager
            pkgs.nixd
            pkgs.openssh
            pkgs.pure-prompt
            pkgs.stow
            pkgs.vim
            nil.packages.${pkgs.system}.nil
          ];

          # List packages to be instaled by Homebrew.
          homebrew = {
            enable = true;
            # CLI tools go here
            brews = [
              # Call LLMs
              "llm"
              # CLI to search for apps and their ID on the App Store
              "mas"
              # Python package and project manager
              "uv"
              # YouTube downloader
              "yt-dlp"
            ];
            # GUI apps go here
            casks = [
              "1password"
              "brave-browser"
              "docker-desktop"
              "google-chrome"
              "google-drive"
              "macwhisper"
              "microsoft-word"
              "obsidian"
              "ollama-app"
              "postman"
              "signal"
              "slack"
              "tuple"
              "viber"
              "vlc"
              "whatsapp"
              "zalo"
              "zed"
            ];
            # Mac App Store apps go here
            # Make sure you're logged in to the App Store and have purchased each app
            # Use the `mas search` command to search for the app ID
            masApps = { };
            onActivation = {
              autoUpdate = true;
              # Make sure only packages specified in this configuartion are installed
              cleanup = "zap";
              upgrade = true;
            };
          };

          programs = {
            zsh = {
              enable = true;
            };
          };

          security = {
            # Allow sudo auth via fingerprint
            pam.services.sudo_local.touchIdAuth = true;
          };

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # System settings
          system = {
            # Set Git commit hash for darwin-version.
            configurationRevision = self.rev or self.dirtyRev or null;

            primaryUser = "duynguyen";

            defaults = {
              finder = {
                # Show hidden files (including dotfiles) by default
                AppleShowAllFiles = true;
                # Show columns view by default
                FXPreferredViewStyle = "clmv";
                # Default new Finder windows to open in the home directory
                NewWindowTarget = "Home";
              };
            };

            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            stateVersion = 5;
          };

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations.caro = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            # `home-manager` config
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.duynguyen = import ./home-manager/default.nix;
            };
            users.users.duynguyen.home = "/Users/duynguyen";
            nix.settings.trusted-users = [ "duynguyen" ];
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              # Apple Silicon only
              enableRosetta = true;
              # User owning the Homebrew prefix
              user = "duynguyen";
              # In case Homebrew was already installed
              autoMigrate = true;
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.caro.pkgs;
    };
}
