{ pkgs, ... }:

{
  # 1. Install the packages needed for your custom desktop
  home.packages = with pkgs; [
    swww            # Wallpaper
    waybar          # Status bar
    dunst           # Notifications
    kitty           # Terminal
    rofi-wayland    # App launcher
  ];

  # 2. Tell Home Manager to manage Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    # This is where your custom config goes!
    settings = {
      # This looks like standard Hyprland config, but in Nix syntax
      "monitor" = ",preferred,auto,1";

      "exec-once" = [
        "swww init"
        "waybar"
      ];

      "input" = {
        "kb_layout" = "us";
        "follow_mouse" = 1;
        "touchpad" = {
          "natural_scroll" = false;
        };
      };

      "general" = {
        "gaps_in" = 5;
        "gaps_out" = 10;
        "border_size" = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "layout" = "dwindle";
      };

      "decoration" = {
        "rounding" = 10;
        "blur" = {
          "enabled" = true;
          "size" = 3;
        };
      };

      # Keybinds (Nix lists use [ ] and space separation)
      "$mod" = "SUPER";
      "bind" = [
        "$mod, Q, exec, kitty"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, dolphin"
        "$mod, V, togglefloating,"
        "$mod, R, exec, rofi -show drun"
      ];
    };
  };
}
