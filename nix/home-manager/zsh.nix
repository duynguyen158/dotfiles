{ ... }:

{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        initExtra = ''
            # zsh pure theme
            autoload -U promptinit; promptinit
            prompt pure

            # McFly
            eval "$(mcfly init zsh)"
        '';
    };
}
