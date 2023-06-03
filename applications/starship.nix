{ config, pkgs, inputs, lib, ... }:
{
  programs.starship.enable = true;

  # Disabled here b/c need transient prompt needs to be run after starship
  # Enabled manually in fish.interactiveShellInit
  programs.starship.enableFishIntegration = false;

  programs.starship.settings = {

    character = {
      error_symbol = ">";
      success_symbol = ">";
    };

    continuation_prompt = "▶▶";

    directory = {
      truncation_length = 5;
      truncation_symbol = "…/";
    };

    format = lib.concatStrings [
      "[┌───────────────────> ](bold green)"
      "$all"
      "$line_break"
      "[│](bold green) " 
      "$directory"
      "$line_break"
      "[└─$character](bold green) "
    ];

    git_status = {
      modified = "󱡓  ";
      staged = " \\($count\\) ";
      untracked = " \\($count\\) ";
      up_to_date = "  ";
      conflicted = " ";
      diverged = "󱡝 ";
      ahead = " \\(\${count}\\) ";
      behind = " \\(\${count}\\) ";
      deleted = "󰚃  ";
      renamed = "  ";
      format = "([$all_status$ahead_behind]($style) )";
    };

    shell = {
      bash_indicator = "\\(bash\\)";
      fish_indicator = "";
      zsh_indicator = "\\(zsh\\)";

      disabled = false;
      format = "$indicator";
    };
  };
}
