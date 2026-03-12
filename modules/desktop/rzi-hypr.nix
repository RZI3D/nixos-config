{ inputs, pkgs, config, ... }:

{
  # ── Catppuccin global theme ─────────────────────────────────────────────────
  catppuccin.flavor = "mocha";
  catppuccin.accent = "mauve";

  # ── Packages ─────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.system}.quickshell
    (callPackage ../../pkgs/rzi-shell {})

    # Wallpaper
    swww
    papirus-icon-theme
    # Media / HW controls (used by quickshell widgets)
    playerctl
    brightnessctl
    wireplumber      # wpctl for volume

    # Screenshot
    grimblast
    wl-clipboard

    # Utility
    libnotify        # notify-send (for testing notifications)
  ];

  # ── Kitty terminal (Catppuccin via HM module) ────────────────────────────────
  catppuccin.kitty.enable = true;
  programs.kitty = {
    enable = true;
    settings = {
      font_family          = "JetBrainsMono Nerd Font";
      font_size            = "12.0";
      window_padding_width = 12;
      background_opacity   = "0.92";
      confirm_os_window_close = 0;
    };
  };
  
  # -- Helix --
  catppuccin.helix.enable = true;

  # ── GTK & QT theming ──────────────────────────────────────────────────────────────
  #catppuccin.gtk = {
  #  enable = true;
  #  tweaks = [ "rimless" ];
  #};
  #qt = {
  #  enable = true;
  #  platformTheme.name = "gtk";
  #  style.name = "kvantum";
  #};
 
  gtk.iconTheme = {
    name    = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };

  catppuccin.firefox.enable = true;

  # ── Cursor ───────────────────────────────────────────────────────────────────
  home.pointerCursor = {
    name    = "catppuccin-mocha-mauve-cursors";
    package = pkgs.catppuccin-cursors.mochaMauve;
    size    = 24;
    gtk.enable = true;
  };

  # ── Hyprland ─────────────────────────────────────────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "swww-daemon"
        "swww img ~/Pictures/Wallpapers/nix-hex.jpg --transition-type grow --transition-pos center"
        "quickshell -c rzi"
      ];

      general = {
        gaps_in  = 5;
        gaps_out = 12;
        border_size = 2;
        "col.active_border"   = "rgb(cba6f7) rgb(89b4fa) 45deg"; # mauve → blue
        "col.inactive_border" = "rgb(313244)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 12;
        blur = {
          enabled = true;
          size    = 8;
          passes  = 2;
          popups  = true;
        };
        shadow = {
          enabled = true;
          range   = 20;
          color   = "rgba(1e1e2eCC)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOut, 0.16, 1, 0.3, 1"
          "spring, 0.68, -0.55, 0.27, 1.55"
        ];
        animation = [
          "windows,    1, 5, spring, popin 80%"
          "windowsOut, 1, 4, easeOut, popin 80%"
          "fade,       1, 4, easeOut"
          "workspaces, 1, 5, easeOut, slide"
          "border,     1, 6, default"
        ];
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
        touchpad.tap-to-click   = true;
      };

      dwindle = {
        pseudotile     = true;
        preserve_split = true;
      };

      misc = {
        disable_hyprland_logo   = true;
        disable_splash_rendering = true;
        animate_manual_resizes  = true;
      };

      # Allow quickshell layers to blur properly
      layerrule = [
        "match:namespace quickshell, blur on"
        "match:namespace quickshell, ignore_alpha 0.5"
      ];

      windowrule = [
        "match:class pavucontrol, float on"
        "match:class pavucontrol, center on"
        "match:class nm-connection-editor, float on"
      ];

      "$mod" = "SUPER";

      bind = [
        "$mod, Space, exec, quickshell ipc -c rzi call launcher toggleLauncher"
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod, P, exec, hyprpicker -a"         # color picker
        "$mod, S, exec, grimblast copy area"   # screenshot
        "$mod SHIFT, S, exec, grimblast save area ~/Pictures/Screenshots/$(date +%F_%T).png"

        # Focus
        "$mod, left,  movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up,    movefocus, u"
        "$mod, down,  movefocus, d"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        # Move
        "$mod SHIFT, left,  movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up,    movewindow, u"
        "$mod SHIFT, down,  movewindow, d"
      ] ++ (
        builtins.concatLists (builtins.genList (i:
          let ws = toString (i + 1); in [
            "$mod, ${ws}, workspace, ${ws}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
          ]
        ) 9)
      );

      # Mouse binds
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Media / brightness (works even while holding other keys)
      bindel = [
        ", XF86AudioRaiseVolume,   exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume,   exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp,    exec, brightnessctl s 10%+"
        ", XF86MonBrightnessDown,  exec, brightnessctl s 10%-"
      ];

      bindl = [
        ", XF86AudioMute,  exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay,  exec, playerctl play-pause"
        ", XF86AudioNext,  exec, playerctl next"
        ", XF86AudioPrev,  exec, playerctl previous"
      ];

      gesture = [
        "4, horizontal, workspace"
        "3, swipe, move"
      ];
    };
  };

  # ── rzi-shell: deploy QML package → ~/.config/quickshell/rzi/ ────────────
  # Build: nix build .#rzi-shell
  # Launch: quickshell -p rzi  (configured in exec-once above)

  xdg.configFile."quickshell/rzi" = {
    source   = pkgs.callPackage ../../pkgs/rzi-shell {};
    recursive = true;   # symlink files individually so HM can merge the dir
  };
}
