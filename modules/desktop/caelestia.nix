{ pkgs, ... }:

{
  programs.caelestia-dots = {
    enable = true;
    hypr.enable = true;
    term.enable = true;
    btop.enable = true;
    foot.enable = true;
    caelestia.enable = true; # shell + CLI, already default true but explicit is fine

    # Customize shell settings through here instead of programs.caelestia
    caelestia.shell.settings = {
      bar.status.showBattery = true;
      paths.wallpaperDir = "~/Pictures/Wallpapers";
    };
  };
}
