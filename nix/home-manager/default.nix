{ ... }:

{
    imports = [
        ./zsh.nix
    ];

    home = {
        stateVersion = "24.05";
        
        file = {
            ".config/zed".source = ./../../.config/zed;
        };

        sessionVariables = {};
    };

    programs = {};
}
