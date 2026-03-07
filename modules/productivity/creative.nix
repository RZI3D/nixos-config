{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Illustration & Image Editing
    inkscape
    gimp
    krita
    aseprite      # Unfree - pixel art editor

    # 3D & Game Art
    blender
    pixelorama    # Pixel art editor (free alternative to aseprite)

    # Video & Recording
    kdenlive
    obs-studio

    # Photo Processing
    darktable

    # Audio
    audacity
    lmms

    # Typography
    fontforge
  ];
}
