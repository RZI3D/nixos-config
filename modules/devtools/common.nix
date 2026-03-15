{ pkgs, lib, ... }:

{
  # 1. System Packages (The stuff you wanted in every flake)
  home.packages = with pkgs; [
    gh
    helix
    htop
    nil # Nix Language Server
    nixfmt # Official Nix Formatter
    qt6.qtdeclarative
  ];

  # Git Configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "rzi3d";
        email = "zackiesattaur@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  # Helix Text Editor
  programs.helix = {
    enable = true;
    settings = {
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt;
      }
    ];
  };

  # 2. VSCode Configuration
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = pkgs.nix4vscode.forVscode [
        # Bierner's Markdown Suite
        "bierner.color-info"
        "bierner.markdown-checkbox"
        "bierner.markdown-emoji"
        "bierner.markdown-footnotes"
        "bierner.markdown-mermaid"

        # Appearance & UI
        "catppuccin.catppuccin-vsc"

        # Languages & Tools
        "charliermarsh.ruff"
        "codezombiech.gitignore"
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
        "kilocode.kilo-code"
        "ms-azuretools.vscode-containers"
        "ms-vscode-remote.remote-containers"
        "ms-vscode.remote-explorer"
        "ms-vscode.remote-repositories"
        "ms-vscode.remote-server"
        "ms-vscode.vscode-github-issue-notebooks"
        "ms-vsliveshare.vsliveshare"

        # QT (Yessirrr)

        "TheQtCompany.qt-core" # required base for all others
        "TheQtCompany.qt-qml" # QML language support
        "TheQtCompany.qt-cpp" # Qt C++ support
        "TheQtCompany.qt-ui" # .ui file designer

        "jnoortheen.nix-ide" # Nix Syntax Highlighting

        "esbenp.prettier-vscode" # Formatting
      ];

      userSettings = {
        "workbench.colorTheme" = "Catppuccin Mocha";
        "editor.formatOnSave" = true;
        "window.titleBarStyle" = "custom";
        "password-store" = "kwallet6";
      };
    };

    argvSettings = {
      "enable-crash-reporter" = false;
      "password-store" = "kwallet6";
    };

  };
}
