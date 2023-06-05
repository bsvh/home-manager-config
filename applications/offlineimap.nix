{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    (offlineimap.overrideAttrs (oldAttrs: rec {
      propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ python3.pkgs.keyring ];
    }))

  ];
}
