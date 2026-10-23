# btop 的 GPU 监控配置。
#
# 本体由系统侧提供(modules/packages/default.nix 里的 security.wrappers.btop),
# 不在这里安装:
#   - 独显:btop 用 dlopen 加 libnvidia-ml.so.1,需要二进制带
#     /run/opengl-driver/lib 的 RUNPATH(cudaSupport 覆盖会加)
#   - 核显:读 i915 PMU 需要 CAP_PERFMON,系统侧 wrapper 已经把该 capability 赋给它
# 所以普通用户直接运行 btop 就能看到两张卡,不需要 sudo。
#
# 这里只负责生成 ~/.config/btop/btop.conf,其余项一律用 btop 默认值。
{ ... }:

{
  programs.btop = {
    enable = true;
    package = null; # 不重复安装:用系统侧带 CAP_PERFMON 的 wrapper

    settings = {
      # 默认布局:CPU / 内存 / 网络 / 进程,不带独立的 GPU 面板。
      # 需要看单卡详情时在 btop 里按数字键(再按一次关闭):
      #   5 = gpu0(通常是独显)  6 = gpu1(通常是核显)  7-0 = gpu2..gpu5
      #
      # 为什么不在默认布局里预先写 gpu0/gpu1:
      #   编号必须 ≤ 实际探测到的 GPU 数,否则整份 shown_boxes 会被 btop 判为无效,
      #   所有面板的布局一起回退。让运行时按需打开最稳妥。
      shown_boxes = "cpu mem net proc";

      # 只探测实际存在的厂商,避免 btop 去加载 ROCm(amd)等用不到的库。
      # 默认值是 "nvidia amd intel apple"。
      shown_gpus = "nvidia intel";

      # 配置文件由 Home Manager 生成(只读软链),
      # 不让 btop 退出时回写,免得报错或把软链换成普通文件。
      # 副作用:按 5/6 打开的面板只在本次会话有效,重启回到默认布局。
      save_config_on_exit = false;
    };
  };
}
