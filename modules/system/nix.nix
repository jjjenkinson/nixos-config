# Nix 本体设置,以及 nix 相关工具 nh。
{ config, ... }:

{
  nix.settings = {
    # flakes + 新命令行(nix build / nix shell ...)。
    experimental-features = [
      "flakes"
      "nix-command"
    ];

    # 二进制缓存:国内镜像优先,官方由 NixOS 追加在末尾(mkAfter),这里不用重复写。
    # 顺序原则:最近没出过问题的放前面。
    #   2026-10-20 移除 SJTU:TCP 连得上但服务端不回数据,单请求挂起过 117s。
    #   2026-10-21 NJU 也开始频繁 stalled,因此降到末位;哪家再卡就同样降级。
    #   2026-10-23 重新加回 SJTU:实测 nix-cache-info 正常(HTTP 200,约 2.7s)。
    #     但它历史上有过挂起,所以放末位;下面的 connect-timeout /
    #     stalled-download-timeout 能保证它再不回数据时只浪费十几秒就跳下一个。
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.nju.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];

    # 国内镜像只是 cache.nixos.org 的镜像,签名不变,所以只需要这一把 key。
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    # 这两项决定「镜像卡住时最多等多久」:
    #   connect-timeout         连不上就尽快换下一个(默认 0 = 一直等)
    #   stalled-download-timeout 连上但不回数据的上限(默认 300s)
    # 配合 download-attempts,最坏情况也只卡 ~20 秒。
    connect-timeout = 5;
    stalled-download-timeout = 10;
    download-attempts = 2;

    # 安装时不去重(它每次都要扫 store,拖慢 switch),
    # 改由下面的 nix.optimise.automatic 在空闲时做硬链接去重。
    auto-optimise-store = false;
  };

  # 只用 flake,不再用 nix-channel(避免两套来源互相干扰)。
  nix.channel.enable = false;

  # 定时执行等价于 `nix store optimise` 的去重,默认每天一次。
  nix.optimise.automatic = true;

  # ── nh:nixos-rebuild / home-manager 的社区替代 ────────────────────────
  programs.nh = {
    enable = true;

    # 固定 flake 路径后,`nh os switch` 不用带 --flake。
    # 用仓库真实路径而不是 /etc/nixos 软链:软链丢了 nh 就会报错。
    # 路径跟着主用户走 —— 占位主机 HHHH 上就是 /home/XXXX/nixos-config。
    flake = "${config.users.users.${config.my.user.name}.home}/nixos-config";

    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 30d --keep 15"; # 保留 30 天内最多 15 代
    };
  };
}
