# 第二台主机的入口(占位模板)。
#
# ⚠️ 这里的 HHHH / XXXX 都是占位名,实际使用前要一起改:
#   1. 目录名 hosts/HHHH
#   2. 本文件里的 my.user.name
#   3. flake.nix 主机表里的 HHHH = { user = "XXXX"; }
#   4. 用户配置目录 home/XXXX
# 四处的名字必须互相对应,否则 flake 找不到模块。
#
# 这台机器的定位:单用户、只装 Niri、不装 KDE。共享配置全部来自 modules/,
# 本文件只放「和硬件相关」或「决定导入哪些模块组」的内容。
{
  hostName,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix # 占位存根;首次安装前用 nixos-generate-config 覆盖
    ./disks.nix # 只在根分区是 btrfs 时才生效(见文件内的 mkIf)

    ../../modules/system # 系统基础(网络、声音、启动、Nix 等)
    ../../modules/packages # 系统级软件包
    ../../modules/desktop # 桌面、字体、输入法(SDDM 也在这里)
    ../../modules/users # 用户账号
  ];

  # 由 flake.nix 的主机表传入,不在这里重复写死。
  networking.hostName = hostName;

  # 主用户;modules/users/default.nix 默认给它 wheel 组,所以是管理员。
  my.user.name = "XXXX"; # 占位用户名

  # 这台只要 Niri。SDDM 与桌面无关,仍在 modules/desktop/default.nix 里启用。
  my.desktop.plasma.enable = false;

  # 首次安装时的 NixOS 版本,决定部分兼容行为;装好后不要改。
  system.stateVersion = "26.05";

  # 固件 + CPU 微码(Wi-Fi 固件、Intel 微码都靠它)。
  hardware.enableRedistributableFirmware = true;

  # Wayland / Niri 必需。
  hardware.graphics.enable = true;

  # ↓↓↓ 下面这段是「纯 Intel 核显」的示例,按实际硬件改或整段删掉 ↓↓↓
  # Gen7(HD 4000)用老的 i965 驱动;Gen8 及以后改用 pkgs.intel-media-driver。
  hardware.graphics.extraPackages = [ pkgs.intel-vaapi-driver ];

  # fwupd 原本由 plasma6 模块顺带启用;这台没有 Plasma,需要显式打开。
  services.fwupd.enable = true;

  # 如果安装时用的是 Legacy/BIOS 而不是 UEFI,把共享的 systemd-boot 关掉改用 GRUB:
  #
  # boot.loader.systemd-boot.enable = lib.mkForce false;
  # boot.loader.grub = {
  #   enable = true;
  #   devices = [ "/dev/sda" ]; # 换成实际磁盘
  # };
}
