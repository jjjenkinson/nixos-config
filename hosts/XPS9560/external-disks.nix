# 系统之外的额外分区(NTFS 数据盘等)。
# 与 btrfs 布局无关,单独成文件,迁移/删除都只动这一处。
{ ... }:

{
  fileSystems."/mnt/data" = {
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

  # 不要用 systemd.tmpfiles 去建 /mnt/data:
  # systemd-tmpfiles-setup.service 是 After=local-fs.target,等它跑的时候
  # 分区已经挂上了,`d /mnt/data 0755 root root -` 实际是在对 NTFS 根目录
  # 做 chmod/chown——ntfs3 会忽略它们(权限由 uid/gid/umask 决定),
  # 而挂载点目录本身由 systemd 的 mount unit 自动创建,不需要额外声明。
}
