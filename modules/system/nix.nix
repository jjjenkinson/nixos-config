# Nix 本体设置,以及 nix 相关工具 nh。
{ config, ... }:

{
  # 打开 flakes 与新命令行(nix build / nix shell ...)。
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  nix.settings = {
    # 二进制缓存:国内镜像优先,最后回落到官方。
    # 实测(湖北、直连):NJU 约 1.2–1.4 MB/s,cache.nixos.org 约 0.9–1.0 MB/s,
    # 所以官方放最后。Nix 按顺序逐个查询,前一个没有这个包就自动看下一个。
    # 官方 cache.nixos.org 由 NixOS 默认追加在列表末尾,这里不用重复写。
    #
    # ⚠️ 2026-10-20 实测:mirror.sjtu.edu.cn 会「TCP 连得上、但服务端不回数据」,
    # 单个 narinfo 请求挂起过 117s / 31s。connect-timeout 只管建连,救不了这种卡死,
    # 而 nix 对每个要新建的 derivation 都会逐个问 substituter,
    # 结果就是每次改配置后 nh home switch 平白多等 1~2 分钟。已从列表移除。
    substituters = [
      "https://mirror.nju.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
    # 缓存里的产物用官方 key 签名;国内镜像只是 cache.nixos.org 的镜像,
    # 签名不变,所以只需要这一把 key。
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    # auto-optimise-store 有开销：它会在安装时做硬链接去重，吃 CPU 和磁盘 IO。
    # 如果更在意安装速度，可以设为 false，偶尔手动跑 nix store optimise。
    auto-optimise-store = true; # store 内相同文件去重,省空间

    # 某个镜像连不上时不要干等(默认 0 = 不超时),尽快切下一个
    connect-timeout = 5;

    # 连上了、但服务端迟迟不回数据时的上限(默认 300 秒!)。
    # 上面 SJTU 那种「连上后卡死」只有靠它兜底,否则一次就罚站几分钟。
    stalled-download-timeout = 10;

    # 单个路径的重试次数(默认 5 次)。配合上面两项,最坏情况也只卡 ~20 秒。
    download-attempts = 2;
  };

  # 不再使用 nix-channel,只用 flake(避免两套来源互相干扰)
  nix.channel.enable = false;

  # ── nh:nixos-rebuild / home-manager 的社区替代,输出友好,自带清理 ────────
  programs.nh = {
    enable = true;

    # 固定 flake 路径后,可以直接 `nh os switch`,不用带 --flake。
    # 推荐:把 /etc/nixos 做成指向本仓库的软链接
    #   sudo rm -rf /etc/nixos && sudo ln -s /home/${config.users.users.jiro.name}/nixos-config /etc/nixos
    flake = "/etc/nixos";

    clean = {
      enable = true; # 定期清理旧 generation
      dates = "weekly";
      extraArgs = "--keep-since 30d --keep 15"; # 保留 30 天内最多 15 代
    };
  };
}
