# lab dotfiles

Standalone Home Manager configuration for headless ARM Linux (`aarch64-linux`, Ubuntu 22.04 LTS).

## Prerequisites & Nix Installation

Lab is a headless remote machine where commands run without interactive `sudo` prompts during configuration rebuilds. The dotfiles profile is applied using standalone Home Manager rather than `nix-darwin` or NixOS system modules.

1. **Install Nix** using the official multi-user installer (or Determinate Systems installer):
   Installation needs interactive `sudo`; subsequent Home Manager rebuilds do not.
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```
2. Ensure Nix experimental features (`nix-command flakes`) are enabled in `/etc/nix/nix.conf` or `~/.config/nix/nix.conf`:
   ```text
   experimental-features = nix-command flakes
   ```
3. Restart your shell or source `/etc/profile.d/nix.sh` so `nix` is on your `$PATH`.

## Setup & First-Time Activation (Bootstrap)

1. **Clone the repository** onto Lab using HTTPS (avoiding reliance on global SSH key configuration before setup):
   ```bash
   git clone https://github.com/duynguyen158/dotfiles.git ~/.dotfiles
   ```

2. **Review existing dotfiles & handle collision backup**:
   The remote host may already have existing user configuration files (such as `~/.zshrc`, `~/.gitconfig`, or directories in `~/.config`). Home Manager will refuse to overwrite existing unmanaged files by default.

   Review your existing configuration first. When ready to activate, pass `-b pre-lab` to back up any conflicting unmanaged files to `*.pre-lab`:
   ```bash
   cd ~/.dotfiles/lab/nix
   nix run .#home-manager -- switch --flake .#lab -b pre-lab
   ```
   This uses the locked `home-manager` package provided directly by this flake to create backups (e.g., `~/.zshrc.pre-lab`, `~/.gitconfig.pre-lab`) instead of overwriting them directly, allowing you to inspect and migrate any custom shell settings, existing `nvm`/`pyenv` setups, or local paths.

3. **Session environment**:
   After activation, start a new Zsh shell or source `~/.nix-profile/etc/profile.d/hm-session-vars.sh`.

4. **No GNU Stow needed**:
   Unlike macOS profiles with `.config/zed`, `lab` manages all terminal and development configurations declaratively via Home Manager modules; there is no `lab/.config` directory and no `stow` step is required.

## Daily Workflow & Rebuilding

Inside `~/.dotfiles/lab/nix`:

- `nixup` — Rebuild and apply changes using locked dependencies:
  ```bash
  home-manager switch --flake .#lab
  ```
- `flakeup` — Update `flake.lock` inputs and rebuild:
  ```bash
  nix flake update && home-manager switch --flake .#lab
  ```

## Portability Decisions & GUI Exclusions

- **Headless Linux**: No macOS-specific hooks (`defaults read AppleInterfaceStyle`, `pbcopy`, etc.), fonts, Homebrew, or GUI applications (Ghostty, Zed, etc.).
- **Terminal & Dev Tools**: Includes Git, Neovim (via NixVim), Helix, Tmux (with `oh-my-tmux`), Zsh, Direnv, Herdr, OMP, and Pi.
- **Base CLI Packages**: Bundles `curl`, `git`, `home-manager`, `nixd`, `openssh`, `pure-prompt`, `stow`, `vim`, `nil`, `cookiecutter`, `duckdb`, `gh`, `mcfly`, `uv`, and `nodejs`.
- **Headless editing**: LaTeX compilation remains available, but VimTeX PDF viewing and its X11 helper are disabled. Night Owl defaults to dark without macOS appearance watchers.
- **Herdr compatibility**: Lab pins upstream Herdr 0.9.3 separately from Air's older nixpkgs package. Home Manager manages `~/.local/bin/herdr` as a symlink to that package, replacing the bootstrap binary with a `*.pre-lab` backup during first activation. Builds compile Herdr from source; they do not restart the live server.
- **No HTTPS-to-SSH Git rewrite**: Omitted the `url."git@github.com:".insteadOf` rule so cloning and fetching public repositories over HTTPS works immediately without needing GitHub SSH keys preconfigured on Lab.

## Credentials & Host-Local Setup

- **Secrets**: Secrets and local environment overrides stay in `~/.secrets/` (host-local) and are never committed to git.
- **Git Commit Signing via OpenSSH**: Git commit signing is configured with OpenSSH (`gpg.format = ssh`, using `ssh-keygen`) and configured for the public key. For commits to succeed, the matching private key must be available to SSH, either:
  - Loaded into an SSH agent with agent forwarding (`ssh -A lab`) if you explicitly choose to trust Lab (note that root or other processes on Lab can access the forwarded agent socket while connected); or
  - A matching host-local key loaded in `ssh-agent` on Lab.
  - Private keys should **never** be copied unencrypted or committed to the repository.

## Remote Herdr & Session Management

To interact with Lab from your local workstation:
- Open the remote Herdr TUI session:
  ```bash
  herdr --remote lab --session lab
  ```
- Inspect machine or server status via the CLI API (using exact machine case `Lab`):
  ```bash
  herdr --machine Lab status server --json
  ```
- Or SSH directly into Lab and reconnect or start your session:
  ```bash
  ssh lab
  ~/.local/bin/herdr --session lab
  ```
