{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    initExtra = ''
      mkcd() { mkdir -p $1 && cd $1; }
    '';
  };
}
