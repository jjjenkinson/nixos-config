# 这台机器(XPS9560)独有的设置。
# 共享配置都在 modules/ 里;这里只放和硬件绑定、或决定导入哪些模块组的内容。
{ ... }:

{
  imports = [
    ./hardware-configuration.nix # 安装器生成(磁盘、内核模块),不要手改
    ./disks.nix # 挂载参数 + 本机子卷
    ./external-disks.nix # 额外分区(NTFS)
    ./gpu.nix # 双显卡:核显 + NVIDIA(PRIME offload)

    ../../modules/system # 系统基础
    ../../modules/packages # 系统级软件包
    ../../modules/desktop # 桌面、字体、输入法
    ../../modules/users/jiro.nix # 用户账号
  ];

  networking.hostName = "XPS9560";

  # 首次安装时的 NixOS 版本,决定部分默认行为的兼容方式;
  # 升级系统后也不要改。
  system.stateVersion = "26.05";
}
