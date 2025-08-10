# dotfiles

## Install Nix

Refer to [this page](https://dreamsofcode.io/blog/nix-darwin-my-favorite-package-manager-for-macos). Do not use Determinate since it doesn't play well with `nix-darwin`.

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
