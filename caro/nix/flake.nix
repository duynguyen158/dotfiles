{
  description = "Duy Nguyen's Nix System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.brew-src.follows = "brew-src";
    };
    brew-src = {
      url = "github:Homebrew/brew";
      flake = false;
    };
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
    nixvim.url = "github:nix-community/nixvim";
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    oh-my-tmux = {
      url = "github:gpakosz/.tmux";
      flake = false;
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
      nixvim,
      llm-agents,
      oh-my-tmux,
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
          environment.variables.HOMEBREW_NO_REQUIRE_TAP_TRUST = "1";

          environment.systemPackages = [
            pkgs.cookiecutter
            pkgs.curl
            pkgs.ffmpeg
            pkgs.git
            pkgs.home-manager
            pkgs.nixd
            pkgs.openssh
            pkgs.pure-prompt
            pkgs.rustup # should followed by `rustup toolchain install stable` to install the compiler and cargo
            pkgs.stow
            pkgs.vim
            nil.packages.${pkgs.stdenv.hostPlatform.system}.nil
          ];

          # List packages to be installed by Homebrew.
          homebrew = {
            enable = true;
            # Taps go here
            taps = [
              "cormacrelf/tap"
              "hashicorp/tap"
              "oven-sh/bun"
            ];
            # CLI tools go here
            brews = [
              "bun"
              "cloud-sql-proxy"
              "cormacrelf/tap/dark-notify"
              "gh"
              "llm"
              # CLI to search for apps and their ID on the App Store
              "mas"
              "mcp-toolbox"
              "mise"
              "nvm"
              # Enables Touch ID for sudo inside tmux
              "pam-reattach"
              "postgresql@18"
              "ripgrep"
              "uv"
              "hashicorp/tap/vault"
              "yt-dlp"
            ];
            # GUI apps go here
            casks = [
              "1password"
              "block-goose"
              "brave-browser"
              "claude"
              "cursor"
              "dbeaver-community"
              "docker-desktop"
              "figma"
              "gcloud-cli"
              "ghostty"
              "google-chrome"
              "google-drive"
              "lm-studio"
              "macwhisper"
              "microsoft-word"
              "obsidian"
              "ollama-app"
              "postgres-app"
              "postman"
              "signal"
              "slack"
              "tailscale-app"
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
              # Make sure only packages specified in this configuration are installed
              cleanup = "uninstall";
              extraFlags = [ "--force" ];
              upgrade = true;
            };
          };

          programs = {
            zsh = {
              enable = true;
            };
          };

          security = {
            # Allow sudo auth via fingerprint; reattach makes it work inside tmux
            pam.services.sudo_local = {
              touchIdAuth = true;
              reattach = true;
            };
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
              sharedModules = [ nixvim.homeModules.nixvim ];
              extraSpecialArgs = { inherit llm-agents oh-my-tmux; };
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
