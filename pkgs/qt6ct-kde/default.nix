{ pkgs }:

pkgs.qt6ct.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [ ./qt6ct-kde.patch ];
})
