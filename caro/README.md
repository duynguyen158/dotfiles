# dotfiles

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
