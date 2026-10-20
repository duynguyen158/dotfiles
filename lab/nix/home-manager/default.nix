{ pkgs, nil, ... }:

{
  imports = [
    ./direnv.nix
    ./git.nix
    ./helix.nix
    ./herdr.nix
    ./nvim.nix
    ./omp.nix
    ./pi.nix
    ./tmux.nix
    ./zsh.nix
  ];

  home = {
    username = "duynguyen";
    homeDirectory = "/home/duynguyen";
    stateVersion = "24.05";
    enableNixpkgsReleaseCheck = false;
    sessionPath = [ "$HOME/.local/bin" ];

    sessionVariables = {
      TERM = "xterm-256color";
      COLORTERM = "truecolor";
      LANG = "C.UTF-8";
      LC_ALL = "C.UTF-8";
    };

    packages = [
      pkgs.curl
      pkgs.git
      pkgs.home-manager
      pkgs.nixd
      pkgs.openssh
      pkgs.pure-prompt
      pkgs.stow
      pkgs.vim
      nil.packages.${pkgs.stdenv.hostPlatform.system}.nil
      pkgs.cookiecutter
      pkgs.duckdb
      pkgs.gh
      pkgs.mcfly
      pkgs.uv
      pkgs.nodejs
      pkgs.ripgrep
      pkgs.fd
      pkgs.fzf
      pkgs.jq
    ];
  };
}
