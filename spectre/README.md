# spectre

## Sync packages and home-manager configs
```bash
cd ~/.dotfiles/spectre/nix
sudo nixos-rebuild switch --flake .#spectre
```

## Sync configs
### Create Linux `.config` symlinks
TKTK

### Create Windows/Microsoft config symlinks
On Windows, open Terminal as administrator, then run:
```bash
cd ~/.dotfiles/spectre
stow -d Microsoft -t /mnt/c/ProgramData/Microsoft .
```
