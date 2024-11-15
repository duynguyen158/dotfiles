{
    description = "Duy Nguyen's Nix System Configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        nix-darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
           url = "github:nix-community/home-manager";
           inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, nix-darwin, nixpkgs, ... }:
    let
        configuration = { pkgs, ... }: {
            # Enable installing packages with an unfree license
            nixpkgs.config.allowUnfree = true;

            nix = {
                settings = {
                    experimental-features = [ "nix-command" "flakes" ];
                };
            };

            # List Nix packages installed in system profile. To search by name, run:
            # $ nix-env -qaP | grep wget
            # Can include both CLI tools and GUI applications
            environment.systemPackages =
                [
                    pkgs.git
                    pkgs.home-manager
                    pkgs.nixd
                    pkgs.openssh
                    pkgs.pure-prompt
                    pkgs.vim
                ];

            # List packages to be instaled by Homebrew.
            homebrew = {
                enable = true;
                # CLI tools go here
                brews = [
                    # CLI to search for apps and their ID on the App Store
                    "mas"
                    # Shell history search
                    "mcfly"
                ];
                # GUI apps go here
                casks = [
                    "1password"
                    "brave-browser"
                    "obsidian"
                    "zed"
                ];
                # Mac App Store apps go here
                # Make sure you're logged in to the App Store and have purchased each app
                # Use the `mas search` command to search for the app ID
                masApps = {};
                # Make sure only packages specified in this configuartion are installed
                onActivation.cleanup = "zap";
            };

            programs = {
                zsh = {
                    enable = true;
                };
            };

            services = {
                # Auto upgrade nix package and the daemon service.
                nix-daemon.enable = true;
            };

            security = {
                # Allow sudo auth via fingerprint
                pam.enableSudoTouchIdAuth = true;
            };

            # # Allows Spotlight Search to discover installed apps
            # system.activationScripts.applications.text = let
            #     env = pkgs.buildEnv {
            #         name = "system-applications";
            #         paths = config.environment.systemPackages;
            #         pathsToLink = "/Applications";
            #     };
            # in
            #     pkgs.lib.mkForce ''
            #         # Set up applications.
            #         echo "setting up /Applications..." >&2
            #         rm -rf /Applications/Nix\ Apps
            #         mkdir -p /Applications/Nix\ Apps
            #         find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
            #         while read -r src; do
            #             app_name=$(basename "$src")
            #             echo "copying $src" >&2
            #             ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            #         done
            #     '';

            # Enable alternative shell support in nix-darwin.
            # programs.fish.enable = true;

            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;

            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            system.stateVersion = 5;

            # The platform the configuration will be used on.
            nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
        # Build darwin flake using:
        # $ darwin-rebuild build --flake .#simple
        darwinConfigurations."Duys-MacBook-Air" = nix-darwin.lib.darwinSystem {
            modules = [
                configuration
            ];
        };

        # Expose the package set, including overlays, for convenience.
        darwinPackages = self.darwinConfigurations."Duys-MacBook-Air".pkgs;
    };
}
