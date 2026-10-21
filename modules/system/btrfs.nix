# btrfs 策略:定期 scrub、fstrim、自动快照。
# 这些与“哪块盘、哪个子卷”无关,所以放在共享模块里。
# mkIf 判断:只有当根文件系统是 btrfs 时才生效,别的机器 import 了也不会出错。
#
# 注意:snapper 要求 SUBVOLUME 下有名为 .snapshots 的子卷。
# /.snapshots 由 hardware-configuration.nix 作为 @snapshots 挂载点提供;
# /home/.snapshots 则依赖主机侧(hosts/*/disks.nix)创建,
# 本文件只负责“策略”,不负责造子卷。
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

    services.snapper.configs = {
      # 系统快照。/.snapshots 是 @snapshots 子卷(hardware-configuration.nix 里挂的)。
      root = {
        SUBVOLUME = "/";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 0;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 4;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };

      # 家目录快照:/home 丢了/改坏了,系统回滚救不回来。
      # 快照是 btrfs 的写时复制,只占“改动量”,不会把整个 home 复制一份。
      # 前提是 /home/.snapshots 这个子卷已存在,由对应主机的 disks.nix 保证。
      home = {
        SUBVOLUME = "/home";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 0;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 4;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };
  };
}
