{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.kwalletmanager
    anytype
  ];
}
