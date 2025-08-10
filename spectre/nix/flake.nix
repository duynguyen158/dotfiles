{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
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

          system = {
            stateVersion = "24.05";
          };

          wsl = {
            enable = true;
            defaultUser = "duynguyen";
          };

          environment.systemPackages = [
            # https://nixos.wiki/wiki/1Password
            # Need to install as system package to work with system auth
            pkgs._1password-cli
            pkgs._1password-gui
            pkgs.curl
            pkgs.git
            pkgs.home-manager
            pkgs.stow
            pkgs.vim
          ];

          # Package configurations not available in home-manager
          programs = {
            # See: https://nixos.wiki/wiki/1Password
            # _1password is also _1password-cli in home-manager/default.nix
            _1password = {
              enable = true;
            };
            _1password-gui = {
              enable = true;
              # Certain features, including CLI integration and system authentication support,
              # require enabling PolKit integration on some desktop environments (e.g. Plasma).
              polkitPolicyOwners = [ "duynguyen" ];
            };
          };
        };
    in
    {
      nixosConfigurations.spectre = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          configuration
          home-manager.nixosModules.home-manager
          {
            # home-manager config
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.duynguyen = import ./home/default.nix;
            };
            nix.settings.trusted-users = [ "duynguyen" ];
          }
        ];
      };
    };
}
