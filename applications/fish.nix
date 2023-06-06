{ config, pkgs, inputs, ... }:
{
  programs.fish = {
    enable = true;
    functions = {
      mkcd = "mkdir -p $argv[1] && cd $argv[1]";
    };

    interactiveShellInit = ''
      set -U fish_greeting

      if test "$TERM" != dumb -a \( -z "$INSIDE_EMACS" -o "$INSIDE_EMACS" = vterm \)
          eval (${pkgs.starship}/bin/starship init fish)
          enable_transience
      end

      # Wezterm Integration
      function __wezterm_mark_prompt_start --on-event fish_prompt --on-event fish_cancel --on-event fish_posterror
          test "$__wezterm_prompt_state" != prompt-start
          and echo -en "\e]133;D\a"
          set --global __wezterm_prompt_state prompt-start
          echo -en "\e]133;A\a"
      end
      __wezterm_mark_prompt_start
      
      function __wezterm_mark_output_start --on-event fish_preexec
          set --global __wezterm_prompt_state pre-exec
          echo -en "\e]133;C\a"
      end
      
      function __wezterm_mark_output_end --on-event fish_postexec
          set --global __wezterm_prompt_state post-exec
          echo -en "\e]133;D;$status\a"
      end
    '';

    shellAbbrs = {
      gco = "git checkout";
      gpo = "git push origin";
      gpu = "git pull";
      hms = "home-manager switch -b backup";
    };
  };
}
