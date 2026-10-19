# Nix 本体设置,以及 nix 相关工具 nh。
{ config, ... }:

{
  # 打开 flakes 与新命令行(nix build / nix shell ...)。
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  nix.settings = {
    # 二进制缓存:国内镜像优先,最后回落到官方
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];
    # 上面的镜像要被显式信任,nix 才会用它们
    trusted-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    auto-optimise-store = true; # store 内相同文件去重,省空间
  };

  # 不再使用 nix-channel,只用 flake(避免两套来源互相干扰)
  nix.channel.enable = false;

  # 非自由软件许可在 flake.nix 的 pkgsConfig 里统一开启(allowUnfree),这里不用重复

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
