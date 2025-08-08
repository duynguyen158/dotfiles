{ ... }:

{
    # Some configs need to be managed using .config, in which case use stow
    imports = [
        ./direnv.nix
        ./git.nix
        ./zsh.nix
    ];

    home = {
        stateVersion = "24.05";

        sessionVariables = {};
    };

    programs = {};
}
