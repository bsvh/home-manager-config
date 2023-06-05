{ config, pkgs, inputs, ... }:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
    amsmath
    capt-of
    dvipng
    dvisvgm
    hyperref
    mathtools
    physics
    ulem
    wrapfig;
  });
in
{
  nixpkgs.overlays = [
    inputs.emacs.overlay
  ];

  home.packages = with pkgs; [
    mu
   #tex
  ];
  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtk;
    extraPackages = epkgs: [
      epkgs.corfu
      epkgs.consult
      epkgs.diff-hl
      epkgs.eglot
      epkgs.ess
      epkgs.esup
      epkgs.expand-region
      epkgs.flycheck
      epkgs.hide-mode-line
      epkgs.julia-mode
      epkgs.magit
      epkgs.markdown-mode
      epkgs.mixed-pitch
      epkgs.modus-themes
      epkgs.move-text
      epkgs.nix-mode
      epkgs.org-anki
      epkgs.org-bullets
      epkgs.org-modern
      epkgs.python-black
      epkgs.pyvenv
      epkgs.rustic
      epkgs.smtpmail-multi
      #epkgs.toolbox-tramp
      epkgs.use-package
      epkgs.vertico
      epkgs.visual-fill-column
      epkgs.vterm
      epkgs.vterm-toggle
      epkgs.writegood-mode

      pkgs.nodePackages.bash-language-server
      pkgs.nodePackages.pyright
      pkgs.mu
      pkgs.rnix-lsp
    ];
  };

  services.emacs = {
    enable = true;
    socketActivation.enable = true;
    client = {
      enable = true;
      arguments = [
        "--no-wait"
        "--create-frame"
      ];
    };
  };

  xdg.configFile = {
    "early-init.el" = {
      source = ../dotfiles/emacs/early-init.el;
      target = "emacs/early-init.el";
    };
    "init.el" = {
      source = ../dotfiles/emacs/init.el;
      target = "emacs/init.el";
    };
    "accounts.el" = {
      source = ../dotfiles/emacs/accounts.el;
      target = "emacs/accounts.el";
    };
  };
  home.file = {
    ".authinfo.gpg" = {
      source = ../dotfiles/emacs/authinfo.gpg;
      target = ".authinfo.gpg";
    };
  };

  xdg.desktopEntries.org-protocol = {
    name = "Org Protocol";
    exec = "${config.programs.emacs.package}/bin/emacsclient -- %u";
    terminal = false;
    type = "Application";
    categories = [ "System" ];
    mimeType = [ "x-scheme-handler/org-protocol" ];
  };
}
