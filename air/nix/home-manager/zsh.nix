{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      # Source secrets into shell scope
      for f in "$HOME/.secrets/"*; [[ -f $f ]] && source "$f"

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

      # Create .nvm if not exists and initialize
      mkdir -p "$HOME/.nvm"
      source $(brew --prefix nvm)/nvm.sh

      # Add LM Studio to PATH
      export PATH="$HOME/.lmstudio/bin:$PATH"

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
      dotfiles = "zed -n ~/.dotfiles";
      cookiecutter-python = "cookiecutter gh:duynguyen158/cookiecutter-python";
      minet = "uvx --prerelease=allow 'minet>=4.1.2'";
      nixup = "(cd ~/.dotfiles/air/nix && nix flake update && sudo darwin-rebuild switch --flake .#air)";
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
