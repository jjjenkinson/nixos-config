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
    ./disks.nix # 本机挂载参数
    ./external-disks.nix # 额外分区(NTFS)
    ./gpu.nix # 双显卡:核显 + NVIDIA(PRIME offload)
  ];

  # 两个名字都来自 flake.nix 的主机表,这里只是转交给选项系统。
  networking.hostName = hostName;
  my.user.name = userName;

  # 首次安装时的 NixOS 版本,决定部分默认行为的兼容方式;
  # 升级系统后也不要改。
  system.stateVersion = "26.05";
}
