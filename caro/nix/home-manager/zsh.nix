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

      # Enable up/down arrow history search
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "^[[A" up-line-or-beginning-search    # Up arrow
      bindkey "^[[B" down-line-or-beginning-search  # Down arrow

      # Add secrets
      for f in "$HOME/.secrets/"*; [[ -f $f ]] && source "$f"

      # Create .nvm if not exists and initialize
      mkdir -p "$HOME/.nvm"
      source $(brew --prefix nvm)/nvm.sh

      # Add gcloud-cli to PATH
      export PATH=$HOMEBREW_PREFIX/share/google-cloud-sdk/bin:"$PATH"

      # Add cargo bin to PATH
      export PATH="$HOME/.cargo/bin:$PATH"

      # Add PostgreSQL Homebrew bin to PATH
      export PATH="$(brew --prefix postgresql@18)/bin:$PATH"

      # Add mise shims to PATH
      export PATH="$HOME/.local/share/mise/shims:$PATH"

      # Add local user bin to PATH
      export PATH="$HOME/.local/bin:$PATH"
      
      # Add LM Studio to PATH
      export PATH="$HOME/.lmstudio/bin:$PATH"

      # Add GitHub CLI auth token (ensure logged in first)
      if ! gh auth status >/dev/null 2>&1; then
        echo "GitHub CLI not authenticated. Please log in:"
        gh auth login
      fi
      export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)

      # Activate mise
      eval "$(mise activate zsh)"
    '';

    shellAliases = {
      cookiecutter-python = "cookiecutter gh:duynguyen158/cookiecutter-python";
      direnv-allow = "echo -e 'use nix\ndotenv' > .envrc && touch .env && direnv allow";
      dotfiles = "zed -n ~/.dotfiles";
      flakeup = "cd ~/.dotfiles/caro/nix && nix flake update";
      nixup = "cd ~/.dotfiles/caro/nix && sudo darwin-rebuild switch --flake .#caro";
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
