# spectre

Try installing GUI apps on Windows and install only CLI tools this way. GUI experience and performance is just abysmal on WSL.

## Sync packages and home-manager configs
```bash
cd ~/.dotfiles/spectre/nix
sudo nixos-rebuild switch --flake .#spectre
```

## Sync configs
### Create Linux `.config` symlinks
TKTK

### Create WSL configs
Symlinks doesn't work so need to resort to copying
```bash
# Copy .wslconfig
cp wsl/.wslconfig.example /mnt/c/Users/<USER>/.wslconfig
# Copy .wslgconfig (if needed)
mkdir -p /mnt/c/ProgramData/Microsoft/WSL/
cp wsl/.wslgconfig.example /mnt/c/ProgramData/Microsoft/WSL/.wslgconfig
```
