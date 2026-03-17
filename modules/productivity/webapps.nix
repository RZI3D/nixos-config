{ lib, ... }:
{
  imports = [ ../../pkgs/firefox-webapps ];
  programs.firefox.webapps = {
    claude = {
      name = "Claude Web";
      url = "https://claude.ai";
      id = 10;
      theme = "dark";
      icon = builtins.fetchurl {
        url = "https://upload.wikimedia.org/wikipedia/commons/b/b0/Claude_AI_symbol.svg";
        sha256 = "1q6vlkqad07m7pk668q9jcdnx3pcigij87zp1hgwaqilq3lj6rly";
      };
    };

    notebooklm = {
      name = "NotebookLM";
      url = "https://notebooklm.google.com/";
      id = 11;
      theme = "dark";
      icon = builtins.fetchurl {
        url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/notebook-lm-dark.svg";
        sha256 = "1aap0i17scfxl2ycfybc6x6fa7glilw4k522nya8vzqza4fa4ll0";
      };
    };

    gemini = {
      name = "Google Gemini";
      url = "https://gemini.google.com/";
      id = 12;
      theme = "dark";
      icon = builtins.fetchurl {
        name = "gemini.png";
        url = "https://uxwing.com/wp-admin/admin-ajax.php?action=resize_image&size=32x32&file=google-gemini-icon.png&category_slug=brands-and-social-media";
        sha256 = "1ky8s6rn28f56132c3nr9x4vh1x4kmhwscch8m0ykrlhwvavg2ks";
      };
    };

    figma = {
      name = "Figma";
      url = "https://www.figma.com";
      id = 13;
      theme = "dark";
      icon = builtins.fetchurl {
        url = "https://upload.wikimedia.org/wikipedia/commons/3/33/Figma-logo.svg";
        sha256 = "11x72ik5mndqmnnmw8jph9bnalkr9z634ggnk82s2f72w8gb24wm";
      };

    };

  };
}
