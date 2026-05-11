{ ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    prefix = "C-a";
    mouse = true;
    historyLimit = 50000;

    extraConfig = ''
      # True color support
      set-option -ga terminal-overrides ",xterm-256color:Tc"

      # UTF-8 support
      setw -q -g utf8 on

      # Apply Catppuccin theme (Latte in light mode, Mocha in dark mode)
      run-shell "~/.local/bin/tmux-catppuccin"

      # Re-apply theme when a client attaches (e.g. after toggling macOS appearance)
      set-hook -g client-attached "run-shell '~/.local/bin/tmux-catppuccin'"

      # <prefix>+R: manually refresh theme mid-session after toggling appearance
      bind R run-shell "~/.local/bin/tmux-catppuccin" \; display-message "Theme refreshed"

      set -g status-left-length 50
      set -g status-right-length 100

      # Pane splitting (opens in current path)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
    '';
  };

  home.file.".local/bin/tmux-catppuccin" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
        # Catppuccin Mocha (dark)
        tmux set -g status-style "bg=#1e1e2e,fg=#cdd6f4"
        tmux set -g window-status-current-style "bg=#89b4fa,fg=#1e1e2e,bold"
        tmux set -g pane-border-style "fg=#313244"
        tmux set -g pane-active-border-style "fg=#89b4fa"
        tmux set -g message-style "bg=#313244,fg=#cdd6f4"
        tmux set -g status-left "#[bg=#89b4fa,fg=#1e1e2e,bold] #S #[bg=#1e1e2e,fg=#89b4fa]"
        tmux set -g status-right "#[fg=#f5c2e7]#(whoami) #[fg=#89b4fa]│ #[fg=#cba6f7]%Y-%m-%d %H:%M #[bg=#89b4fa,fg=#1e1e2e,bold] #h "
      else
        # Catppuccin Latte (light)
        tmux set -g status-style "bg=#eff1f5,fg=#4c4f69"
        tmux set -g window-status-current-style "bg=#1e66f5,fg=#eff1f5,bold"
        tmux set -g pane-border-style "fg=#ccd0da"
        tmux set -g pane-active-border-style "fg=#1e66f5"
        tmux set -g message-style "bg=#ccd0da,fg=#4c4f69"
        tmux set -g status-left "#[bg=#1e66f5,fg=#eff1f5,bold] #S #[bg=#eff1f5,fg=#1e66f5]"
        tmux set -g status-right "#[fg=#ea76cb]#(whoami) #[fg=#1e66f5]│ #[fg=#8839ef]%Y-%m-%d %H:%M #[bg=#1e66f5,fg=#eff1f5,bold] #h "
      fi
    '';
  };
}
