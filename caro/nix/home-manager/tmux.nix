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

      # Catppuccin Mocha theme
      set -g status-style "bg=#1e1e2e,fg=#cdd6f4"
      set -g window-status-current-style "bg=#89b4fa,fg=#1e1e2e,bold"
      set -g pane-border-style "fg=#313244"
      set -g pane-active-border-style "fg=#89b4fa"
      set -g message-style "bg=#313244,fg=#cdd6f4"

      # Status bar
      set -g status-left "#[bg=#89b4fa,fg=#1e1e2e,bold] #S #[bg=#1e1e2e,fg=#89b4fa]"
      set -g status-right "#[fg=#f5c2e7]#(whoami) #[fg=#89b4fa]│ #[fg=#cba6f7]%Y-%m-%d %H:%M #[bg=#89b4fa,fg=#1e1e2e,bold] #h "
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
}
