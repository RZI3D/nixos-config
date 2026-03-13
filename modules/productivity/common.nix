{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # File Management
    yazi
    thunar
    kdePackages.ark           # archives (zip, tar, etc)
    tumbler        # thumbnail support for thunar

    # Text Editing
    kdePackages.kate   # simple, clean GTK4 editor

    # Media Viewing
    loupe               # image viewer (GTK4)
    vlc                 # video player
    easyeffects         # audio effects/equalizer

    # Screenshots & Recording
    #grim                # screenshot (Wayland)
    #slurp               # region selector for grim
    swappy              # annotation on screenshots
    

    # System Tools
    mission-center      # task manager (like Activity Monitor)
    kdePackages.filelight              # disk usage analyzer
    # gnome-font-viewer   # preview fonts
    qalculate-gtk       # powerful calculator

    # Connectivity
    networkmanagerapplet # wifi tray applet
    blueman             # bluetooth manager

    # Theming Tools
    nwg-look            # GTK theme switcher for Wayland

    # Utilities
    wl-mirror           # mirror displays on Wayland
    pavucontrol         # audio control
    satty               # modern screenshot annotation tool
  ];
}
