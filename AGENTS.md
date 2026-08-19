# dotfiles

Nix-managed dotfiles for my machines. Each has its own directory with the same internal layout.

| Directory  | Machine               |
| ---------- | --------------------- |
| `caro/`    | macOS (Apple Silicon) |
| `air/`     | macOS (Apple Silicon) |
| `spectre/` | NixOS on WSL2         |

## Directory layout

```
<machine>/
├── .config/            # XDG config files managed via GNU stow
└── nix/
    ├── flake.nix       # nix-darwin system config + Homebrew packages
    ├── flake.lock
    └── home-manager/
        ├── default.nix # imports all modules below
        ├── git.nix
        ├── zsh.nix
        ├── tmux.nix
        └── *.nix       # one file per program
```

## Applying changes

```zsh
nixup    # rebuild with locked deps (darwin-rebuild switch --flake .#<machine>)
flakeup  # update flake.lock then rebuild
```

After `nixup`, re-stow if any `.config/` files changed:

```zsh
cd ~/.dotfiles/<machine> && stow -d .config -t ~/.config .
```

## Agent skills

- `.agents/skills/ide-theme-change/` — use for IDE, terminal, OMP/Pi, tmux, Neovim, Zed, and agent UI theme work.
- `.agents/skills/session-retrospective/` — use at session wrap-up to capture durable repo-specific lessons in `AGENTS.md` or existing skills.

## Where to put things

**home-manager module** — preferred for anything with a `programs.<tool>` module in home-manager. One file per program, imported in `default.nix`. Use `extraConfig` for settings the module doesn't expose natively.

When changing duplicated macOS Home Manager modules, check both `caro/` and `air/`; mirror machine-independent fixes when requested or clearly applicable.

Shell helpers for the `second-brain` Obsidian vault live in both macOS zsh modules (`caro/nix/home-manager/zsh.nix` and `air/nix/home-manager/zsh.nix`). The vault is discovered under `~/Library/CloudStorage/*/My Drive/second-brain`; check the vault's Obsidian Git plugin config before changing helper behavior.
Herdr is Home Manager managed on both `caro` and `air`, in `<machine>/nix/home-manager/herdr.nix`. Keep Pi/OMP Herdr integrations declarative by sourcing the official assets from `pkgs.herdr.src` in the existing `pi.nix`/`omp.nix` modules rather than running `herdr integration install`, which mutates runtime config. Mirror Herdr changes to both machines' `herdr.nix`/`tmux.nix`/`omp.nix`/`pi.nix` unless the change is explicitly machine-specific.
The `caro` macOS account is currently `duy.nguyen` (not the legacy `duynguyen`). Keep `system.primaryUser`, the Home Manager and nix-darwin user keys, `/Users/...` home path, `nix.settings.trusted-users`, and `nix-homebrew.user` synchronized when migrating this machine again.

**stow** — for tools not supported by home-manager (e.g. Zed). Put config under `<machine>/.config/<tool>/`. Zed `settings.json` is intentionally machine-local and ignored; keep shared Zed config limited to tracked files like `keymap.json` unless the user asks otherwise.

**`homebrew.brews` / `homebrew.casks`** — for GUI apps and tools not in nixpkgs.

**`~/.secrets/`** — sensitive env vars sourced by zsh. Never committed.

## Homebrew note

`caro` and `air` pin Homebrew via a `brew-src` flake input to avoid a patched-brew compatibility bug. If adding a new machine, copy this pattern from `air/nix/flake.nix`.
For third-party taps on Homebrew versions with tap trust checks, remember nix-darwin's Homebrew activation runs under `sudo` and does not inherit `environment.variables`; put activation-only Homebrew env vars under `homebrew.onActivation.extraEnv`.

If `nixup` fails in Homebrew Bundle with `google-chrome` reporting an existing
App under `/opt/homebrew/Caskroom`, Chrome's self-updater may have advanced
`/Applications/Google Chrome.app` while the cask receipt stayed old. Close
Chrome, repair the cask with an administrator-authorized reinstall, and avoid
`--zap` so the browser profile is preserved.
