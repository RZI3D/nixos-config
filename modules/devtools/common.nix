{
  description = "RZI3D's dev tools flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Provides the massive marketplace library
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { nixpkgs, home-manager, vscode-extensions, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Helper to access the marketplace
      mkt = vscode-extensions.extensions.${system}.vscode-marketplace;
    in {
      homeConfigurations."zackariyyasattaur" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ({ pkgs, ... }: {
            home.username = "zackariyyasattaur";
            home.homeDirectory = "/home/zackariyyasattaur";
            home.stateVersion = "24.11";

            programs.vscode = {
              enable = true;
              package = pkgs.vscode;

              extensions = [
                # Bierner's Markdown Suite
                mkt.bierner.color-info
                mkt.bierner.markdown-checkbox
                mkt.bierner.markdown-emoji
                mkt.bierner.markdown-footnotes
                mkt.bierner.markdown-mermaid

                # Appearance & UI
                mkt.catppuccin.catppuccin-vsc
                mkt.t3dotgg.vsc-material-theme-but-i-wont-sue-you
                mkt.phu1237.vs-browser

                # Languages & Tools
                mkt.charliermarsh.ruff
                mkt.codezombiech.gitignore
                mkt.michelemelluso.gitignore
                mkt.dart-code.dart-code
                mkt.dart-code.flutter
                mkt.geequlim.godot-tools
                mkt.redhat.vscode-yaml
                mkt.swiftlang.swift-vscode
                mkt.llvm-vs-code-extensions.lldb-dap

                # Python Stack
                mkt.ms-python.python
                mkt.ms-python.debugpy
                mkt.ms-python.vscode-pylance
                mkt.ms-python.vscode-python-envs

                # Git & GitHub
                mkt.donjayamanne.githistory
                mkt.mhutchie.git-graph
                mkt.github.codespaces
                mkt.github.remotehub
                mkt.github.vscode-github-actions
                mkt.github.vscode-pull-request-github

                # AI & Remote
                mkt.google.gemini-cli-vscode-ide-companion
                mkt.google.geminicodeassist
                mkt.kilocode.kilo-code
                mkt.ms-azuretools.vscode-containers
                mkt.ms-vscode-remote.remote-containers
                mkt.ms-vscode.remote-explorer
                mkt.ms-vscode.remote-repositories
                mkt.ms-vscode.remote-server
                mkt.ms-vscode.vscode-github-issue-notebooks
                mkt.ms-vsliveshare.vsliveshare

                # Formatting
                mkt.esbenp.prettier-vscode
              ];

              userSettings = {
                "workbench.colorTheme" = "Catppuccin Mocha";
                "editor.formatOnSave" = true;
                "window.titleBarStyle" = "custom";
              };
            };
          })
        ];
      };
    };
    home.packages = with pkgs; [
        git
        gh
        htop
        nil # Nix Language Server
  ];
}
