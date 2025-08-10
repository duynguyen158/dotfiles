# dotfiles

## Install Nix

Refer to [this page](https://dreamsofcode.io/blog/nix-darwin-my-favorite-package-manager-for-macos). Do not use Determinate since it doesn't play well with `nix-darwin`.

## Update secrets

Create new `.zshrc`-like files in the `$HOME/.secrets` directory. Then refer to [Update system after changes](#update-system-after-changes) to sync Nix packages and configs.

## Update flake inputs (e.g., to enable new versions of packages)

```zsh
nix flake update
```

## Update system after changes

1. Run

```zsh
cd nix
darwin-rebuild switch --flake .#caro
```

to sync Nix packages and configs.

2. Run

```zsh
cd .. # Go back to top level directory
stow -d .config -t ~/.config .
```

to sync .config dotfiles.
