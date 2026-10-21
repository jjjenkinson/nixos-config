# Plasma 6。是否启用由 my.desktop.plasma.enable 控制(默认开)。
{ config, lib, ... }:

{
  config = lib.mkIf config.my.desktop.plasma.enable {
    services.xserver.enable = true; # Plasma 的 X11 部分与视频驱动仍需要 X
    services.desktopManager.plasma6.enable = true;
  };
}
