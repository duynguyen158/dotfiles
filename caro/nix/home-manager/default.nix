{ pkgs, ... }:

{
  # Some configs need to be managed using .config, in which case use stow
  imports = [
    ./direnv.nix
    ./ghostty.nix
    ./git.nix
    ./nvim.nix
    ./tmux.nix
    ./zsh.nix
  ];

  home = {
    stateVersion = "24.05";

    sessionVariables = {
      TERM = "xterm-256color";
      COLORTERM = "truecolor";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };
  };

  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.commit-mono
  ];

  programs = { };
}
