# btrfs 策略:定期 scrub、fstrim、自动快照。
# 这些与“哪块盘、哪个子卷”无关,所以放在共享模块里。
# mkIf 判断:只有当根文件系统是 btrfs 时才生效,别的机器 import 了也不会出错。
{ config, lib, ... }:

{
  config = lib.mkIf ((config.fileSystems."/".fsType or "") == "btrfs") {
    # 定期校验数据/元数据校验和并自动修复
    services.btrfs.autoScrub.enable = true;

    # SSD 定期 TRIM(因为你没开 discard=async,就靠这个回收)
    services.fstrim = {
      enable = true;
      interval = "daily"; # systemd 时间格式,也可以写 "Mon,Thu"
    };

    # Snapper 时间线快照(对根子卷)
    services.snapper.configs.root = {
      SUBVOLUME = "/";
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = 0;
      TIMELINE_LIMIT_DAILY = 7;
      TIMELINE_LIMIT_WEEKLY = 4;
      TIMELINE_LIMIT_MONTHLY = 0;
      TIMELINE_LIMIT_YEARLY = 0;
    };
  };
}
