# dotfiles

## Setup

This configuration uses Nix with nix-darwin and home-manager to manage macOS system configuration and dotfiles.

## Update system after changes

1. Run

```zsh
cd nix
darwin-rebuild switch --flake .#air
```

to sync Nix packages and configs.

2. Run

```zsh
cd .. # Go back to top level directory
stow -d .config -t ~/.config .
```

to sync .config dotfiles.

## Troubleshooting

### Updating Homebrew version for new macOS versions

If you encounter errors like `unknown or unsupported macOS version` when running `darwin-rebuild`, you may need to update nixpkgs to get a newer Homebrew version:

1. Update flake inputs to get the latest packages:

```zsh
cd nix
nix flake update
```

2. Rebuild the system:

```zsh
darwin-rebuild switch --flake .#air
```
