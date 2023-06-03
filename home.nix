{ config, pkgs, ... }:

{
  imports = [
    ./applications/bash.nix
    ./applications/git.nix
    ./applications/gnupg.nix
    ./applications/gnome.nix
    ./applications/nvim.nix
    ./applications/rust.nix
    ./applications/starship.nix
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
      EDITOR = "nvim";
  };
  home.shellAliases = {
    vim = "nvim";
  };

  xdg.userDirs = {
    enable = true;
    desktop = "${config.home.homeDirectory}/desktop";
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/downloads";
    music = "${config.home.homeDirectory}/music";
    pictures = "${config.home.homeDirectory}/pictures";
    publicShare = "${config.home.homeDirectory}/public";
    templates = "${config.home.homeDirectory}/templates";
    videos = "${config.home.homeDirectory}/videos";
  };


  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
