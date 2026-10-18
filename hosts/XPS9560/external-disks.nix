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

  systemd.tmpfiles.rules = [ "d /mnt/data 0755 root root -" ];
}
