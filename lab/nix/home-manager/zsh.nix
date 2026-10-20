{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      # Source secrets into shell scope (guarded for fresh hosts without ~/.secrets)
      if [[ -d "$HOME/.secrets" ]]; then
        for f in "$HOME/.secrets/"*(N); do
          [[ -f "$f" ]] && source "$f"
        done
      fi

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
    '';

    shellAliases = {
      dotfiles = "nvim ~/.dotfiles";
      cookiecutter-python = "cookiecutter gh:duynguyen158/cookiecutter-python";
      minet = "uvx --prerelease=allow 'minet>=4.1.2'";
      nixup = "home-manager switch --flake ~/.dotfiles/lab/nix#lab";
      flakeup = "nix flake update --flake ~/.dotfiles/lab/nix && home-manager switch --flake ~/.dotfiles/lab/nix#lab";
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
