{ ... }:

{
  programs.git = {
    enable = true;

    extraConfig = {
      gpg = {
        format = "ssh";
        ssh = {
          program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        };
      };
      commit = {
        gpgsign = true;
      };
      user = {
        # Remember to replace public signing key if needed
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGVR3QQs3FFCSwP1EXFcS4No2pnDNhGmrB9siXeycKkP";
        name = "Duy Nguyen";
        email = "57234880+duynguyen158@users.noreply.github.com";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
