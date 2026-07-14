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

      # Prefer Apple Silicon Homebrew. Rosetta Homebrew may also exist under
      # /usr/local, but nix-homebrew installs the declared brews in /opt/homebrew.
      if [[ -x /opt/homebrew/bin/brew ]]; then
        export HOMEBREW_PREFIX=/opt/homebrew
        export HOMEBREW_CELLAR=/opt/homebrew/Cellar
        export HOMEBREW_REPOSITORY=/opt/homebrew
        path=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" $path)
      elif [[ -x /usr/local/bin/brew ]]; then
        export HOMEBREW_PREFIX=/usr/local
        export HOMEBREW_CELLAR=/usr/local/Cellar
        export HOMEBREW_REPOSITORY=/usr/local/Homebrew
        path=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" $path)
      fi

      # Create .nvm if not exists and initialize when Homebrew's nvm is installed.
      mkdir -p "$HOME/.nvm"
      nvm_sh="$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
      [[ -r "$nvm_sh" ]] && source "$nvm_sh"
      unset nvm_sh

      # Add gcloud-cli to PATH
      [[ -n "$HOMEBREW_PREFIX" ]] && path=("$HOMEBREW_PREFIX/share/google-cloud-sdk/bin" $path)

      # Add cargo bin to PATH
      path=("$HOME/.cargo/bin" $path)

      # Add PostgreSQL Homebrew bin to PATH
      [[ -d "$HOMEBREW_PREFIX/opt/postgresql@18/bin" ]] && path=("$HOMEBREW_PREFIX/opt/postgresql@18/bin" $path)

      # Add mise shims to PATH
      path=("$HOME/.local/share/mise/shims" $path)

      # Add local user bin to PATH
      path=("$HOME/.local/bin" $path)

      # Add LM Studio to PATH
      path=("$HOME/.lmstudio/bin" $path)

      # Add GitHub CLI auth token for Homebrew if available.
      if command -v gh >/dev/null 2>&1; then
        if gh auth status >/dev/null 2>&1; then
          export HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"
        else
          print -u2 "GitHub CLI not authenticated. Run: gh auth login"
        fi
      fi

      # Activate mise when installed.
      command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"

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
