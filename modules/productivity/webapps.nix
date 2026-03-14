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
        url = "https://upload.wikimedia.org/wikipedia/commons/1/1d/Google_Gemini_icon_2025.svg";
        sha256 = "02cxml85qramfip0i7ram45r2krmrxwfs17swdyj5ynm65kdz8nd";
      };

    };

  };
}
