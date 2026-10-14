# dotfiles

## Machine identity

The current macOS account is `duy.nguyen`. If the account name changes during another migration, update the matching `primaryUser`, Home Manager user, nix-darwin user, home path, trusted-user, and nix-homebrew entries together in `nix/flake.nix` before rebuilding.

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
nix --extra-experimental-features "nix-command flakes" flake update
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

If either the `nixup` alias or `darwin-rebuild` is not available yet, run nix-darwin through Nix instead. This is the documented nix-darwin bootstrap path; it only requires a working Nix installation:

```zsh
cd nix
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake .#caro
```

This syncs Nix packages and configs without changing locked dependencies.

Only run `flakeup` or the explicit update command above when you explicitly want to refresh dependencies.

If a recent update breaks the build and you have not committed the broken `flake.lock`, restore the last checked-in version and rebuild:

```zsh
cd nix
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake .#caro
```

If you already committed or otherwise want a specific rollback point, restore `flake.lock` from a known-good commit or set it back to the last working revisions before rebuilding.

2. Run

```zsh
cd .. # Go back to top level directory
stow -d .config -t ~/.config .
```

to sync .config dotfiles.

## Studio shortcuts

After rebuilding with `nixup`, open a new Zsh shell:

- `studio` opens SSH using the existing `studio` host configuration.
- `studiomp` opens or resumes Studio's native OMP agent in a persistent Herdr `studiomp` session, working in `~/Projects`.

Register Studio once with the native CLI, keeping the saved machine profile out of these dotfiles:

```sh
herdr machine add studio --label Studio --remote-session studiomp
herdr machine list --json
herdr machine status Studio --json
```

Inside Caro Herdr, `studiomp` attaches directly to the remote OMP terminal; `Ctrl-b q` detaches that terminal stream without stopping OMP. Outside Herdr it opens the native remote Herdr UI. `studiomp --attach` forces direct terminal attachment; `--tui` requires a terminal outside Herdr. The shortcut validates the saved machine, session and agent rather than starting a duplicate or falling back to Local.

Close the SSH connection; the Studio process keeps running. Run `studiomp` again to reattach. This is not a transfer of the current Caro conversation or files. Disconnect persistence does not mean a running process survives Studio reboot, OMP exiting, or stopping its Herdr server.
