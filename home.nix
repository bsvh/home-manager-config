{ config, lib, pkgs, inputs, ... }:
let 
  nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl-wrapper" {} ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    for bin in ${pkg}/bin/*; do
     wrapped_bin=$out/bin/$(basename $bin)
     echo "exec ${lib.getExe pkgs.nixgl.nixGLIntel} $bin \"\$@\"" > $wrapped_bin
     chmod +x $wrapped_bin
    done
  '';
in
{
  imports = [
    ./applications/bash.nix
    ./applications/emacs.nix
    ./applications/fish.nix
    ./applications/git.nix
    ./applications/gnupg.nix
    ./applications/gnome.nix
    ./applications/julia.nix
    ./applications/latex.nix
    ./applications/nvim.nix
    ./applications/offlineimap.nix
    ./applications/rust.nix
    ./applications/starship.nix
    ./applications/tmux.nix
    ./applications/wezterm.nix
  ];

  nixpkgs.overlays = [ inputs.nixgl.overlay ];

  home.username = "bsvh";
  home.homeDirectory = "/home/bsvh";
  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    compsize # btrfs-compsize
    fd
    fff # File manager
    (nixGLWrap ffmpeg)
    fzf
    htop
    httm # Show versions of files w/ btrfs snapshots
    isync
    julia-bin
    libsecret
    lshw
    mediainfo
    (nixGLWrap mpv)
    nixgl.nixGLIntel
    p7zip
    pandoc
    ripgrep
    unzip
    wget
    wl-clipboard
    yt-dlp
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
  programs.wezterm.package = nixGLWrap pkgs.wezterm;
  systemd.user.startServices = "sd-switch";
}
