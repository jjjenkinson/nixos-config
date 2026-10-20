# 本机磁盘布局与挂载策略。
#
# 分工:
#   - device / fsType / subvol 这类「身份」由 hardware-configuration.nix 提供
#   - 已有挂载点这里只追加 options(对象合并 = 拼接,不要重复写 subvol=/device)
#   - 这台机器特有的子卷(不是挂载点)也放在这里
{ lib, pkgs, ... }:

let
  # btrfs 挂载参数(与机器无关的策略)
  btrfsTuning = [
    "noatime" # 不记录访问时间(SSD 少写一点)
    "compress=zstd" # 透明压缩
    # 不写 autodefrag:它面向机械盘/虚拟机镜像的随机小写,SSD 上只会写放大。
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

  # snapper 给 /home 存快照用的子卷(不单独挂载,嵌在 @home 里面)
  homeSnapshots = "/home/.snapshots";
in
{
  # options 是 listOf str,模块合并 = 拼接:
  # 最终 = hardware-configuration 里的 [ "subvol=@…" ] ++ btrfsTuning
  fileSystems = lib.genAttrs tunedMounts (_: {
    options = btrfsTuning;
  });

  # ── /home 的快照子卷 ──────────────────────────────────────────────
  # snapper 要求 SUBVOLUME 下有名为 .snapshots 的「子卷」(不是普通目录)。
  # NixOS 没有声明式创建子卷的手段:
  #   - fileSystems."/home/.snapshots" 只是挂载,子卷不存在会直接挂载失败
  #   - systemd.tmpfiles 只能建普通目录
  #   - services.snapper 只写配置,不建子卷
  # 所以用一个 oneshot 补一次,幂等:
  #   已是子卷 → 跳过;不存在 → 创建;是空目录 → rmdir 后创建;
  #   是非空目录 → 故意失败,避免误删数据。
  # 必须早于 snapper-timeline,否则第一次快照会报 ".snapshots is not a subvolume"。
  systemd.services.create-home-snapshots-subvolume = {
    description = "Create ${homeSnapshots} btrfs subvolume for snapper";
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
      SNAP=${homeSnapshots}

      if ! ${pkgs.btrfs-progs}/bin/btrfs subvolume show "$SNAP" >/dev/null 2>&1; then
        if [ -d "$SNAP" ]; then
          ${pkgs.coreutils}/bin/rmdir "$SNAP"
        fi
        ${pkgs.btrfs-progs}/bin/btrfs subvolume create "$SNAP"
      fi
    '';
  };
}
