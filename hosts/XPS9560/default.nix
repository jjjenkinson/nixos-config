# 这台机器(XPS9560)的入口。
#
# 这里只写「和这台机器的硬件/外设绑定」的东西:
#   1. imports:本机专属的硬件文件
#   2. 主机名、用户名:由 flake.nix 的主机表注入,不在这里写死
#   3. 覆盖共享层的默认值(例如桌面环境开关)
#
# 所有主机共有的系统模块(system / packages / desktop / users)由 flake.nix
# 的 commonModules 统一注入,不需要在这里 import。
{ hostName, userName, ... }:

{
  imports = [
    ./hardware-configuration.nix # 安装器生成(磁盘、内核模块),不要手改
    ./disks.nix # 本机挂载参数 + 额外 NTFS 分区
    ./gpu.nix # 双显卡:核显 + NVIDIA(PRIME offload)
  ];

  # 两个名字都来自 flake.nix 的主机表,这里只是转交给选项系统。
  networking.hostName = hostName;
  my.user.name = userName;

  # 首次安装时的 NixOS 版本,决定部分默认行为的兼容方式;
  # 升级系统后也不要改。
  system.stateVersion = "26.05";

  # 本机额外想要的桌面会话:登录界面里会多一个 Mango。
  my.desktop.mango.enable = true;

  # 本机要用 Plasma。开关已上移到 flake.nix 主机表的 plasma 字段
  # (home 侧也要用同一个值),这里不再重复赋值,否则两处维护。
  # 要关掉:把 flake.nix 里 XPS9560 的 plasma 改成 false。
  # my.desktop.plasma.enable = true;
  # Niri 默认就是开的(my.desktop.niri.enable = true),不用写。
}
