{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    
    # This applies settings to ALL profiles
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = false; # gotta figure out what this does 
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      # Force installing extensions by ID
      ExtensionSettings = {
        "*".installation_mode = "allowed"; # Allow manual installs too if you want

        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };

        # Dark Reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    profiles.zackariyya = {
      isDefault = true;
      settings = {
        # may be useful later
      };
    };
  };
}
