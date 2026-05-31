{ config, pkgs, oh-my-tmux, ... }:

let
  tmuxPlugin = plugin: path: "${plugin}/share/tmux-plugins/${path}";
in
{
  home.packages = [
    pkgs.tmux
    pkgs.perl
    pkgs.gawk
    pkgs.gnugrep
    pkgs.gnused
  ];

  # Keep Oh my tmux's upstream config immutable and put all machine-specific
  # behavior in tmux.conf.local, which is the customization path it expects.
  xdg.configFile."tmux/tmux.conf".source = "${oh-my-tmux}/.tmux.conf";

  xdg.configFile."tmux/tmux.conf.local".text = ''
    # : << 'EOF'
    # caro-specific tmux customizations for Oh my tmux.

    # Preserve the existing prefix behavior: C-a only, not C-b plus C-a.
    set -gu prefix2 #!important
    unbind -q C-b #!important
    set -g prefix C-a #!important
    bind C-a send-prefix #!important

    # Preserve existing Home Manager tmux defaults.
    set -g default-terminal "xterm-256color" #!important
    set -g base-index 0 #!important
    setw -g pane-base-index 0 #!important
    set -g mouse on #!important
    set -g focus-events on #!important
    set -g history-limit 50000 #!important
    set-option -ga terminal-overrides ",xterm-256color:Tc" #!important
    setw -q -g utf8 on #!important

    # Pi/OMP use CSI-u modified keys, including Shift+Enter and Ctrl+Enter.
    set -g extended-keys on #!important
    set -g extended-keys-format csi-u #!important

    # Keep Nix-managed tmux plugins instead of using TPM.
    tmux_conf_update_plugins_on_launch=false
    tmux_conf_update_plugins_on_reload=false
    tmux_conf_uninstall_plugins_on_reload=false
    set -g @continuum-restore 'on'
    set -g @continuum-save-interval '5'
    run-shell -b ${tmuxPlugin pkgs.tmuxPlugins.yank "yank/yank.tmux"}
    run-shell -b ${tmuxPlugin pkgs.tmuxPlugins.resurrect "resurrect/resurrect.tmux"}
    run-shell -b ${tmuxPlugin pkgs.tmuxPlugins.continuum "continuum/continuum.tmux"}

    # Preserve the Night Owl status/theme switcher. Oh my tmux still supplies
    # bindings and helpers; the status line remains controlled by tmux-night-owl.
    tmux_conf_theme=disabled
    run-shell -b "~/.local/bin/tmux-night-owl"
    set-hook -g client-attached "run-shell -b '~/.local/bin/tmux-night-owl'" #!important
    set -g status-left-length 50 #!important
    set -g status-right-length 100 #!important

    # Vi-style copy mode.
    setw -g mode-keys vi #!important
    bind-key -T copy-mode-vi v send-keys -X begin-selection #!important
    bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle #!important

    # Pane splitting opens in the current path.
    bind \\ split-window -h -c "#{pane_current_path}" #!important
    bind - split-window -v -c "#{pane_current_path}" #!important

    # Preserve existing Vim-style pane navigation.
    bind h select-pane -L #!important
    bind j select-pane -D #!important
    bind k select-pane -U #!important
    bind l select-pane -R #!important

    # # /!\ do not remove the following line
    # EOF
    #
    # "$@"
  '';

  home.file.".local/bin/tmux-night-owl" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # dark-notify passes "dark" or "light" as $1; fall back to querying defaults when called manually
      mode="''${1:-}"
      if [ -z "$mode" ]; then
        defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark && mode="dark" || mode="light"
      fi

      apply() {
        local sock="$1"
        # Full path required: this script runs inside a LaunchAgent with a minimal PATH
        # that does not include /etc/profiles/per-user/…/bin
        local tmux="/etc/profiles/per-user/$(id -un)/bin/tmux"
        if [ "$mode" = "dark" ]; then
          $tmux -S "$sock" set -g status-style "bg=#011627,fg=#d6deeb"
          $tmux -S "$sock" set -g window-status-current-style "bg=#82aaff,fg=#011627,bold"
          $tmux -S "$sock" set -g pane-border-style "fg=#5f7e97"
          $tmux -S "$sock" set -g pane-active-border-style "fg=#82aaff"
          $tmux -S "$sock" set -g message-style "bg=#5f7e97,fg=#d6deeb"
          $tmux -S "$sock" set -g status-left "#[bg=#82aaff,fg=#011627,bold] #S #[bg=#011627,fg=#82aaff]"
          $tmux -S "$sock" set -g status-right "#[fg=#c792ea]#(whoami) #[fg=#82aaff]│ #[fg=#21c7a8]%Y-%m-%d %H:%M #[bg=#82aaff,fg=#011627,bold] #h "
        else
          $tmux -S "$sock" set -g status-style "bg=#ffffff,fg=#403f53"
          $tmux -S "$sock" set -g window-status-current-style "bg=#4876d6,fg=#ffffff,bold"
          $tmux -S "$sock" set -g pane-border-style "fg=#d9d9d9"
          $tmux -S "$sock" set -g pane-active-border-style "fg=#4876d6"
          $tmux -S "$sock" set -g message-style "bg=#f2f2f2,fg=#403f53"
          $tmux -S "$sock" set -g status-left "#[bg=#4876d6,fg=#ffffff,bold] #S #[bg=#ffffff,fg=#4876d6]"
          $tmux -S "$sock" set -g status-right "#[fg=#697098]#(whoami) #[fg=#4876d6]│ #[fg=#08916a]%Y-%m-%d %H:%M #[bg=#4876d6,fg=#ffffff,bold] #h "
        fi
      }

      # Must target sockets explicitly: dark-notify runs outside any tmux session
      # so plain `tmux set` would fail with "no server running"
      sock_dir="/tmp/tmux-$(id -u)"
      if [ -d "$sock_dir" ]; then
        for sock in "$sock_dir"/*; do
          [ -S "$sock" ] && apply "$sock"
        done
      fi

      # Update agent theme files — Pi/OMP watch <agent>/themes/night-owl.json and hot-reload on change
      update_agent_theme() {
        local agent_dir="$1"
        local themes_dir="$agent_dir/themes"
        local src_dir="$agent_dir/theme-sources"
        local src="$src_dir/night-owl-''${mode}.json"
        local dest="$themes_dir/night-owl.json"

        [ -f "$src" ] || return 0
        mkdir -p "$themes_dir"
        cp "$src" "$dest" && chmod 644 "$dest" || true
      }

      update_agent_theme "$HOME/.pi/agent"
      update_agent_theme "$HOME/.omp/agent"
    '';
  };

  # Persistent daemon: re-runs tmux-night-owl whenever macOS appearance changes
  launchd.agents.dark-notify-tmux = {
    enable = true;
    config = {
      ProgramArguments = [
        "/opt/homebrew/bin/dark-notify"
        "-c"
        "${config.home.homeDirectory}/.local/bin/tmux-night-owl"
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
