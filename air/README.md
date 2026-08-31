# dotfiles

## Setup

This configuration uses Nix with nix-darwin and home-manager to manage macOS system configuration and dotfiles.

## Update system after changes

1. Run

```zsh
nixup
```

to update flake inputs and sync Nix packages and configs.

If the `nixup` alias is not available yet, or `darwin-rebuild` is not installed or on your `PATH`, run nix-darwin through Nix instead. This is the documented nix-darwin bootstrap path; it only requires a working Nix installation:

```zsh
cd nix
nix --extra-experimental-features "nix-command flakes" flake update
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake .#air
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

2. If the `nixup` alias is not available yet, update flake inputs and rebuild manually. If `darwin-rebuild` is unavailable, use the nix-darwin runner:

```zsh
cd nix
nix --extra-experimental-features "nix-command flakes" flake update
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake .#air
```
