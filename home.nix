{ config, pkgs, ... }:

{
  imports = [
    ./applications/git.nix
    ./applications/gnome.nix
    ./applications/nvim.nix
  ];

  home.username = "bsvh";
  home.homeDirectory = "/home/bsvh";
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    compsize # btrfs-compsize
    fd
    fff # File manager
    fzf
    htop
    httm # Show versions of files w/ btrfs snapshots
    isync
    julia-bin
    libsecret
    lshw
    mediainfo
    p7zip
    pandoc
    ripgrep
    unzip
    wget
  ];

  home.sessionVariables = {
  };


  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
