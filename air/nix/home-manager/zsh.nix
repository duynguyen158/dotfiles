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

      __second_brain_vault() {
        local caller="$1"
        local -a vaults=("$HOME"/Library/CloudStorage/*/"My Drive"/second-brain(N/))

        if (( $#vaults == 0 )); then
          print -u2 "$caller: no second-brain vault found under $HOME/Library/CloudStorage"
          return 1
        elif (( $#vaults > 1 )); then
          print -u2 "$caller: multiple second-brain vaults found"
          print -u2 -l -- $vaults
          return 1
        fi

        print -r -- "$vaults[1]"
      }

      unlock-vault() {
        local branch upstream vault

        vault="$(__second_brain_vault unlock-vault)" || return

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

      sync-vault() {
        local vault branch upstream raw_timestamp timestamp message

        vault="$(__second_brain_vault sync-vault)" || return

        if ! git -C "$vault" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          print -u2 "sync-vault: $vault is not a git repository"
          return 1
        fi

        branch="$(git -C "$vault" branch --show-current)"
        if [[ -z $branch ]]; then
          print -u2 "sync-vault: refusing to sync while HEAD is detached"
          return 1
        fi

        if [[ -n "$(git -C "$vault" status --porcelain)" ]]; then
          git -C "$vault" add --all || return

          if ! git -C "$vault" diff --cached --quiet; then
            raw_timestamp="$(date '+%Y-%m-%d %H:%M:%S%z')"
            timestamp="''${raw_timestamp[1,-3]}:''${raw_timestamp[-2,-1]}"
            message="[$timestamp] Vault backup"
            git -C "$vault" commit -m "$message" || return
          fi
        else
          echo "sync-vault: no local changes to commit"
        fi

        if upstream="$(git -C "$vault" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)"; then
          GIT_MERGE_AUTOEDIT=no git -C "$vault" pull --no-rebase --no-edit || return
          git -C "$vault" push || return
        elif git -C "$vault" remote get-url origin >/dev/null 2>&1; then
          print -u2 "sync-vault: no upstream configured; skipping pull"
          git -C "$vault" push --set-upstream origin "$branch" || return
        else
          print -u2 "sync-vault: no upstream or origin remote configured"
          return 1
        fi

        echo "second-brain synced"
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
