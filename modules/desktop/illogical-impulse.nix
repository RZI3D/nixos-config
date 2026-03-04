{ pkgs, ... }:

{
  programs.illogical-impulse = {
    enable = true;
    dotfiles = {
      fish.enable = true;
      kitty.enable = true;
      starship.enable = true;
    };
  };
  home.packages = with pkgs; [
    hyprland
    bibata-cursors
    # The Theming Engine
    matugen         # Essential: generates colors from wallpaper

    # Desktop Components
    swww            # Wallpaper daemon
    pywal           # Often used as a fallback for colors
    brightnessctl   # Backlight control
    wl-clipboard    # Copy/Paste
    libwebp         # For image processing

    # Audio/Media
    wireplumber
    playerctl
  ];
}
