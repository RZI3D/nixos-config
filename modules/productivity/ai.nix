{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs
  ];
}
