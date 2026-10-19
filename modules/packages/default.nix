# 系统级软件包:所有用户都能用,并且和“谁登录”无关的东西。
#
# 为什么有些“个人软件”也放在这里?
#   nix 求值 home.packages 时,必须把每个包实例化成 derivation（每个约 0.1~1 秒）。
#   把“装好就很少动”的大件放到系统侧,`nh home switch` 的求值时间
#   实测 12.5s → 10.9s(省得不多,因为剩下的大头是 unstable 的 zed/helix)。
#   附加好处:这些包不再出现在 home 的 profile 里(home-manager-path 少一批软链)。
#   代价:增删/升级这些包要走 `sudo nh os switch`,而不是 `nh home switch`。
#
# 判断标准:
#   - 经常改、经常试、跟用户配置绑定的  → home/jiro/default.nix(home.packages)
#   - 装好就很少动的大件桌面应用        → 这里
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ── 命令行基础设施 ──────────────────────────────────────
    git
    wget
    wl-clipboard # Wayland 剪贴板工具(wl-copy / wl-paste)

    # ── 桌面应用(体积大、求值贵,装好很少动)───────────────
    firefox
    google-chrome # 想要 unstable 版:在 overlays/unstable.nix 的 names 里放开这一项
    mpv
    vlc
    libreoffice
    sioyek # pdf 阅读器
  ];
}
