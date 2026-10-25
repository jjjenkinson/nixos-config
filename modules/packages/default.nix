# 系统级「基础」软件:与「谁登录」无关、命令行/系统能力层面的东西。
#
# 这里只放三类:
#   1. 系统基础设施 —— git、wget、剪贴板、诊断工具
#   2. 被编辑器/终端调用的工具链 —— nixd、typst、pyright …
#   3. 需要 root 能力或全局可见的东西 —— btop 的 capability wrapper
#
# 桌面 GUI 应用不在这里,见 ./apps.nix。
# 它们本该进 home.packages,只是为了减少 `nh home switch` 的时间才放到系统侧,
# 单独成文件是为了让「哪些是妥协、哪些是真·系统基础」一眼可分。
#
# 判断标准:
#   - 经常改、经常试、跟用户配置绑定  → home/common/default.nix(home.packages)
#   - 装好就很少动的大件 GUI 应用     → ./apps.nix(系统侧)
#   - 上面的基础工具                  → 本文件
{ pkgs, ... }:

let
  # cudaSupport 在这里不是编译 CUDA 支持,只是让 autoAddDriverRunpath
  # 给 btop 加上 /run/opengl-driver/lib 的 RUNPATH。
  # 有了它,btop 才能 dlopen 到 libnvidia-ml.so.1(否则非 root 看不到独显)。
  btopGpu = pkgs.btop.override { cudaSupport = true; };
in
{
  imports = [ ./apps.nix ];

  environment.systemPackages = with pkgs; [
    # ── 命令行基础设施 ──────────────────────────────────────
    git
    wget
    wl-clipboard # Wayland 剪贴板工具(wl-copy / wl-paste)

    # ── 诊断工具 ───────────────────────────────────────────
    # glxinfo / glxgears;配合 nvidia-offload 验证 PRIME 是否真的用上了独显。
    # nvidia-offload 只是设置环境变量后 exec 命令,命令本身仍需在 PATH 里。
    mesa-demos
    # 查看/管理 UEFI 启动项(NVRAM)。双系统必备:
    #   sudo efibootmgr -v          看 BootOrder 和每条启动项指向哪个 .efi
    #   sudo efibootmgr -o 0001,0002  手动调整启动顺序
    # Limine/systemd-boot 的安装脚本只用它自己的那份,不会把它装进 PATH,
    # 所以想手动查就得在这儿装。
    efibootmgr

    # ── 开发 / 排版工具 ────────────────────────────────────
    # 这些只是被编辑器/终端调用,与用户配置无关,所以放系统侧:
    # home 闭包更小,profile 更精简。
    # 代价:升级它们要走 `sudo nh os switch`。
    gnumake
    nixd # Nix LSP(Zed / Helix 用)
    nixfmt # Nix 格式化
    pyright
    ruff
    typst # 排版编译器
    tinymist # Typst 的 LSP + 实时预览 + 格式化

    # ── Rust ───────────────────────────────────────────────
    # 走 nixpkgs 的稳定工具链(当前 1.95.0),不装 rustup:
    #   - 声明式、可回滚,版本与下面的 rust-analyzer 配套
    #   - 走二进制缓存,不用从 static.rust-lang.org 下载 1–2 GB
    #   - 大件放系统侧,`nh home switch` 不受影响
    # 需要 nightly / 交叉目标时再单独换 rustup(两者不要同时装)。
    rustc
    cargo
    clippy # `cargo clippy` 实际调用它
    rustfmt # `cargo fmt`
    rust-analyzer # 编辑器 LSP
    gcc # 提供 cc/ar/ld;cargo 默认链接器就是 cc
  ];

  # btop 的核显监控读 i915 PMU,普通用户需要 CAP_PERFMON。
  # wrapper 会把该 capability 加进 ambient set,所以不用 sudo 也能看核显;
  # 独显靠上面 cudaSupport 提供的 NVML RUNPATH,不需要额外权限。
  # /run/wrappers/bin 在 PATH 最前面,会覆盖 profile 里的同名 btop。
  # 注意 btop 本体不写进 systemPackages —— 只由这个 wrapper 提供。
  security.wrappers.btop = {
    source = "${btopGpu}/bin/btop";
    owner = "root";
    group = "root";
    capabilities = "cap_perfmon+ep";
  };
}
