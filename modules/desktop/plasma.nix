# Plasma 6。是否启用由 my.desktop.plasma.enable 控制。
#
# 默认值来自 flake.nix 主机表的 plasma 字段(经 specialArgs 注入)。
# 为什么不在这里写死 false、再让 hosts/<机名>/default.nix 覆盖:
# home 侧要用同一个值决定文件管理器/图片查看器及其依赖包,
# 只能让两边读同一份数据;而让 home 去读 nixosConfigurations 会
# 把 NixOS 求值拖进 `nh home switch`。所以开关上移到主机表,
# 系统和 home 各读一次,互不求值。
{
  config,
  lib,
  plasma,
  ...
}:

{
  options.my.desktop.plasma.enable = lib.mkOption {
    type = lib.types.bool;
    default = plasma;
    description = "是否启用 KDE Plasma 6(默认取 flake 主机表的 plasma 字段)";
  };

  config = lib.mkIf config.my.desktop.plasma.enable {
    services.xserver.enable = true; # Plasma 的 X11 部分与视频驱动仍需要 X
    services.desktopManager.plasma6.enable = true;
  };
}
