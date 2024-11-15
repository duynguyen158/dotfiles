{ ... }:

{
    imports = [
        ./zed.nix
        ./zsh.nix
    ];

    home = {
        stateVersion = "24.05";

        sessionVariables = {};
    };

    programs = {};
}
