# 第二台主机的入口(占位模板)。
#
# ⚠️ 这里的 HHHH / XXXX 都是占位名,实际使用前要一起改:
#   1. 目录名 hosts/HHHH
#   2. flake.nix 主机表里的 HHHH = { user = "XXXX"; }
#   3. 用户配置目录 home/XXXX
# 主机名和用户名都从 flake.nix 注入,不需要在本文件里再抄一遍。
#
# 这台机器的定位:单用户、只装 Niri、不装 KDE。共享配置全部来自 flake.nix
# 注入的 commonModules,本文件只放「和硬件相关」或「本机特有的覆盖」。
{
  hostName,
  userName,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix # 占位存根;首次安装前用 nixos-generate-config 覆盖
  ];

  # 两个名字都来自 flake.nix 的主机表。
  networking.hostName = hostName;
  my.user.name = userName; # modules/users 默认给它 wheel 组,所以是管理员

  # 这台只要 Niri。登录管理器与桌面无关,仍由 modules/desktop 启用。
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

  # 如果安装时用的是 Legacy/BIOS 而不是 UEFI,把共享的 systemd-boot 关掉改用 GRUB:
  #
  # boot.loader.systemd-boot.enable = lib.mkForce false;
  # boot.loader.grub = {
  #   enable = true;
  #   devices = [ "/dev/sda" ]; # 换成实际磁盘
  # };
  #
  # 文件管理器(Thunar)由用户侧安装,见 home/XXXX/default.nix ——
  # 「用哪个文件管理器」属于用户偏好,和硬件无关。
}
