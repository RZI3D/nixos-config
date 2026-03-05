{ pkgs, inputs, ... }:

let
  # This grabs the addon packages for your specific system (x86_64-linux)
  addons = inputs.firefox-addons.packages.${pkgs.system};
in
{
  programs.firefox = {
    enable = true;
    profiles.zackariyya = {
      isDefault = true;
      
      extensions = with addons; [
        ublock-origin
        bitwarden
        darkreader
        catppuccin-gh-flavors
        sponsorblock
        return-youtube-dislike
      ];

      settings = {
        "browser.formfill.enable" = false;          # Don't save addresses/phones
        "privacy.trackingprotection.enabled" = true;
        "signon.rememberSignons" = false;           # Use Bitwarden instead!
      };
    };
  };
}
