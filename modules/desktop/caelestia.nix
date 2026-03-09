{ pkgs, ... }:

let
  caelestia-dots = pkgs.fetchFromGitHub {
    owner = "caelestia-dots";
    repo = "caelestia";
    rev = "ea1a4a815ba0565d726feab4104ba4e448cf9ef4";
    hash = "sha256-QskgyhdXXanKMxPDdEiQzze/zhgS0HciAmHs2gkywds=";
  };

  hypr-patched = pkgs.runCommand "hypr-patched" {} ''
    cp -r ${caelestia-dots}/hypr $out
    chmod -R +w $out
    cat > $out/hyprland/execs.conf << 'EOF'
    # Keyring and auth
    exec-once = gnome-keyring-daemon --start --components=secrets
    exec-once = polkit-gnome-authentication-agent-1
    # Clipboard history
    exec-once = wl-paste --type text --watch cliphist store
    exec-once = wl-paste --type image --watch cliphist store
    # Auto delete trash 30 days old
    exec-once = trash-empty 30
    # Cursors
    exec-once = hyprctl setcursor $cursorTheme $cursorSize
    exec-once = gsettings set org.gnome.desktop.interface cursor-theme '$cursorTheme'
    exec-once = gsettings set org.gnome.desktop.interface cursor-size $cursorSize
    # Night light
    exec-once = sleep 1 && gammastep
    # Forward bluetooth media commands to MPRIS
    exec-once = mpris-proxy
    # Resize and move windows
    exec-once = caelestia resizer -d
    # Shell started via systemd
    EOF
  '';
in
{
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
      environment = [];
    };
    settings = {
      bar.status.showBattery = true;
      paths.wallpaperDir = "~/Pictures/Wallpapers";
      general.apps = {
        terminal = ["kitty"];
        explorer = ["thunar"];
      };
    };
    cli = {
      enable = true;
      settings.theme.enableGtk = true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

  xdg.configFile."hypr" = {
    source = hypr-patched;
    recursive = true;
  };

  home.packages = with pkgs; [
    kitty
    cliphist
    trash-cli
    polkit_gnome
    gammastep
    hyprpicker
    nerd-fonts.caskaydia-cove
  ];
}
