{ pkgs, ... }:

{
  # 1. System Packages (The stuff you wanted in every flake)
  home.packages = with pkgs; [
    git
    gh
    htop
    nil # Nix Language Server
  ];

  # 2. VSCode Configuration
  programs.vscode = {
    enable = true;

  extensions = pkgs.nix4vscode.forVscode [
      # Bierner's Markdown Suite
      "bierner.color-info"
      "bierner.markdown-checkbox"
      "bierner.markdown-emoji"
      "bierner.markdown-footnotes"
      "bierner.markdown-mermaid"

      # Appearance & UI
      "catppuccin.catppuccin-vsc"
      "t3dotgg.vsc-material-theme-but-i-wont-sue-you"
      "phu1237.vs-browser"

      # Languages & Tools
      "charliermarsh.ruff"
      "codezombiech.gitignore"
      "michelemelluso.gitignore"
      "dart-code.dart-code"
      "dart-code.flutter"
      "geequlim.godot-tools"
      "redhat.vscode-yaml"
      "swiftlang.swift-vscode"
      "llvm-vs-code-extensions.lldb-dap"

      # Python Stack
      "ms-python.python"
      "ms-python.debugpy"
      "ms-python.vscode-pylance"
      "ms-python.vscode-python-envs"

      # Git & GitHub
      "donjayamanne.githistory"
      "mhutchie.git-graph"
      "github.codespaces"
      "github.remotehub"
      "github.vscode-github-actions"
      "github.vscode-pull-request-github"

      # AI & Remote
      "google.gemini-cli-vscode-ide-companion"
      "google.geminicodeassist"
      "kilocode.kilo-code"
      "ms-azuretools.vscode-containers"
      "ms-vscode-remote.remote-containers"
      "ms-vscode.remote-explorer"
      "ms-vscode.remote-repositories"
      "ms-vscode.remote-server"
      "ms-vscode.vscode-github-issue-notebooks"
      "ms-vsliveshare.vsliveshare"

      # Formatting
      "esbenp.prettier-vscode"
    ];

    userSettings = {
      "workbench.colorTheme" = "Catppuccin Mocha";
      "editor.formatOnSave" = true;
      "window.titleBarStyle" = "custom";
    };
  };
}
