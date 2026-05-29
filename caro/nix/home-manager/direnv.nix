{ ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh.shellAliases = {
    direnv-allow = "echo -e 'use nix\ndotenv' > .envrc && touch .env && direnv allow";
  };
}
