{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord-ptb
    ayugram-desktop
    whatsapp-electron
    parsec-bin
  ];
}
