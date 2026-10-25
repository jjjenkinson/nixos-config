# 桌面 GUI 应用(系统侧)。
#
# 这些包**逻辑上属于用户**,正常情况下应该写在 home/common/default.nix 的
# home.packages 里 —— 毕竟「装什么软件」是用户的选择,不是系统的。
#
# 放在系统侧的唯一原因是省时间:
#   - home.packages 里每个包都会进 home 闭包和 profile
#   - 这些应用体积大、求值贵、装好又很少动
#   - 放系统侧后 home 闭包从 884 个 store 路径降到 831,`nh home switch` 更快
#
# 代价:
#   - 增删/升级这些包要走 `sudo nh os switch`,不能只 `nh home switch`
#   - 安装后**所有用户**都能看到(通常无所谓)
#
# 所以增删软件时先问自己:这是「偶尔装一个试试」还是「装上就不动了」?
#   - 偶尔试 → home/common/default.nix
#   - 长期用 → 这里
#
# 真·系统基础(git、工具链、btop wrapper)在 ./default.nix。
{ pkgs, ... }:

let
  # Kopuz 不在 nixpkgs 里(stable / unstable 都没有),包定义见 pkgs/kopuz.nix:
  # 直接拿上游 GitHub release 的 .deb 重新打包,版本跟上游一致。
  kopuz = pkgs.callPackage ../../pkgs/kopuz.nix { };
in
{
  environment.systemPackages = with pkgs; [
    # ── 浏览器 ─────────────────────────────────────────────
    firefox
    google-chrome # 想要 unstable 版:在 overlays/unstable.nix 的 names 里放开这一项
    brave

    # ── 即时通讯(均为 unfree,靠 flake.nix 的 pkgsConfig.allowUnfree 放行)──
    # 微信 Linux 原生版(腾讯官方 AppImage)。版本由 overlays/unstable.nix 决定:
    # 当前 unstable 是 4.1.13.26,而 stable 只有 4.1.1.4。
    wechat
    # 腾讯会议。stable 和 unstable 目前是同一个版本(3.26.10.401),
    # 所以不进 overlay 名单,直接用 stable 的。
    # 包里有 `wemeet`(默认)和 `wemeet-xwayland`(强制 XWayland,回退用),
    # 并带 wayland 屏幕共享插件(依赖 pipewire,已在 modules/system/base.nix 开启)。
    wemeet

    # ── 影音 ───────────────────────────────────────────────
    mpv
    vlc
    # 音乐播放器
    # namida 还不在 nixpkgs 里,要装只能导入独立 flake 或打包
    kopuz # YouTube Music 客户端(本地打包,见 pkgs/kopuz.nix)
    lx-music-desktop # 音乐下载

    # ── 文档 ───────────────────────────────────────────────
    libreoffice
    sioyek # pdf 阅读器
  ];
}
