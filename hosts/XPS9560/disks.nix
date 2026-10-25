# 本机的磁盘配置:挂载参数 + 额外分区。
#
# 分工:
#   - device / fsType / subvol 这类「身份」由 hardware-configuration.nix 提供
#   - 本文件只追加 options(对象合并 = 拼接,不要重复写 subvol=/device)
#   - scrub / fstrim / 快照 / .snapshots 子卷属于通用策略,在 modules/system/btrfs.nix
#
# 换机器时:分区布局不同就改 tunedMounts;有没有额外数据盘就看下面第二段。
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
  # ── btrfs 挂载参数 ────────────────────────────────────────────────
  # options 是 listOf str,模块合并 = 拼接:
  # 最终 = hardware-configuration 里的 [ "subvol=@…" ] ++ btrfsTuning
  #
  # 注意:同一个 attrset 里不能写两次 `fileSystems =`,所以额外分区用 `//` 并进来。
  fileSystems =
    lib.genAttrs tunedMounts (_: {
      options = btrfsTuning;
    })
    // {
      # ── 额外的 NTFS 数据盘 ──────────────────────────────────────
      # 与 btrfs 布局无关,单独一段;没有这块盘就整段删掉。
      "/mnt/data" = {
        device = "/dev/disk/by-uuid/8A0AD3000AD2E869"; # lsblk -f 里的 UUID
        fsType = "ntfs3"; # 内核自带 NTFS 驱动(可读写)

        options = [
          "uid=1000" # `id -u jiro`
          "gid=100" # `id -g jiro`
          "umask=022"
          "nofail" # 盘不在时不阻塞开机
          "x-systemd.device-timeout=10s"
          "windows_names"
          "noatime"
        ];

        noCheck = true; # NTFS 没有 Linux 侧 fsck
      };
    };

  # 不要用 systemd.tmpfiles 去建 /mnt/data:
  # systemd-tmpfiles-setup.service 是 After=local-fs.target,等它跑的时候
  # 分区已经挂上了,`d /mnt/data 0755 root root -` 实际是在对 NTFS 根目录
  # 做 chmod/chown——ntfs3 会忽略它们(权限由 uid/gid/umask 决定),
  # 而挂载点目录本身由 systemd 的 mount unit 自动创建,不需要额外声明。
}
