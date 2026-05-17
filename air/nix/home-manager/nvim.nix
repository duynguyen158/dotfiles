{ pkgs, lib, ... }:

let
  # night-owl.nvim isn't in nixpkgs, so we build it directly from GitHub.
  night-owl-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "night-owl.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "oxfist";
      repo = "night-owl.nvim";
      rev = "main";
      # Run `nixup` once — it'll fail with the correct hash. Paste it here.
      hash = "sha256-O74rBgyBjFcAoOaW5yghNu98vrctj3ugdvaWX1BN8f0=";
    };
  };
in
{
  programs.nixvim = {
    enable = true;

    extraPlugins = [ night-owl-nvim ];
    colorscheme = "night-owl";

    # Editor behaviour options (equivalent to `set ...` in a vimrc).
    opts = {
      number = true;         # show absolute line number on current line
      relativenumber = true; # show relative line numbers on all other lines (great for jumping: 5j, 12k)
      tabstop = 2;           # a tab character visually spans 2 spaces
      shiftwidth = 2;        # >> and << indent/dedent by 2 spaces
      expandtab = true;      # pressing Tab inserts spaces instead of a tab character
      wrap = false;          # don't soft-wrap long lines
      scrolloff = 8;         # always keep 8 lines visible above/below the cursor
      signcolumn = "yes";    # always show the gutter column (prevents layout shifting when diagnostics appear)
      termguicolors = true;  # enable 24-bit colour (required by most modern themes)
      cursorline = true;     # highlight the line the cursor is on
      updatetime = 250;      # write swap file / fire CursorHold after 250ms of inactivity (snappier LSP hints)
    };

    # Space is the leader key — pressed before shortcuts like <leader>ff.
    globals.mapleader = " ";

    # Keymaps — `<leader>` means Space, `<C-x>` means Ctrl+x, `<cr>` means Enter.
    keymaps = [
      # File explorer (neo-tree)
      { key = "<leader>e"; action = "<cmd>Neotree toggle<cr>"; options.desc = "Toggle file explorer"; }

      # Telescope fuzzy finder
      { key = "<leader>ff"; action = "<cmd>Telescope find_files<cr>"; options.desc = "Find files"; }
      { key = "<leader>fg"; action = "<cmd>Telescope live_grep<cr>"; options.desc = "Live grep"; }
      { key = "<leader>fb"; action = "<cmd>Telescope buffers<cr>"; options.desc = "Buffers"; }
      { key = "<leader>fd"; action = "<cmd>Telescope diagnostics<cr>"; options.desc = "Diagnostics"; }
      { key = "<leader>gs"; action = "<cmd>Telescope git_status<cr>"; options.desc = "Git status"; }

      # Move between splits with Ctrl+hjkl (same feel as tmux pane navigation)
      { key = "<C-h>"; action = "<C-w>h"; }
      { key = "<C-j>"; action = "<C-w>j"; }
      { key = "<C-k>"; action = "<C-w>k"; }
      { key = "<C-l>"; action = "<C-w>l"; }

      # Misc
      { key = "jk"; action = "<Esc>"; mode = "i"; options.desc = "Exit insert mode"; }
      { key = "<Esc>"; action = "<cmd>noh<cr>"; mode = "n"; options.desc = "Clear search highlight"; }
      { key = "<leader>w"; action = "<cmd>w<cr>"; options.desc = "Save"; }
      { key = "<leader>q"; action = "<cmd>q<cr>"; options.desc = "Quit"; }
    ];

    plugins = {
      # neo-tree — sidebar file explorer (toggle with <leader>e)
      neo-tree = {
        enable = true;
        settings.window.width = 30;
      };

      # web-devicons — file-type icons used by neo-tree, telescope, bufferline, etc.
      web-devicons.enable = true;

      # telescope — fuzzy finder for files, grep, buffers, git, diagnostics, and more
      telescope.enable = true;

      # treesitter — fast syntax highlighting and smarter indentation via language grammars
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          # Grammars to download and compile. Add a language here to get highlighting for it.
          ensure_installed = [
            "nix"
            "lua"
            "javascript"
            "typescript"
            "tsx"
            "svelte"
            "html"
            "css"
            "json"
            "yaml"
            "markdown"
            "bash"
            "python"
          ];
        };
      };

      # lsp — Language Server Protocol: powers go-to-definition, hover docs, rename, etc.
      lsp = {
        enable = true;
        keymaps = {
          # Diagnostic = compiler/linter errors and warnings
          diagnostic = {
            "<leader>d" = "open_float"; # show error detail in a floating window
            "[d" = "goto_prev";         # jump to previous diagnostic
            "]d" = "goto_next";         # jump to next diagnostic
          };
          # lspBuf = actions sent to the language server for the current file
          lspBuf = {
            "gd" = "definition";    # go to where this symbol is defined
            "gD" = "declaration";   # go to declaration (differs from definition in e.g. C headers)
            "gr" = "references";    # list everywhere this symbol is used
            "gi" = "implementation"; # go to implementation (useful for interfaces)
            "K" = "hover";          # show type/docs popup under cursor
            "<leader>rn" = "rename";       # rename symbol across the whole project
            "<leader>ca" = "code_action";  # suggest fixes / refactors at cursor
            "<leader>f" = "format";        # format the file via the LSP
          };
        };
        # One entry per language — each talks to its own language server binary.
        servers = {
          nixd.enable = true;    # Nix
          lua_ls.enable = true;  # Lua
          ts_ls.enable = true;   # TypeScript / JavaScript
          svelte.enable = true;  # Svelte
          html.enable = true;    # HTML
          cssls.enable = true;   # CSS / SCSS / Less
          pyright.enable = true; # Python (type checking, hover docs, go-to-def)
        };
      };

      # cmp — autocompletion popup that pulls suggestions from the LSP, open buffers, and file paths
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; } # suggestions from the language server (types, functions, etc.)
            { name = "buffer"; }   # words already in the current file
            { name = "path"; }     # file system paths
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";                                    # manually trigger completion
            "<CR>" = "cmp.mapping.confirm({ select = true })";                         # accept selected item
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })";    # next item
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })";  # previous item
            "<C-u>" = "cmp.mapping.scroll_docs(-4)"; # scroll docs popup up
            "<C-d>" = "cmp.mapping.scroll_docs(4)";  # scroll docs popup down
          };
        };
      };

      # lualine — status bar at the bottom (mode, file name, git branch, diagnostics, etc.)
      lualine = {
        enable = true;
        settings.options.theme = "auto"; # picks a theme that matches the active colorscheme
      };

      # bufferline — tab bar at the top showing open buffers (like browser tabs)
      bufferline.enable = true;

      # gitsigns — shows git diff indicators in the sign column (+, ~, _)
      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "+";
          change.text = "~";
          delete.text = "_";
        };
      };

      # which-key — shows a popup of available keybindings when you pause mid-shortcut
      which-key.enable = true;

      # comment — toggle line/block comments with gcc (line) or gbc (block)
      comment.enable = true;

      # nvim-autopairs — automatically inserts closing brackets, quotes, etc.
      nvim-autopairs.enable = true;

      # conform-nvim — auto-formats files on save using external formatters
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true; # fall back to LSP formatting if no dedicated formatter is found
          };
          # Map each file type to the formatter(s) to run. Lists are tried left-to-right.
          formatters_by_ft = {
            javascript = [ "prettierd" "prettier" ];
            typescript = [ "prettierd" "prettier" ];
            svelte = [ "prettierd" "prettier" ];
            html = [ "prettierd" "prettier" ];
            css = [ "prettierd" "prettier" ];
            json = [ "prettierd" "prettier" ];
            nix = [ "nixfmt" ];
            python = [ "ruff_format" ]; # ruff_format runs `ruff format` (style), fast drop-in for black
          };
        };
      };
    };

    # Formatter binaries that need to be on PATH inside neovim.
    extraPackages = with pkgs; [
      prettierd # faster prettier daemon
      nixfmt    # nix formatter
      pyright   # Python LSP server
      ruff      # Python formatter + linter
    ];
  };
}
