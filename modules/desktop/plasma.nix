# Plasma 6。是否启用由 my.desktop.plasma.enable 控制(默认关)。
#
# 默认关的理由:这套配置的主力是 Niri / Mango 这类平铺合成器,
# Plasma 相当于「额外多装一整套 DE」,只应该在需要它的机器上显式打开
# (见 hosts/XPS9560/default.nix)。
{ config, lib, ... }:

{
  options.my.desktop.plasma.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "是否启用 KDE Plasma 6";
  };

  config = lib.mkIf config.my.desktop.plasma.enable {
    services.xserver.enable = true; # Plasma 的 X11 部分与视频驱动仍需要 X
    services.desktopManager.plasma6.enable = true;
  };
}
