# dotfiles

Declared system packages and settings for my machines, using Nix.

## Neovim

On `air` and `caro`, long lines soft-wrap at the window width by default without
inserting newlines into the file. Run `nixup` and reopen Neovim to apply config
changes; use `:set wrap` to enable wrapping in an existing window immediately.

Markdown files render automatically in normal mode using `render-markdown.nvim`.
Insert mode shows raw Markdown for editing. Use `:RenderMarkdown toggle` to switch
rendering off or on, or `:RenderMarkdown preview` for a rendered split preview.
Rendering changes only the display, not the file contents.
