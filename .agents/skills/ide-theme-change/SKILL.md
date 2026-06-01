---
name: ide-theme-change
description: Changing, reviewing, or debugging IDE, terminal, OMP/Pi, tmux, Neovim, Zed, or agent UI themes in this dotfiles repo.
condition: User mentions colors, dark mode, light mode, Night Owl, code blocks, status lines, theme switching, or visual contrast.
---

# IDE and agent theme change playbook

Use this when changing visual themes for editor, terminal, tmux, Neovim, Zed, OMP/Pi, Claude, or other agent UI surfaces in this dotfiles repo.

## Repository conventions

- Theme config is machine-scoped. Prefer the active machine directory (`air/`, `caro/`, or `spectre/`) rather than global ad-hoc files.
- On macOS machines, Home Manager modules are preferred for managed config:
  - `air/nix/home-manager/omp.nix` — OMP theme files and extensions.
  - `air/nix/home-manager/pi.nix` — legacy Pi theme files and extensions.
  - `air/nix/home-manager/tmux.nix` — tmux status/theme switching and dark-notify glue.
  - `air/nix/home-manager/nvim.nix` and local theme plugin dirs — Neovim colors.
  - `air/.config/zed/` — Zed config via stow when no Home Manager module is used.
- Mirror `air` changes to `caro` only when the user explicitly wants both machines updated or the affected config is clearly duplicated and machine-independent.

## Required source-of-truth check

Before changing a named theme, find and read the upstream theme files from the creator or canonical project. Do not invent a palette from screenshots.

For Night Owl / Light Owl, use Sarah Drasner's official VS Code theme repo:

- Dark: `https://raw.githubusercontent.com/sdras/night-owl-vscode-theme/main/themes/Night%20Owl-color-theme.json`
- Light: `https://raw.githubusercontent.com/sdras/night-owl-vscode-theme/main/themes/Night%20Owl-Light-color-theme.json`

Map exact upstream colors where the target UI has equivalent concepts:

- background / editor background
- foreground / editor foreground
- border / contrast border / panel border
- selection / active list item
- status bar background and foreground
- comments, keywords, functions, variables, strings, numbers, types/classes, operators, punctuation
- terminal ANSI colors when configuring terminal-like surfaces

Only derive colors when no upstream equivalent exists. In that case, derive from the closest upstream UI surface and state the mapping in the final response.

## OMP/Pi theme specifics

OMP custom themes live under `~/.omp/agent/themes` at runtime and are generated here from Home Manager files under `.omp/agent/theme-sources`. Legacy Pi uses the same pattern under `~/.pi/agent`.

OMP theme files require all current schema tokens. Validate generated JSON for:

- missing required `colors` keys
- extra unsupported `colors` keys
- variable references that are neither hex colors nor entries in `vars`

Key OMP mappings:

- `toolPendingBg`, `toolSuccessBg`, `toolErrorBg`: OMP-specific. Use upstream widget/panel/notification/editor surface colors, not arbitrary light/dark fills.
- `mdCodeBlock`: should usually be the normal readable foreground, not a semantic syntax color.
- `syntax*`: map from upstream token colors, not from terminal ANSI unless the target is terminal-specific.
- `statusLine*`: map from upstream status bar and terminal ANSI colors as appropriate.
- `dim`, `muted`, `toolOutput`, `mdLinkUrl`: check contrast. These are common sources of unreadable text.
- For OMP/Pi light themes, Light Owl's official gray/yellow/teal token colors can be too low-contrast on `#f0f0f0`/`#f6f6f6` tool surfaces. Keep upstream Light Owl surfaces and primary hues exact, but use darker same-hue variants for small/status/syntax roles when contrast requires it.

## Dark/light switching

When a theme switches with macOS appearance:

1. Check the startup extension that selects the initial theme.
2. Check any `dark-notify`/tmux script that hot-updates running sessions.
3. Ensure the runtime theme directory exists before copying into it.
4. Update every active agent runtime that the repo manages (`~/.omp/agent` and legacy `~/.pi/agent` if both are configured).
5. Prefer overwriting the watched theme file in place with valid JSON. If deleting first, ensure a failed copy cannot leave the theme missing.

For this repo, `tmux-night-owl` should update both:

```sh
$HOME/.pi/agent/themes/night-owl.json
$HOME/.omp/agent/themes/night-owl.json
```

## Known limits and failed approaches

- OMP/Pi output already emitted into terminal/tmux history with truecolor background attributes cannot be reliably recolored later by changing the active theme. Treat historical scrollback as immutable unless the runtime itself reprints it.
- Do not make OMP/Pi message or tool backgrounds transparent as a default workaround for scrollback mismatch; the user found the solid backgrounds more legible.
- Do not retry the tmux `pane-colours[]`/numeric palette-slot workaround for OMP/Pi scrollback without a fresh source-level reproducer. It was tested and did not fix the user's real session behavior.

## Contrast and readability checks

Do not rely on screenshots alone. Check representative foreground/background contrast for:

- default text on main background
- tool output on tool backgrounds
- code-block text on message background
- comments and dim text on dark backgrounds
- status line segment colors on status background
- light-mode colored syntax on light tool/message backgrounds

Prefer WCAG-ish contrast ratios as a sanity check, but preserve the official palette where the original theme intentionally uses low-contrast comments or dim labels.

## Verification

For Nix-managed changes, verify at least:

```sh
nix eval .#darwinConfigurations.<machine>.config.system.stateVersion
nix build .#darwinConfigurations.<machine>.system --no-link
```

For generated OMP/Pi themes, evaluate the Home Manager `home.file` text for the dark and light JSON files and parse it. Confirm required keys, extras, and references.

For live switching fixes, verify the generated script contains the expected runtime targets and creates missing theme directories.

## Final response requirements

Report:

- which files changed
- which upstream palette files were used
- which colors were exact upstream matches
- which colors were derived because no exact target concept exists
- what commands validated the change
- whether the user must restart the app/session or run `nixup`
