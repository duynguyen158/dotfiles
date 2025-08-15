{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      # zsh pure theme
      autoload -U promptinit; promptinit
      prompt pure

      # McFly
      eval "$(mcfly init zsh)"

      # Enable up/down arrow history search
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "^[[A" up-line-or-beginning-search    # Up arrow
      bindkey "^[[B" down-line-or-beginning-search  # Down arrow

      # Add secrets
      for f in "$HOME/.secrets/"*; [[ -f $f ]] && source "$f"
    '';

    shellAliases = {
      direnv-allow = "echo -e 'use nix\ndotenv' > .envrc && touch .env && direnv allow";
      dotfiles = "zed -n ~/.dotfiles";
      cookiecutter-python = "cookiecutter gh:duynguyen158/cookiecutter-python";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "rust"
      ];
    };
  };
}
