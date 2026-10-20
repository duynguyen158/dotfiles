# dotfiles

Declared system packages and settings for my machines, using Nix.

## Machines

- `caro` — macOS (Apple Silicon), managed with `nix-darwin` + Home Manager + Homebrew.
- `air` — macOS (Apple Silicon), managed with `nix-darwin` + Home Manager + Homebrew.
- `spectre` — NixOS on WSL2 (x86_64-linux), managed with NixOS modules + Home Manager.
- [`lab`](lab/README.md) — Headless ARM Linux (aarch64-linux, Ubuntu 22.04 LTS), managed with standalone Home Manager without GUI apps or Homebrew.

## Neovim

On `air` and `caro`, long lines soft-wrap at word boundaries by default without
inserting newlines into the file. A word wider than the window still splits.
Run `nixup` and reopen Neovim to apply config changes; use `:set wrap linebreak`
to enable word-aware wrapping in an existing window immediately.

Neo-tree (`<leader>e`) shows hidden files and folders, including git-ignored items,
by default. Press `H` in the tree to toggle their visibility.

Markdown files render automatically in normal mode using `render-markdown.nvim`.
Insert mode shows raw Markdown for editing. Use `:RenderMarkdown toggle` to switch
rendering off or on, or `:RenderMarkdown preview` for a rendered split preview.
Rendering changes only the display, not the file contents.

### Math in Markdown

Inline `$...$` and block `$$...$$` formulas render as Unicode using the LaTeX
Tree-sitter parser and `latex2text`. This is a readable approximation, not full
LaTeX typesetting.

### LaTeX documents

VimTeX uses the Nix-managed Tectonic compiler for `.tex` files:

- `:VimtexCompileSS` compiles once; rerun it after edits.
- `:VimtexView` opens the PDF in macOS Preview.
- `:VimtexErrors` opens compilation diagnostics.

Tectonic downloads required TeX support files on demand, so the first compilation
may need network access. Preview does not provide source↔PDF navigation.

### CSV and TSV

CSVView automatically aligns `.csv` and `.tsv` files with visual column borders.
Use `:CsvViewToggle` to switch between the table display and raw text.
Rendering preserves file contents and handles quoted CSV fields. While enabled,
CSVView disables wrapping to keep table columns aligned.
