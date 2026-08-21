{ config, lib, pkgs, ... }:

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

  # Keep both Night Owl variants available as plain source files (not
  # `programs.helix.themes`, which would make ~/.config/helix/themes/night-owl.toml
  # a read-only Nix-store symlink). The appearance switcher below copies the
  # matching variant into that path as a writable runtime file, mirroring the
  # pattern used for OMP/Pi in omp.nix.
  home.file.".config/helix/theme-sources/night-owl-dark.toml".source =
    ./helix-themes/night-owl-dark.toml;
  home.file.".config/helix/theme-sources/night-owl-light.toml".source =
    ./helix-themes/night-owl-light.toml;

  # Populate the runtime theme file on activation so a fresh `nixup` (or a
  # newly created generation, which doesn't retrigger inotify on the symlink
  # target) leaves night-owl.toml in place before the appearance-switch
  # daemon next fires.
  home.activation.helixNightOwlTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mode=$(/usr/bin/defaults read -g AppleInterfaceStyle 2>/dev/null | /usr/bin/grep -q Dark && echo dark || echo light)
    src="${config.home.homeDirectory}/.config/helix/theme-sources/night-owl-''${mode}.toml"
    if [ -f "$src" ]; then
      run mkdir -p "${config.home.homeDirectory}/.config/helix/themes"
      run cp "$src" "${config.home.homeDirectory}/.config/helix/themes/night-owl.toml"
      run chmod 644 "${config.home.homeDirectory}/.config/helix/themes/night-owl.toml"
    fi
  '';
}
