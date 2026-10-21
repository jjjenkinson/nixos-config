# 第二台主机的磁盘相关设置(占位模板)。
#
# 这里刻意不写挂载参数:具体挂载点和子卷由 hardware-configuration.nix 决定,
# 需要 noatime/压缩时再按实际挂载点添加(可参考 hosts/XPS9560/disks.nix)。
#
# 唯一要处理的是 snapper 的前提:modules/system/btrfs.nix 给 /home 配了时间线快照,
# 而 snapper 要求 /home/.snapshots 是一个「子卷」。NixOS 没有声明式创建子卷的手段,
# 所以用下面这个幂等 oneshot 补(与 XPS9560/disks.nix 里的做法相同)。
{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf ((config.fileSystems."/".fsType or "") == "btrfs") {
    systemd.services.create-home-snapshots-subvolume = {
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
}
