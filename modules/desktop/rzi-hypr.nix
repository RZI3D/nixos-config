{
  inputs,
  pkgs,
  config,
  ...
}:

let
  colloid-catppuccin = pkgs.callPackage ../../pkgs/colloid-catppuccin { };
  themeName = "Colloid-Dark-Catppuccin";
  qt6ct-kde = pkgs.kdePackages.qt6ct.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./../../pkgs/qt6ct-kde.patch ];
    name = "qt6ct-kde";
  });
in

{
  # ── Catppuccin global theme ─────────────────────────────────────────────────
  catppuccin.flavor = "mocha";
  catppuccin.accent = "mauve";

  # ── Packages ─────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.system}.quickshell
    (callPackage ../../pkgs/rzi-shell { })

    # Wallpaper
    swww
    papirus-icon-theme
    # Media / HW controls (used by quickshell widgets)
    playerctl
    brightnessctl
    wireplumber # wpctl for volume

    # Screenshot
    grimblast
    wl-clipboard

    # Utility
    libnotify # notify-send (for testing notifications)
    adwaita-icon-theme
    qt6Packages.qt6ct
    kdePackages.qtstyleplugin-kvantum
    kdePackages.kservice
  ];

  # ── Kitty terminal (Catppuccin via HM module) ────────────────────────────────
  catppuccin.kitty.enable = true;
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = "12.0";
      window_padding_width = 12;
      background_opacity = "0.92";
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

  catppuccin.kvantum = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  # catppuccin.qt5ct = {
  #   enable = true;
  #   flavor = "mocha";
  #   accent = "mauve";
  # };
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    color_scheme_path=/dev/null
    custom_palette=true
    icon_theme=Papirus-Dark
    standard_dialogs=default
    style=kvantum

    [ColorScheme]
    active_colors=#cdd6f4, #313244, #585b70, #45475a, #6c7086, #11111b, #cdd6f4, #cdd6f4, #cdd6f4, #1e1e2e, #181825, #11111b, #cba6f7, #1e1e2e, #cba6f7, #f38ba8, #a6e3a1, #f9e2af, #cdd6f4, #313244, #585b70
    disabled_colors=#6c7086, #313244, #45475a, #45475a, #6c7086, #11111b, #6c7086, #6c7086, #6c7086, #1e1e2e, #181825, #11111b, #cba6f7, #1e1e2e, #cba6f7, #f38ba8, #a6e3a1, #f9e2af, #6c7086, #313244, #45475a
    inactive_colors=#cdd6f4, #313244, #585b70, #45475a, #6c7086, #11111b, #cdd6f4, #cdd6f4, #cdd6f4, #1e1e2e, #181825, #11111b, #cba6f7, #1e1e2e, #cba6f7, #f38ba8, #a6e3a1, #f9e2af, #cdd6f4, #313244, #585b70

    #[Fonts]
    #fixed=@Variant(\0\0\0@\0\0\0\x12\0J\0\x65\0\x74\0\x42\0r\0\x61\0i\0n\0s\0M\0o\0n\0o@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
    #general=@Variant(\0\0\0@\0\0\0\x12\0J\0\x65\0\x74\0\x42\0r\0\x61\0i\0n\0s\0M\0o\0n\0o@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=0
    cursor_flash_time=1000
    dialog_buttons_have_icons=1
    double_click_interval=400
    gui_effects=@Invalid()
    keyboard_scheme=2
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=@Invalid()
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3

    [Troubleshooting]
    force_raster_widgets=1
    ignored_applications=@Invalid()
  '';
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile."kdeglobals".text = ''
    # [Colors:Window]
    # BackgroundNormal=30,30,46
    # BackgroundAlternate=24,24,37
    # ForegroundNormal=205,214,244
    # ForegroundInactive=166,173,200
    # DecorationFocus=203,166,247
    # DecorationHover=203,166,247

    # [Colors:View]
    # BackgroundNormal=24,24,37
    # BackgroundAlternate=30,30,46
    # ForegroundNormal=205,214,244
    # ForegroundInactive=166,173,200
    # DecorationFocus=203,166,247
    # DecorationHover=203,166,247

    # [Colors:Button]
    # BackgroundNormal=49,50,68
    # BackgroundAlternate=69,71,90
    # ForegroundNormal=205,214,244
    # ForegroundInactive=166,173,200
    # DecorationFocus=203,166,247
    # DecorationHover=203,166,247

    # [Colors:Selection]
    # BackgroundNormal=203,166,247
    # ForegroundNormal=30,30,46

    # [Colors:Tooltip]
    # BackgroundNormal=24,24,37
    # ForegroundNormal=205,214,244

    [General]
    ColorScheme=CatppuccinMochaMauve

    [Icons]
    Theme=Papirus-Dark
  '';
  xdg.dataFile."color-schemes/CatppuccinMochaMauve.colors".text = ''
    [ColorScheme]
    Name=Catppuccin Mocha Mauve

    [Colors:Window]
    BackgroundNormal=30,30,46
    BackgroundAlternate=24,24,37
    ForegroundNormal=205,214,244
    ForegroundInactive=166,173,200
    DecorationFocus=203,166,247
    DecorationHover=203,166,247

    [Colors:View]
    BackgroundNormal=24,24,37
    BackgroundAlternate=30,30,46
    ForegroundNormal=205,214,244
    ForegroundInactive=166,173,200
    DecorationFocus=203,166,247
    DecorationHover=203,166,247

    [Colors:Button]
    BackgroundNormal=49,50,68
    BackgroundAlternate=69,71,90
    ForegroundNormal=205,214,244
    ForegroundInactive=166,173,200
    DecorationFocus=203,166,247
    DecorationHover=203,166,247

    [Colors:Selection]
    BackgroundNormal=203,166,247
    ForegroundNormal=30,30,46

    [Colors:Tooltip]
    BackgroundNormal=24,24,37
    ForegroundNormal=205,214,244

    [Colors:Complementary]
    BackgroundNormal=24,24,37
    ForegroundNormal=205,214,244

    [KDE]
    contrast=4
  '';

  # GTK
  gtk = {
    enable = true;
    theme = {
      name = themeName;
      package = colloid-catppuccin;
    };
  };

  xdg.configFile = {
    "gtk-4.0/gtk.css".source = "${colloid-catppuccin}/share/themes/${themeName}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source =
      "${colloid-catppuccin}/share/themes/${themeName}/gtk-4.0/gtk-dark.css";
    "gtk-4.0/assets" = {
      recursive = true;
      source = "${colloid-catppuccin}/share/themes/${themeName}/gtk-4.0/assets";
    };
  };

  dconf.enable = true;

  gtk.iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };

  gtk.gtk3.extraConfig = {
    gtk-fallback-icon-theme = "Adwaita";
  };
  gtk.gtk4.extraConfig = {
    gtk-fallback-icon-theme = "Adwaita";
  };

  catppuccin.firefox.enable = true;

  # ── Cursor ───────────────────────────────────────────────────────────────────
  home.pointerCursor = {
    name = "catppuccin-mocha-mauve-cursors";
    package = pkgs.catppuccin-cursors.mochaMauve;
    size = 24;
    gtk.enable = true;
  };

  # ── Hyprland ─────────────────────────────────────────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      env = [
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "QT_STYLE_OVERRIDE,kvantum"
      ];
      monitor = ",preferred,auto,1";

      exec-once = [
        "swww-daemon"
        "quickshell -c rzi"
        "kwalletd6"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = "rgb(cba6f7) rgb(89b4fa) 45deg"; # mauve → blue
        "col.inactive_border" = "rgb(313244)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 12;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
          popups = true;
        };
        shadow = {
          enabled = true;
          range = 20;
          color = "rgba(1e1e2eCC)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOut, 0.16, 1, 0.3, 1"
        ];
        animation = [
          "windows,    1, 5, easeOut, popin 80%"
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
        touchpad.tap-to-click = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        animate_manual_resizes = true;
      };

      # Allow quickshell layers to blur properly
      #      layerrule = [
      #        "match:namespace quickshell, blur on"
      #        "match:namespace quickshell, ignore_alpha 0.5"
      #      ];

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
        "$mod, P, exec, hyprpicker -a" # color picker
        "$mod, S, exec, grimblast copy area" # screenshot
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
      ]
      ++ (builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = toString (i + 1);
          in
          [
            "$mod, ${ws}, workspace, ${ws}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
          ]
        ) 9
      ));

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
    source = pkgs.callPackage ../../pkgs/rzi-shell { };
    recursive = true; # symlink files individually so HM can merge the dir
  };
}
