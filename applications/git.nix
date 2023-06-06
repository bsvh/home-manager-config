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
      stauts = "status";
    };
    ignores = [
      "*~"
      "*.swp"
    ];
    signing = {
      key = "53FFC9ED232C59C99060AC7DA6F2F2656D2D2B70";
    };
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
