# dotfiles

Declared system packages and settings for my machines, using Nix.

## Neovim

On `air` and `caro`, long lines soft-wrap at the window width by default without
inserting newlines into the file. Run `nixup` and reopen Neovim to apply config
changes; use `:set wrap` to enable wrapping in an existing window immediately.
