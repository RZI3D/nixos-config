{
  inputs,
  pkgs,
  config,
  ...
}:

let
  colloid-catppuccin = pkgs.callPackage ../../pkgs/colloid-catppuccin { };
  themeName = "Colloid-Dark-Catppuccin";
  kdeMochaLookAndFeel = pkgs.fetchzip {
    url = "https://github.com/catppuccin/kde/releases/download/v0.2.6/Mocha-color-schemes.tar.gz";
    sha256 = "sha256-I5WIXubfArLsrELLdWvuN66VsQ3dr7PzxYBlzz9qBBI="; # If switch fails, use the hash Nix provides
  };
in

{
  # ── Catppuccin global theme ─────────────────────────────────────────────────
  catppuccin.flavor = "mocha";
  catppuccin.accent = "sapphire";
  catppuccin.enable = true;
  # ── Packages ─────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    inputs.quickshell.packages.${stdenv.hostPlatform.system}.default
    # (callPackage ../../pkgs/rzi-shell { }) #TODO: When shell becomes stable, make into a nix flake on github and add it here

    # Wallpaper
    swww
    # papirus-icon-theme # Handled by catppuccin, it patches it with your accent
    fish
    starship
    eza
    # Media / HW controls (used by quickshell widgets)
    playerctl
    brightnessctl
    wireplumber # wpctl for volume

    # Screenshot
    grimblast
    wl-clipboard
    cava
    # Utility
    libnotify # notify-send (for testing notifications)
    kdePackages.breeze-icons
    #kdePackages.qtstyleplugin-kvantum
    kdePackages.kservice
    kdePackages.qtsvg
    kdePackages.kservice
    libsForQt5.qt5ct
    kdePackages.kio-extras
    qt6Packages.qt6ct # has unfixed issues with kde, so i needed to patch it (see flake.nix)
    desktop-file-utils
    xdg-utils
  ];

  # ── Kitty & terminal (Catppuccin via HM module) ────────────────────────────────
  catppuccin.kitty.enable = true;
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = "11.0";
      cursor_trail = 1; # ms delay before trail triggers (0 = always, higher = only on big jumps)
      shell = "fish";
      cursor_shape = "beam";
      window_padding_width = 12;
      background_opacity = "0.92";
      confirm_os_window_close = 0;
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting "" 

      # These sequences are vital for the end-4 theme colors 
      if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
          cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt 
      end
    '';

    shellAliases = {
      clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
      ls = "eza --icons";
      pamcan = "pacman";
      q = "qs -c rzi kill; qs -c rzi";
      qd = "qs -c rzi kill; qs -c rzi -d";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;

      format = ''
        $time$cmd_duration 󰜥 $directory $git_branch
        $character'';

      character = {
        success_symbol = "[   ](bold fg:blue)";
        error_symbol = "[   ](bold fg:red)";
      };

      directory = {
        home_symbol = "  ";
        read_only = "  ";
        style = "bg:green fg:black";
        truncation_length = 6;
        format = "[](bold fg:green)[󰉋 $path]($style)[](bold fg:green)"; # The Pill
        substitutions = {
          "Desktop" = "  ";
          "Documents" = "  ";
          "Downloads" = "  ";
          "Music" = " 󰎈 ";
          "Pictures" = "  ";
          "Videos" = "  ";
          "GitHub" = " 󰊤 ";
        };
      };

      git_branch = {
        style = "bg: cyan";
        symbol = "󰘬";
        format = "󰜥 [](bold fg:cyan)[$symbol $branch(:$remote_branch)](fg:black bg:cyan)[ ](bold fg:cyan)";
      };

      cmd_duration = {
        min_time = 0;
        format = "[](bold fg:yellow)[󰪢 $duration](bold bg:yellow fg:black)[](bold fg:yellow)";
      };

      time = {
        disabled = false; # Changed from true
        format = "[](bold fg:purple)[ $time](bg:purple fg:black)[](bold fg:purple) ";
        time_format = "%l:%M %p";
      };

      # Disable modules not used in this specific look
      package.disabled = true;
      memory_usage.disabled = true;
    };
  };

  # -- Helix --
  catppuccin.helix.enable = true;

  # ── GTK & QT theming ──────────────────────────────────────────────────────────────

  catppuccin.qt5ct.enable = false;
  catppuccin.kvantum.enable = false;
  qt = {
    style.package = with pkgs; [
      darkly-qt5
      darkly
    ];
    enable = true;
    platformTheme.name = "qt6ct";
  };

  xdg.configFile."qt5ct/colors/catppuccin-mocha-sapphire.conf".text = ''
    [ColorScheme]
    active_colors=  #ffcdd6f4,     #ff45475a, #ff585b70, #ff313244, #ff11111b, #ff181825, #ffcdd6f4,     #ffcdd6f4,  #ffcdd6f4,     #ff1e1e2e, #ff181825, #ff11111b, #ff74c7ec, #ff11111b,    #ff89b4fa,     #ffb4befe,   #ff181825, #ffffffff, #ff1e1e2e, #ffcdd6f4, #806c7086, #ff74c7ec
    inactive_colors=#ff7f849c, #ff1e1e2e,     #ff45475a, #ff313244, #ff11111b, #ff181825, #ff7f849c, #ffcdd6f4,  #ff7f849c, #ff1e1e2e, #ff181825, #ff11111b, #ff313244,              #ff7f849c, #ff7f849c, #ff7f849c,   #ff181825, #ffffffff, #ff1e1e2e, #ffcdd6f4, #806c7086, #ff313244
    disabled_colors=#ff6c7086, #ff313244, #ff45475a, #ff313244, #ff11111b, #ff181825, #ff6c7086, #ffcdd6f4,  #ff6c7086, #ff1e1e2e, #ff181825, #ff11111b, #ff181825,                #ff6c7086, #ffa9bcdb,   #ffc7cceb, #ff181825, #ffffffff, #ff1e1e2e, #ffcdd6f4, #806c7086, #ff181825
  '';

  xdg.configFile."qt6ct/colors/catppuccin-mocha-sapphire.conf".text = ''
    [ColorScheme]
    active_colors=  #ffcdd6f4,     #ff45475a, #ff585b70, #ff313244, #ff11111b, #ff181825, #ffcdd6f4,     #ffcdd6f4,  #ffcdd6f4,     #ff1e1e2e, #ff181825, #ff11111b, #ff74c7ec, #ff11111b,    #ff89b4fa,     #ffb4befe,   #ff181825, #ffffffff, #ff1e1e2e, #ffcdd6f4, #806c7086, #ff74c7ec
    inactive_colors=#ff7f849c, #ff1e1e2e,     #ff45475a, #ff313244, #ff11111b, #ff181825, #ff7f849c, #ffcdd6f4,  #ff7f849c, #ff1e1e2e, #ff181825, #ff11111b, #ff313244,              #ff7f849c, #ff7f849c, #ff7f849c,   #ff181825, #ffffffff, #ff1e1e2e, #ffcdd6f4, #806c7086, #ff313244
    disabled_colors=#ff6c7086, #ff313244, #ff45475a, #ff313244, #ff11111b, #ff181825, #ff6c7086, #ffcdd6f4,  #ff6c7086, #ff1e1e2e, #ff181825, #ff11111b, #ff181825,                #ff6c7086, #ffa9bcdb,   #ffc7cceb, #ff181825, #ffffffff, #ff1e1e2e, #ffcdd6f4, #806c7086, #ff181825
  '';

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    color_scheme_path=${config.xdg.configHome}/qt5ct/colors/catppuccin-mocha-sapphire.conf
    custom_palette=true
    icon_theme=Papirus-Dark
    standard_dialogs=default
    style=Darkly
    [Fonts]
    general=JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0
    fixed=JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0
  '';

  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    color_scheme_path=${config.xdg.configHome}/qt6ct/colors/catppuccin-mocha-sapphire.conf
    custom_palette=true
    icon_theme=Papirus-Dark
    standard_dialogs=default
    style=Darkly
    [Fonts]
    general=JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0
    fixed=JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0
  '';

  xdg.configFile."kdeglobals".text = ''
    [General]
    TerminalApplication=kitty
    TerminalService=kitty.desktop

    [ColorEffects:Disabled]
    ChangeSelectionColor=
    Color=30, 30, 46
    ColorAmount=0.30000000000000004
    ColorEffect=2
    ContrastAmount=0.1
    ContrastEffect=0
    Enable=
    IntensityAmount=-1
    IntensityEffect=0

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=30, 30, 46
    ColorAmount=0.5
    ColorEffect=3
    ContrastAmount=0
    ContrastEffect=0
    Enable=true
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate=116,199,236
    BackgroundNormal=49, 50, 68
    DecorationFocus=116,199,236
    DecorationHover=49, 50, 68
    ForegroundActive=250, 179, 135
    ForegroundInactive=166, 173, 200
    ForegroundLink=116,199,236
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=205, 214, 244
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [Colors:Complementary]
    BackgroundAlternate=17, 17, 27
    BackgroundNormal=24, 24, 37
    DecorationFocus=116,199,236
    DecorationHover=49, 50, 68
    ForegroundActive=250, 179, 135
    ForegroundInactive=166, 173, 200
    ForegroundLink=116,199,236
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=205, 214, 244
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [Colors:Header]
    BackgroundAlternate=17, 17, 27
    BackgroundNormal=24, 24, 37
    DecorationFocus=116,199,236
    DecorationHover=49, 50, 68
    ForegroundActive=250, 179, 135
    ForegroundInactive=166, 173, 200
    ForegroundLink=116,199,236
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=205, 214, 244
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [Colors:Selection]
    BackgroundAlternate=116,199,236
    BackgroundNormal=116,199,236
    DecorationFocus=116,199,236
    DecorationHover=49, 50, 68
    ForegroundActive=250, 179, 135
    ForegroundInactive=24, 24, 37
    ForegroundLink=116,199,236
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=17, 17, 27
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [Colors:Tooltip]
    BackgroundAlternate=27,25,35
    BackgroundNormal=30, 30, 46
    DecorationFocus=116,199,236
    DecorationHover=49, 50, 68
    ForegroundActive=250, 179, 135
    ForegroundInactive=166, 173, 200
    ForegroundLink=116,199,236
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=205, 214, 244
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [Colors:View]
    BackgroundAlternate=24, 24, 37
    BackgroundNormal=30, 30, 46
    DecorationFocus=116,199,236
    DecorationHover=49, 50, 68
    ForegroundActive=250, 179, 135
    ForegroundInactive=166, 173, 200
    ForegroundLink=116,199,236
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=205, 214, 244
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [Colors:Window]
    BackgroundAlternate=17, 17, 27
    BackgroundNormal=24, 24, 37
    DecorationFocus=116,199,236
    DecorationHover=49, 50, 68
    ForegroundActive=250, 179, 135
    ForegroundInactive=166, 173, 200
    ForegroundLink=116,199,236
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=205, 214, 244
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [General]
    ColorScheme=CatppuccinMochaSapphire

    [KDE]
    contrast=4
    frameContrast=0.2

    [WM]
    activeBackground=30,30,46
    activeBlend=205,214,244
    activeForeground=205,214,244
    inactiveBackground=17,17,27
    inactiveBlend=166,173,200
    inactiveForeground=166,173,200


    [Icons]
    Theme=Papirus-Dark
  '';

  xdg.dataFile."color-schemes/CatppuccinMochaSapphire.colors".source =
    "${kdeMochaLookAndFeel}/CatppuccinMochaSapphire.colors";

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Colloid-Dark-Catppuccin";
    };
  };

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

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    videos = "${config.home.homeDirectory}/Videos";
    templates = "${config.home.homeDirectory}/Templates";
    publicShare = "${config.home.homeDirectory}/Public";
  };

  dconf.enable = true;

  # gtk.iconTheme = {
  #   name = "Papirus-Dark";
  #   package = pkgs.papirus-icon-theme;
  # };

  gtk.gtk4.theme = config.gtk.theme;
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
      ];
      monitor = ",preferred,auto,1";

      exec-once = [
        "swww-daemon"
        "quickshell -c rzi"
        "kwalletd6"
        "kbuildsycoca6"
        "update-desktop-database ~/.local/share/applications/"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = "rgb(209fb5) rgb(1e66f5) 45deg"; # mauve → blue
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
      layerrule = [
        # "match:namespace quickshell, blur on"
        # "match:namespace quickshell, ignore_alpha 0.5"
        "match:namespace quickshell:overlay, blur on"
        "match:namespace quickshell:overlay, ignore_alpha 0.1"
        "match:namespace quickshell:background_dim, blur on"
        "match:namespace quickshell:background_dim, ignore_alpha 0.1"
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
        "$mod, E, exec, dolphin"
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
}
