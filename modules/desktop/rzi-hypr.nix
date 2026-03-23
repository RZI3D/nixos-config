{
  inputs,
  pkgs,
  config,
  ...
}:

let
  colloid-catppuccin = pkgs.callPackage ../../pkgs/colloid-catppuccin { };
  themeName = "Colloid-Dark-Catppuccin";
in

{
  # ── Catppuccin global theme ─────────────────────────────────────────────────
  catppuccin.flavor = "mocha";
  catppuccin.accent = "mauve";
  catppuccin.enable = true;
  # ── Packages ─────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    quickshell
    (callPackage ../../pkgs/rzi-shell { })

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

    # Utility
    libnotify # notify-send (for testing notifications)
    kdePackages.breeze-icons
    kdePackages.qtstyleplugin-kvantum
    kdePackages.kservice
    kdePackages.qtsvg
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
      q = "qs -c ii";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;

      # The prompt layout from the repo
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

  catppuccin.kvantum = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "kvantum";
  };

  xdg.configFile."kdeglobals".text = ''
    [Icons]
    Theme=Papirus-Dark
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

  # gtk.iconTheme = {
  #   name = "Papirus-Dark";
  #   package = pkgs.papirus-icon-theme;
  # };

  gtk.gtk3.extraConfig = {
    gtk-fallback-icon-theme = "Adwaita";
  };

  gtk.gtk4.extraConfig = {
    gtk-fallback-icon-theme = "Adwaita";
  };
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
        "QT_QPA_PLATFORMTHEME,kde"
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
