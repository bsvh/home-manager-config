{config, pkgs, lib, ...}:
with lib.hm.gvariant;
{

  home.packages = with pkgs.gnomeExtensions; [
    adjust-display-brightness
    appindicator
    just-perfection

    # Currently broken
    #night-theme-switcher
  ];

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };

  dconf.settings = {
    "com/github/wwmm/easyeffects" = {
      last-used-input-preset = "Presets";
      last-used-output-preset = "Presets";
      use-dark-theme = true;
    };

    "org/freedesktop/tracker/miner/files" = {
      index-recursive-directories = [];
      index-single-directories = [];
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = false;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 900;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Shift><Super>c" "<Alt>F4" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      switch-applications = [];
      switch-applications-backward = [];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      toggle-maximized = [ "<Shift><Super>m" ];
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = false;
      dynamic-workspaces = false;
      edge-tiling = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Shift><Super>h" ];
      toggle-tiled-right = [ "<Shift><Super>l" ];
    };


    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      control-center = [ "AudioMedia" ];
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "wezterm";
      name = "Open Terminal";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-timeout = 2700;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [ 
        "appindicatorsupport@rgcjonas.gmail.com"
        "just-perfection-desktop@just-perfection"
        "nightthemeswitcher@romainvigier.fr"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
      ];
      favorite-apps = [ 
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "org.wezfurlong.wezterm.desktop"
        "emacsclient.desktop"
        "freetube.desktop"
        "gnome-system-monitor.desktop"
      ];
      welcome-dialog-last-shown-version = "44.0";
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      activities-button = true;
      app-menu = true;
      app-menu-label = true;
      panel-button-padding-size = 5;
      panel-indicator-padding-size = 5;
      ripple-box = false;
      show-apps-button = true;
      workspace-popup = false;
    };

    "org/gnome/shell/extensions/nightthemeswitcher/time" = {
      nightthemeswitcher-ondemand-keybinding = [ "" ];
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
    };

    "org/gnome/software" = {
      first-run = false;
    };

    "org/gnome/system/location" = {
      enabled = true;
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };
  };
}
