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

**stow** — for tools not supported by home-manager (e.g. Zed). Put config under `<machine>/.config/<tool>/`.

**`homebrew.brews` / `homebrew.casks`** — for GUI apps and tools not in nixpkgs.

**`~/.secrets/`** — sensitive env vars sourced by zsh. Never committed.

## Homebrew note

`caro` and `air` pin Homebrew via a `brew-src` flake input to avoid a patched-brew compatibility bug. If adding a new machine, copy this pattern from `air/nix/flake.nix`.
