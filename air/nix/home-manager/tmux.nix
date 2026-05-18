{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    prefix = "C-a";
    mouse = true;
    historyLimit = 50000;

    plugins = [
      pkgs.tmuxPlugins.yank
      pkgs.tmuxPlugins.resurrect
      {
        plugin = pkgs.tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5'
        '';
      }
    ];

    extraConfig = ''
      # True color support
      set-option -ga terminal-overrides ",xterm-256color:Tc"

      # UTF-8 support
      setw -q -g utf8 on

      # Apply Night Owl theme (light/dark follows macOS appearance)
      run-shell "~/.local/bin/tmux-night-owl"
      # client-attached covers the case where appearance changed while tmux was detached
      set-hook -g client-attached "run-shell '~/.local/bin/tmux-night-owl'"

      set -g status-left-length 50
      set -g status-right-length 100

      # Vi-style copy mode
      setw -g mode-keys vi
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle

      # Pane splitting (opens in current path)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Pass modified Enter keys (Shift+Enter, Ctrl+Enter) through to terminal apps
      set -g extended-keys on
      # Set extended keys format for better compatibility with Pi
      set -g extended-keys-format csi-u

      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
    '';
  };

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
