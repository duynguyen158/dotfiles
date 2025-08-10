{ ... }:

let
  # SSH agent must be turned on via the GUI app for this directory and file to be created
  onePassPath = "~/.1password/agent.sock";
in
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      			Host *
      				IdentityAgent ${onePassPath}
      		'';
  };
}
