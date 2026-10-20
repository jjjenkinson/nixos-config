{ ... }:

{
  imports = [
    ./fonts.nix
    ./input-method.nix # fcitx5 + Rime 雾凇拼音
    ./plasma.nix # Plasma 6 + SDDM
    ./niri.nix # Niri(与 Plasma 在登录界面并列可选)
  ];
}
