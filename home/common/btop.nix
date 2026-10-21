# btop 的 GPU 监控配置。
#
# 本体由系统侧提供(modules/packages/default.nix 里的 security.wrappers.btop),
# 不在这里安装:
#   - 独显:btop 用 dlopen 加 libnvidia-ml.so.1,需要二进制带
#     /run/opengl-driver/lib 的 RUNPATH(cudaSupport 覆盖会加)
#   - 核显:读 i915 PMU 需要 CAP_PERFMON,系统侧 wrapper 已经把该 capability 赋给它
# 所以普通用户直接运行 btop 就能看到两张卡,不需要 sudo。
#
# 这里只负责生成 ~/.config/btop/btop.conf。
{ config, lib, ... }:

let
  cfg = config.my.btop;

  # btop 的 GPU 面板名是 gpu0/gpu1/…,不是 "gpu"。
  # 启动时 set_boxes 会按实际检测到的 GPU 数量校验编号:
  # 给只有 1 张卡的机器写 gpu1 会让整份 shown_boxes 失效,
  # 所以数量必须在每台主机/用户那里声明。
  gpuBoxes = lib.concatMapStringsSep " " (i: "gpu${toString i}") (lib.range 0 (cfg.gpuCount - 1));
in
{
  options.my.btop.gpuCount = lib.mkOption {
    type = lib.types.ints.positive;
    default = 1;
    description = "btop 要显示的 GPU 面板数量;双显卡机器设为 2";
  };

  config.programs.btop = {
    enable = true;
    package = null; # 不重复安装:用系统侧带 CAP_PERFMON 的 wrapper

    settings = {
      # 面板顺序;gpu0 通常是独显(NVML 先枚举),gpu1 是核显
      shown_boxes = "cpu mem net proc ${gpuBoxes}";

      # 只探测实际存在的厂商,避免 btop 去加载 ROCm 等库
      shown_gpus = "nvidia intel";

      update_ms = 2000;
    };
  };
}
