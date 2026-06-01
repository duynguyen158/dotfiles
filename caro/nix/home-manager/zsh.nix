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

      # Source secrets into shell scope (shell-local, not inherited by child processes).
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

      unlock-vault() {
        local -a vaults=("$HOME"/Library/CloudStorage/*/"My Drive"/second-brain(N/))
        local branch upstream vault

        if (( $#vaults == 0 )); then
          print -u2 "unlock-vault: no second-brain vault found under $HOME/Library/CloudStorage"
          return 1
        elif (( $#vaults > 1 )); then
          print -u2 "unlock-vault: multiple second-brain vaults found"
          print -u2 -l -- $vaults
          return 1
        fi

        vault="$vaults[1]"

        rm -f "$vault/.git/index.lock"

        branch="$(git -C "$vault" symbolic-ref --quiet --short HEAD 2>/dev/null)"
        if [[ -n $branch ]]; then
          rm -f "$vault/.git/refs/heads/$branch.lock"
        fi

        if git -C "$vault" rev-parse --verify HEAD >/dev/null 2>&1; then
          git -C "$vault" restore --staged . || return
        elif upstream="$(git -C "$vault" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)"; then
          git -C "$vault" reset --mixed "$upstream" || return
        elif git -C "$vault" ls-files --cached --error-unmatch . >/dev/null 2>&1; then
          git -C "$vault" rm --cached -r . >/dev/null || return
        fi

        echo "second-brain unlocked"
      }
    '';

    shellAliases = {
      cookiecutter-python = "cookiecutter gh:duynguyen158/cookiecutter-python";
      dotfiles = "zed -n ~/.dotfiles";
      flakeup = "(cd ~/.dotfiles/caro/nix && nix flake update)";
      nixup = "(cd ~/.dotfiles/caro/nix && sudo darwin-rebuild switch --flake .#caro)";
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
