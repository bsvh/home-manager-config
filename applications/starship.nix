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
      "$fill"
      "$cmd_duration"
      "$line_break"
      "[│](bold green) " 
      "$directory"
      "$line_break"
      "[└─$character](bold green) "
    ];

    cmd_duration = {
      format = "[$duration]($style) ";
    };

    fill = {
      symbol = " ";
    };

    git_branch = {
      format = "[$symbol$branch(:$remote_branch)]($style) ";
    };

    git_status = {
      modified = "[󱡓  ](bold yellow)";
      staged = "[  $count ](bold green)";
      untracked = "[  $count ](bold yellow)";
      up_to_date = "";
      conflicted = "[ ](bold red)";
      diverged = "[󱡝 ](bold red)";
      ahead = "[  $count ](bold green)";
      behind = "[  $count ](bold yellow)";
      deleted = "";
      renamed = "";
      format = "[$all_status$ahead_behind]($style)";
      style = "bold blue";
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
