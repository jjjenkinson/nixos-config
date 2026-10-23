# btrfs 策略:定期 scrub、fstrim、自动快照,以及 snapper 需要的 .snapshots 子卷。
#
# 放共享层的原因:这些是「策略」,和具体哪块盘、哪个子卷无关。
# 每台机器要不要生效,由下面的 mkIf 按实际挂载点自动判断:
#   - 根不是 btrfs          → 整个文件不生效
#   - 没有独立挂载的 /home  → 只跳过 home 快照,根快照照常
# 所以新机器 import 了也不会炸,移植时不用改这里。
{
  config,
  lib,
  pkgs,
  ...
}:

let
  rootFs = config.fileSystems."/".fsType or "";

  # snapper 要求 SUBVOLUME 下有名为 .snapshots 的「子卷」(不是普通目录)。
  # 只有文件系统里真的挂了 /.snapshots 才认为磁盘布局支持根快照。
  hasRootSnapshots = config.fileSystems ? "/.snapshots";

  # 同理,/home 必须单独挂载才能给它拍快照。
  hasHome = config.fileSystems ? "/home";
in
{
  config = lib.mkIf (rootFs == "btrfs") {
    # 定期校验数据/元数据校验和并自动修复
    services.btrfs.autoScrub.enable = true;

    # SSD 定期 TRIM(没有开 discard=async 时靠它回收空间)
    services.fstrim = {
      enable = true;
      interval = "daily"; # systemd 时间格式,也可以写 "Mon,Thu"
    };

    # ── 快照策略 ──────────────────────────────────────────────────────
    # 根快照:系统坏了可以整个回滚(需要 /.snapshots 子卷,见上面的判断)。
    # home 快照:/home 丢了/改坏了,系统回滚救不回来。
    # 快照是 btrfs 的写时复制,只占「改动量」,不会把整个 home 复制一份。
    services.snapper.configs =
      lib.optionalAttrs hasRootSnapshots {
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
      }
      // lib.optionalAttrs hasHome {
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

    # ── /home/.snapshots 子卷 ─────────────────────────────────────────
    # NixOS 没有声明式创建子卷的手段:
    #   - fileSystems."/home/.snapshots" 只是挂载,子卷不存在会直接挂载失败
    #   - systemd.tmpfiles 只能建普通目录
    #   - services.snapper 只写配置,不建子卷
    # 所以用一个 oneshot 补一次,幂等:
    #   已是子卷 → 跳过;不存在 → 创建;是空目录 → rmdir 后创建;
    #   是非空目录 → 故意失败,避免误删数据。
    # 必须早于 snapper-timeline,否则第一次快照会报 ".snapshots is not a subvolume"。
    systemd.services = lib.optionalAttrs hasHome {
      create-home-snapshots-subvolume = {
        description = "Create /home/.snapshots btrfs subvolume for snapper";
        wantedBy = [ "multi-user.target" ];
        after = [ "local-fs.target" ];
        before = [
          "snapper-timeline.service"
          "snapper-cleanup.service"
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          SNAP=/home/.snapshots

          if ! ${pkgs.btrfs-progs}/bin/btrfs subvolume show "$SNAP" >/dev/null 2>&1; then
            if [ -d "$SNAP" ]; then
              ${pkgs.coreutils}/bin/rmdir "$SNAP"
            fi
            ${pkgs.btrfs-progs}/bin/btrfs subvolume create "$SNAP"
          fi
        '';
      };
    };
  };
}
