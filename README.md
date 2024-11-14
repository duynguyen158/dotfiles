# dotfiles

## To install or uninstall packages
Make changes in the `nix/flake.nix` file, then run
```zsh
darwin-rebuild switch --flake ~/.dotfiles/nix#duynguyen
```

### To create symlinks in the home directory
```zsh
stow .
```
