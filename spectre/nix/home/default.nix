{ config, pkgs, ... }:

{
    # Some configs need to be managed using .config, in which case use stow
    imports = [
        ./git.nix
	./ssh.nix
    ];

    home = {
        stateVersion = "24.11";

	# Specify user-level packages to install here (not to confuse with system packages defined in ../flake.nix)
	packages = with pkgs; [
	];

        sessionVariables = {};
    };

    programs = {};
}
