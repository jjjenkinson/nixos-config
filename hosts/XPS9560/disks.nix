# 本机挂载策略。
# 身份(device / fsType / subvol)由 hosts/XPS9560/hardware-configuration.nix 提供,本文件只追加参数。
# ⚠️ 这里不要写 subvol= / device,否则 options 会拼接出两份。
{ lib, ... }:

let
  # btrfs 挂载参数(与机器无关的策略)
  btrfsTuning = [
    "noatime" # 不记录访问时间(SSD 少写一点)
    "compress=zstd" # 透明压缩
  ];

  # 需要套用上面参数的挂载点(必须已在 hardware-configuration.nix 中定义)
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
  # 最终 = 生成文件的 [ "subvol=@" ] ++ btrfsTuning   ← 不重复、不覆盖
  fileSystems = lib.genAttrs tunedMounts (_: {
    options = btrfsTuning;
  });

}
