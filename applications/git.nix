{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [ git-crypt ];
  programs.git = {
    enable = true;
    userName = "Brendan Van Hook";
    userEmail = "brendan@vastactive.com";
    diff-so-fancy.enable = true;
    aliases = {
      co = "checkout";
    };
    ignores = [
      "*~"
      "*.swp"
    ];
    extraConfig = {
      merge.tool = "meld";
      mergetool.meld = {
        cmd = ''
          meld "$LOCAL" "$BASE" "$REMOTE" --output "$MERGED"
        '';
      };
    };
  };
}
