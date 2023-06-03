{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    texlive.combined.scheme-medium
  ];
}
