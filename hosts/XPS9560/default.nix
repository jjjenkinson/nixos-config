# 这台机器(XPS9560)独有的设置。
# 共享配置都在 modules/ 里;这里只写“和这台机器绑定”的东西:
# 硬件、磁盘、主机名,以及要启用哪些模块组。
{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix # 安装时自动生成(磁盘、内核模块),一般不要手改
    ./disks.nix # 这台机器的挂载参数
    ./external-disks.nix # 额外分区(NTFS)

    ../../modules/system # 系统基础:nix、引导、btrfs 策略、音频、网络、语言
    ../../modules/packages # 系统级软件包
    ../../modules/desktop # 桌面:Plasma、字体、输入法
    ../../modules/users/jiro.nix # 用户账号
  ];

  networking.hostName = "XPS9560";

  # stateVersion = “首次安装时的 NixOS 版本”。
  # 它决定部分默认行为的兼容方式;升级系统后也不要改。
  system.stateVersion = "26.05";
}
