# dotfiles

## Install Nix

Refer to [this page](https://dreamsofcode.io/blog/nix-darwin-my-favorite-package-manager-for-macos). Do not use Determinate since it doesn't play well with `nix-darwin`.

## Update secrets

Create new `.zshrc`-like files in the `$HOME/.secrets` directory. Then refer to [Update system after changes](#update-system-after-changes) to sync Nix packages and configs.

## Update flake inputs (e.g., to enable new versions of packages)

If the `nixup` alias is available, run:

```zsh
nixup
```

If the `nixup` alias is not available yet, run:

```zsh
cd nix
nix flake update
```

## Update system after changes

1. Run

```zsh
nixup
```

to update flake inputs and sync Nix packages and configs.

If the `nixup` alias is not available yet, run:

```zsh
cd nix
nix flake update
darwin-rebuild switch --flake .#caro
```

2. Run

```zsh
cd .. # Go back to top level directory
stow -d .config -t ~/.config .
```

to sync .config dotfiles.
