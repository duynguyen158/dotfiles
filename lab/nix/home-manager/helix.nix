{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    package = pkgs.helix;

    settings = {
      theme = "night-owl";
      editor = {
        line-number = "relative";
        cursorline = true;
        scrolloff = 8;
        true-color = true;
        color-modes = true;
        bufferline = "multiple";
        soft-wrap.enable = false;
        indent-guides.render = true;
        lsp.display-messages = true;
      };
    };
  };

  # Make Night Owl themes available in Helix's themes directory.
  # Default night-owl.toml points to the dark variant.
  home.file.".config/helix/themes/night-owl.toml".source =
    ./helix-themes/night-owl-dark.toml;
  home.file.".config/helix/themes/night-owl-dark.toml".source =
    ./helix-themes/night-owl-dark.toml;
  home.file.".config/helix/themes/night-owl-light.toml".source =
    ./helix-themes/night-owl-light.toml;
}
