# dotfiles

## Setup

This configuration uses Nix with nix-darwin and home-manager to manage macOS system configuration and dotfiles.

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
darwin-rebuild switch --flake .#air
```

2. Run

```zsh
cd .. # Go back to top level directory
stow -d .config -t ~/.config .
```

to sync .config dotfiles.

## Troubleshooting

### Updating Homebrew version for new macOS versions

If you encounter errors like `unknown or unsupported macOS version` when running `darwin-rebuild`, you may need to update nixpkgs to get a newer Homebrew version:

1. If available, run:

```zsh
nixup
```

2. If the `nixup` alias is not available yet, update flake inputs and rebuild manually:

```zsh
cd nix
nix flake update
darwin-rebuild switch --flake .#air
```
