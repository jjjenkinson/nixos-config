{ pkgs, lib, ... }:
{
  imports = [
    ./fonts.nix
    ./input-method.nix # 输入法
    ./plasma.nix
  ];

}
