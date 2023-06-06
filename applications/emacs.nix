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
  emacsBin = "${config.programs.emacs.package}/bin";
  emacsFlags = "--no-wait --alternate-editor= ";
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
    package = pkgs.emacs-pgtk;
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
    client = {
      enable = false;
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

  xdg.desktopEntries.emacs = {
    name = "Emacs";
    genericName = "Text Editor";
    comment = "Edit text";
    exec = "${emacsBin}/emacsclient ${emacsFlags} --reuse-frame %F";
    type = "Application";
    icon = "emacs";
    terminal = false;
    categories = [ "Development" "TextEditor" ];
    mimeType = [
      "text/english"
      "text/plain"
      "text/x-makefile"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "application/x-shellscript"
      "text/x-c"
      "text/x-c++"
    ];
    settings = {
      "StartupWMClass" = "emacs";
    };
    actions = {
      "new-window" = {
        name = "New Window";
        exec = "${emacsBin}/emacsclient --no-wait --create-frame %F";
      };
      "new-instance" = {
        name = "New Instance";
        exec = "${emacsBin}/emacs %F";
      };
    };
  };

  xdg.desktopEntries.emacsclient-mail = {
    name = "Emacs (Mail, Client)";
    genericName = "Text Editor";
    comment = "Edit text";
    exec = "${emacsBin}/emacsclient --alternate-editor= --reuse-frame --eval \"(browse-url-mail \\\"%F\\\")\"";
    type = "Application";
    icon = "emacs";
    noDisplay = true;
    terminal = false;
    mimeType = [ "x-scheme-handler/mailto" ];
    settings = {
      "StartupWMClass" = "emacs";
    };
  };

  xdg.desktopEntries.org-protocol = {
    name = "Org Protocol";
    exec = "${emacsBin}/emacsclient -- %u";
    terminal = false;
    type = "Application";
    categories = [ "System" ];
    noDisplay = true;
    mimeType = [ "x-scheme-handler/org-protocol" ];
  };
}
