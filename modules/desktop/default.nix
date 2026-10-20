{ pkgs, lib, ... }:
{
  imports = [
    ./fonts.nix
    ./input-method.nix # 输入法
    ./plasma.nix
    ./niri.nix # Niri(平铺合成器),与 Plasma 在登录界面并列可选
  ];

}
