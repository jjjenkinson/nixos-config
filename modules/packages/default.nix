# 系统级软件包:所有用户都能用,并且和“谁登录”无关的东西。
#
# 为什么有些“个人软件”也放在这里?
#   home.packages 里的每个包都会进 home 闭包和 profile。把「装好就很少动」
#   的大件放系统侧,可以:
#     - 让 home 闭包更小(实测 884 → 831 个 store 路径)
#     - home profile 少一批软链,升级/回滚更简单
#   注意:冷启动时间的收益很小(求值大头不是包的数量),不要把这里当提速手段。
#   代价:增删/升级这些包要走 `sudo nh os switch`,而不是 `nh home switch`。
#
# 判断标准:
#   - 经常改、经常试、跟用户配置绑定的  → home/common/default.nix(home.packages)
#   - 装好就很少动的大件应用/工具      → 这里
{ pkgs, ... }:

let
  # cudaSupport 在这里不是编译 CUDA 支持,只是让 autoAddDriverRunpath
  # 给 btop 加上 /run/opengl-driver/lib 的 RUNPATH。
  # 有了它,btop 才能 dlopen 到 libnvidia-ml.so.1(否则非 root 看不到独显)。
  btopGpu = pkgs.btop.override { cudaSupport = true; };

  # Kopuz 不在 nixpkgs 里(stable / unstable 都没有),包定义见 pkgs/kopuz.nix:
  # 直接拿上游 GitHub release 的 .deb 重新打包,版本跟上游一致。
  kopuz = pkgs.callPackage ../../pkgs/kopuz.nix { };
in
{
  environment.systemPackages = with pkgs; [
    # ── 命令行基础设施 ──────────────────────────────────────
    git
    wget
    wl-clipboard # Wayland 剪贴板工具(wl-copy / wl-paste)

    # ── 诊断工具 ───────────────────────────────────────────
    # glxinfo / glxgears;配合 nvidia-offload 验证 PRIME 是否真的用上了独显。
    # nvidia-offload 只是设置环境变量后 exec 命令,命令本身仍需在 PATH 里。
    mesa-demos

    # ── 开发 / 排版工具(装好很少动)────────────────────────────
    # 这些只是被编辑器/终端调用,与用户配置无关。放系统侧后,
    # home 闭包更小(884 → 831 个 store 路径),profile 更精简。
    # 冷启动时间的改善很小,不要把它当提速手段。
    # 代价:升级它们要走 `sudo nh os switch`。
    gnumake
    nixd # Nix LSP(Zed / Helix 用)
    nixfmt # Nix 格式化
    rust-analyzer
    rustfmt
    pyright
    ruff
    typst # 排版编译器
    tinymist # Typst 的 LSP + 实时预览 + 格式化

    # ── 桌面应用(体积大、求值贵,装好很少动)───────────────
    firefox
    google-chrome # 想要 unstable 版:在 overlays/unstable.nix 的 names 里放开这一项
    mpv
    vlc
    # 音乐播放器
    # namida 还不在 nixpkgs 里,要装只能导入独立 flake 或打包
    kopuz # YouTube Music 客户端(本地打包,见 pkgs/kopuz.nix)
    lx-music-desktop # 音乐下载

    libreoffice
    sioyek # pdf 阅读器
  ];

  # btop 的核显监控读 i915 PMU,普通用户需要 CAP_PERFMON。
  # wrapper 会把该 capability 加进 ambient set,所以不用 sudo 也能看核显;
  # 独显靠上面 cudaSupport 提供的 NVML RUNPATH,不需要额外权限。
  # /run/wrappers/bin 在 PATH 最前面,会覆盖 profile 里的同名 btop。
  security.wrappers.btop = {
    source = "${btopGpu}/bin/btop";
    owner = "root";
    group = "root";
    capabilities = "cap_perfmon+ep";
  };
}
