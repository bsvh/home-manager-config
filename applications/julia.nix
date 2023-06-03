{ inputs, outputs, lib, config, pkgs, ... }: {
  home.sessionVariables.JULIA_DEPOT_PATH = "${config.xdg.dataHome}/sdk/julia/julia";
  home.packages = with pkgs; [
    julia-bin
  ];
}
