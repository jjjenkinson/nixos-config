# ⚠️ 占位文件,不要手改。
#
# 真正的硬件信息(磁盘 / 内核模块 / swap)必须在目标机器上生成:
#
#   sudo nixos-generate-config --dir hosts/HHHH
#
# 或者从已装好的系统拷一份 /etc/nixos/hardware-configuration.nix 过来。
#
# 下面的 fileSystems 只是「假挂载点」,让 flake 在没有真实硬件信息时也能
# 正常求值/构建(NixOS 在没有根分区时会在求值阶段就断言失败)。
# 它们指向的 label 不一定存在,首次安装前必须被 nixos-generate-config 的输出覆盖。
{ lib, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # ↓↓↓ 占位,安装时会被生成的文件整体替换 ↓↓↓
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS-ROOT";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXOS-BOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];
}
