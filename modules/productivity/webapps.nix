{ ... }:
{
  imports = [ ../../pkgs/firefox-webapps ];
  programs.firefox.webapps = {
    claude = {
      name = "Claude Web";
      url = "https://claude.ai";
      id  = 10;
      theme = "dark";
    };

    notebooklm = {
      name =  "NotebookLM";
      url = "https://notebooklm.google.com/";
      id  = 11;
      theme = "dark";
    };

    gemini = {
      name =  "Google Gemini";
      url = "https://gemini.google.com/";
      id  = 12;
      theme = "dark";
    };

  };
}
