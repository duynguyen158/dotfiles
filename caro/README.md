# dotfiles

## Install Nix

Refer to [this page](https://dreamsofcode.io/blog/nix-darwin-my-favorite-package-manager-for-macos). Do not use Determinate since it doesn't play well with `nix-darwin`.

## Update secrets

Create new `.zshrc`-like files in the `$HOME/.secrets` directory. Then refer to [Update system after changes](#update-system-after-changes) to sync Nix packages and configs.

## Update flake inputs (e.g., to enable new versions of packages)

Do not use the `nixup` alias for dependency updates. `nixup` is now only for rebuilding the system with the currently locked inputs.

To update flake inputs intentionally, use the dedicated update alias:

```zsh
flakeup
```

If that alias is not available yet, run:

```zsh
cd nix
nix flake update
```

If a flake input update breaks the system build, revert `nix/flake.lock` to the last known working revisions and rebuild without updating first.

For example, this repo previously worked with:

- `nixpkgs`: `09061f748ee21f68a089cd5d91ec1859cd93d0be`
- `home-manager`: `c6fe2944ad9f2444b2d767c4a5edee7c166e8a95`

## Update system after changes

1. Run

```zsh
nixup
```

If the `nixup` alias is not available yet, run:

```zsh
cd nix
sudo darwin-rebuild switch --flake .#caro
```

This syncs Nix packages and configs without changing locked dependencies.

Only run `flakeup` or `nix flake update` when you explicitly want to refresh dependencies.

If a recent update breaks the build and you have not committed the broken `flake.lock`, restore the last checked-in version and rebuild:

```zsh
cd nix
git checkout -- flake.lock
sudo darwin-rebuild switch --flake .#caro
```

If you already committed or otherwise want a specific rollback point, restore `flake.lock` from a known-good commit or set it back to the last working revisions before rebuilding.

2. Run

```zsh
cd .. # Go back to top level directory
stow -d .config -t ~/.config .
```

to sync .config dotfiles.
