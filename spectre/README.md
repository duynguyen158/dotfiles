# spectre

Try installing GUI apps on Windows and install only CLI tools this way. GUI experience and performance is just abysmal on WSL.

## Sync packages and home-manager configs
```bash
cd ~/.dotfiles/spectre/nix
sudo nixos-rebuild switch --flake .#spectre
```

## Install Windows programs
1. Download Dev Home if you don't already have it
2. Open Dev Home and go to Machine Configuration
3. Choose "Configuration File" and in the File Explorer pop-up, go to this directory on Linux, then go to `windows` and select the `configuration.winget` file.
4. Agree to the prompts and install.

Unlike those installed using `nixos-rebuild`, programs installed using Dev Home need to be uninstalled manually through Settings. 

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
