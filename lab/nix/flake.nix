{
  description = "Duy Nguyen's Lab Nix System Configuration (Headless ARM Linux)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nil.url = "github:oxalica/nil";
    herdr = {
      url = "github:herdrdev/herdr/v0.9.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    {
      self,
      nixpkgs,
      nil,
      herdr,
      home-manager,
      nixvim,
      llm-agents,
      oh-my-tmux,
      ...
    }:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ herdr.overlays.default ];
      };
    in
    {
      packages.${system} = {
        home-manager = pkgs.home-manager;
        default = pkgs.home-manager;
      };

      homeConfigurations.lab = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nixvim.homeModules.nixvim
          ./home-manager/default.nix
        ];
        extraSpecialArgs = {
          inherit nil llm-agents oh-my-tmux;
        };
      };
    };
}
