{ config, lib, pkgs, inputs, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local act = wezterm.action
      wezterm.add_to_config_reload_watch_list(wezterm.config_dir)
      
      local function isViProcess(pane) 
          return pane:get_foreground_process_name():find('n?vim') ~= nil
      end
      
      local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
          if isViProcess(pane) then
              window:perform_action(
                  act.SendKey({ key = vim_direction, mods = 'CTRL' }),
                  pane
              )
          else
              window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
          end
      end
      
      wezterm.on('ActivatePaneDirection-right', function(window, pane)
          conditionalActivatePane(window, pane, 'Right', 'l')
      end)
      wezterm.on('ActivatePaneDirection-left', function(window, pane)
          conditionalActivatePane(window, pane, 'Left', 'h')
      end)
      wezterm.on('ActivatePaneDirection-up', function(window, pane)
          conditionalActivatePane(window, pane, 'Up', 'k')
      end)
      wezterm.on('ActivatePaneDirection-down', function(window, pane)
          conditionalActivatePane(window, pane, 'Down', 'j')
      end)
      
      local config = {
        color_scheme = "tokyonight_night",
        term = "wezterm",
        window_decorations = 'INTEGRATED_BUTTONS|RESIZE',
        window_close_confirmation = 'NeverPrompt',
        use_fancy_tab_bar = false,
        hide_tab_bar_if_only_one_tab = false,
        tab_bar_style = {
      	  window_hide = " - ",
      	  window_hide_hover = " - ",
      	  window_maximize = " □ ",
      	  window_maximize_hover = " □ ",
      	  window_close = " ✖ ",
      	  window_close_hover = " ✖ ",
        },
        font_size = 11,
        font = wezterm.font {
      	family = 'Iosevka Term',
      	weight = 'Medium',
          harfbuzz_features = { "calt", "clig" },
        },
        font_rules = {
          {
      	   intensity = 'Bold',
      	   italic = false,
      	   font = wezterm.font {
      	       family = 'Iosevka Term',
      	       weight = 'Bold',
      	   },
          },
          {
      	   intensity = 'Bold',
      	   italic = true,
      	   font = wezterm.font {
      	       family = 'Iosevka Term',
      	       weight = 'Bold',
      		   style = 'Italic',
      	   },
          },
        },
      
        keys = {
          { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
          { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
          { key = 'h', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-left') },
          { key = 'j', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-down') },
          { key = 'k', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-up') },
          { key = 'l', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-right') },
        },
        mouse_bindings = {
          {
            event = { Down = { streak = 4, button = 'Left' } },
            action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
            mods = 'NONE',
          },
        },
        set_environment_variables = {
          TERMINFO_DIRS = '${config.home.profileDirectory}/share/terminfo',
          WSLENV = 'TERMINFO_DIRS',
          -- Unset variables set by nixGL to prevent issues starting gpu applications from shell
          LIBVA_DRIVERS_PATH = "",
          LIBGL_DRIVERS_PATH = "",
          LD_LIBRARY_PATH  = "",
          __EGL_VENDOR_LIBRARY_FILENAMES = "",
        }
      }
      return config
    '';
  };

  home.packages = with pkgs; [
    timg
  ];
}
