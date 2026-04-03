{ pkgs, ... }:
{
  #TODO
  home.packages = with pkgs; [
    osu-lazer-bin
    javaPackages.compiler.temurin-bin.jdk-25 # Minecraft
  ];
}
