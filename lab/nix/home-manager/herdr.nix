{ pkgs, ... }:

{
  home.packages = [ pkgs.herdr ];
  home.file.".local/bin/herdr".source = "${pkgs.herdr}/bin/herdr";

  xdg.configFile."herdr/config.toml".text = ''
    # Managed by ~/.dotfiles/lab/nix/home-manager/herdr.nix.
    # Herdr is tmux-like, so keep the muscle memory from our tmux.conf.local
    # and let built-in Herdr behavior cover persistence, mouse support, panes,
    # copy-on-select, agent state, and light/dark terminal palette tracking.
    onboarding = false

    [theme]
    # Use the host terminal palette with Night Owl custom surface accents.
    name = "terminal"
    auto_switch = false
    dark_name = "terminal"
    light_name = "terminal"

    [theme.custom]
    panel_bg = "#011627"
    accent = "#6f8793"
    surface_dim = "#011627"
    active_row_bg = "#0b253a"
    selection_bg = "#1d3b53"
    surface0 = "reset"
    overlay0 = "reset"
    overlay1 = "reset"
    subtext0 = "reset"

    [theme.custom.dark]
    panel_bg = "#011627"
    accent = "#6f8793"
    surface_dim = "#011627"
    active_row_bg = "#0b253a"
    selection_bg = "#1d3b53"

    [theme.custom.light]
    panel_bg = "#f0f0f0"
    accent = "#536767"
    surface_dim = "#f0f0f0"
    active_row_bg = "#d3e8f8"
    selection_bg = "#c2e2f9"

    [terminal]
    # Match the tmux split/new-window habit: open new shells where the current
    # pane is.
    new_cwd = "follow"
    shell_mode = "auto"

    [update]
    # Installed through Nix/Home Manager; Herdr's self-update is not the owner.
    channel = "stable"
    version_check = false
    manifest_check = true

    [keys]
    # Preserve tmux's C-a prefix. Herdr has no secondary prefix, so C-b is left
    # for shells, editors, and Herdr's vim/tmux-style copy mode page-up binding.
    prefix = "ctrl+a"

    # Preserve our tmux pane split/navigation muscle memory.
    split_vertical = "prefix+backslash"
    split_horizontal = "prefix+minus"
    focus_pane_left = "prefix+h"
    focus_pane_down = "prefix+j"
    focus_pane_up = "prefix+k"
    focus_pane_right = "prefix+l"
    swap_pane_left = "prefix+shift+h"
    swap_pane_down = "prefix+shift+j"
    swap_pane_up = "prefix+shift+k"
    swap_pane_right = "prefix+shift+l"
    copy_mode = "prefix+["

    [ui]
    # Explicitly keep the tmux niceties Herdr can model directly.
    mouse_capture = true
    copy_on_select = true
    pane_borders = true
    pane_gaps = true
    show_agent_labels_on_pane_borders = true

    [ui.toast]
    # Keep notifications inside Herdr instead of sending desktop popups.
    delivery = "herdr"
    delay_seconds = 1

    [ui.sound]
    # tmux is silent; keep Herdr notifications visual unless explicitly changed.
    enabled = false

    [session]
    # Keep supported native agent session restore enabled; normal pane/process
    # persistence is built into Herdr.
    resume_agents_on_restore = true

    [advanced]
    # Large local history without enabling persisted pane-history files.
    scrollback_limit_bytes = 50000000
  '';
}
