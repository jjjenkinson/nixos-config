# 本机的磁盘挂载参数。
#
# 分工:
#   - device / fsType / subvol 这类「身份」由 hardware-configuration.nix 提供
#   - 本文件只追加 options(对象合并 = 拼接,不要重复写 subvol=/device)
#   - 「scrub / fstrim / 快照 / .snapshots 子卷」属于通用策略,
#     在 modules/system/btrfs.nix 里,与本机布局无关
{ lib, ... }:

let
  # btrfs 挂载参数(与机器无关的策略)
  btrfsTuning = [
    "noatime" # 不记录访问时间(SSD 少写一点)
    "compress=zstd" # 透明压缩
    # 不写 autodefrag:它面向机械盘/虚拟机镜像的随机小写,SSD 上只会写放大。
  ];

  # 需要套用上面参数的挂载点(必须已在 hardware-configuration.nix 中定义)
  # 这是本机特有的清单:换一台机器分区布局不同,就改这里。
  tunedMounts = [
    "/"
    "/home"
    "/nix"
    "/var/log"
    "/var/cache"
    "/.snapshots"
  ];
in
{
  # options 是 listOf str,模块合并 = 拼接:
  # 最终 = hardware-configuration 里的 [ "subvol=@…" ] ++ btrfsTuning
  fileSystems = lib.genAttrs tunedMounts (_: {
    options = btrfsTuning;
  });
}
