{ pkgs, ... }:

{
  home.packages = [ pkgs.herdr ];

  xdg.configFile."herdr/config.toml".text = ''
    # Managed by ~/.dotfiles/caro/nix/home-manager/herdr.nix.
    # Herdr is tmux-like, so keep the muscle memory from our tmux.conf.local
    # and let built-in Herdr behavior cover persistence, mouse support, panes,
    # copy-on-select, agent state, and light/dark terminal palette tracking.
    onboarding = false

    [theme]
    # Ghostty already switches between Night Owl and Night Owlish Light.
    # The terminal theme uses the host terminal's foreground/background and
    # 16-color palette instead of hard-coding one static Herdr palette.
    name = "terminal"

    [theme.custom]
    # Keep Herdr on the terminal palette, but do not use ANSI gray as a
    # foreground/background role. In Night Owlish Light, Herdr's terminal theme
    # maps muted/sidebar roles to ANSI gray/dark-gray, which makes active rows
    # and labels collapse into low-contrast gray. Reset keeps those roles on
    # Ghostty's readable default foreground/background in both light and dark.
    surface0 = "reset"
    surface1 = "reset"
    surface_dim = "reset"
    overlay0 = "reset"
    overlay1 = "reset"
    subtext0 = "reset"

    [terminal]
    # Match the tmux split/new-window habit: open new shells where the current
    # pane is, and keep macOS login-shell PATH setup intact.
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
    # Keep notifications inside Herdr instead of sending macOS-level popups.
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
    # tmux keeps 50k lines; Herdr limits scrollback by bytes. This keeps the same
    # intent (large local history) without enabling persisted pane-history files.
    scrollback_limit_bytes = 50000000
  '';
}
