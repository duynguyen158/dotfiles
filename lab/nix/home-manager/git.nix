{ ... }:

{
  programs.git = {
    enable = true;
    signing.format = "ssh";

    settings = {
      gpg = {
        format = "ssh";
        ssh = {
          program = "ssh-keygen";
        };
      };
      commit = {
        gpgsign = true;
      };
      user = {
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGVR3QQs3FFCSwP1EXFcS4No2pnDNhGmrB9siXeycKkP";
        name = "Duy Nguyen";
        email = "57234880+duynguyen158@users.noreply.github.com";
      };
      core = {
        editor = "nvim";
      };
      init = {
        defaultBranch = "main";
      };
    };

    lfs.enable = true;
  };
}
