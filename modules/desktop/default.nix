# 桌面层入口:字体、输入法、登录管理器,以及各个桌面环境。
{ lib, ... }:

{
  # 哪台机器要 KDE Plasma。默认开;纯 Niri 的机器在 hosts/*/default.nix 里设为 false。
  options.my.desktop.plasma.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "是否启用 KDE Plasma 6";
  };

  imports = [
    ./fonts.nix
    ./input-method.nix # fcitx5 + Rime 雾凇拼音
    ./plasma.nix # Plasma 6(受 my.desktop.plasma.enable 控制)
    ./niri.nix # Niri(与 Plasma 在登录界面并列可选)
  ];

  # 登录管理器与桌面环境无关,Plasma / Niri 共用。
  # SDDM 要求 services.xserver.enable 或 wayland.enable 至少一个为真,
  # 这里用 Wayland greeter(默认 weston),纯 Niri 机器就不必启用 Xorg。
  # 注:本文件顶部有 options / imports,其余配置必须写在显式 config 下。
  config.services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
}
