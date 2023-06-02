{ config, pkgs, ... }:

{

  home.username = "bsvh";
  home.homeDirectory = "/home/bsvh";
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = [

  ];

  home.sessionVariables = {
  };


  programs.home-manager.enable = true;
}
