# 双显卡(Optimus 笔记本):Intel HD 630 核显 + NVIDIA GTX 1050 Mobile 独显。
#
# 方案:PRIME Render Offload(按需调用独显)
#   - 桌面、浏览器、视频等等全部跑核显:省电、发热低、续航正常
#   - 需要独显时:nvidia-offload 程序(游戏、CUDA、Blender ...)
#   - 不用 sync(独显全程工作)模式:本机屏幕物理接在核显上、没有 MUX 开关,
#     sync 模式只会让独显一直通电发热,换不来直连。
#
# 硬件事实(来自 lspci / sysfs,换机器前请重新确认):
#   0000:00:02.0  Intel  HD 630        → PCI:0:2:0
#   0000:01:00.0  NVIDIA GTX 1050M     → PCI:1:0:0
#
# 查询方法:
#   grep -H . /sys/bus/pci/devices/*/class | grep -E '0x0300|0x0302'
{ ... }:

{
  # 只要写 nvidia。开启 PRIME 后,NixOS 会自动给核显补一个 modesetting 的 X 设备,
  # 所以这里不要再写 "modesetting"(会重复配置同一个设备)。
  services.xserver.videoDrivers = [ "nvidia" ];

  # 3D 加速的运行时环境(/run/opengl-driver)。
  # 现在是由桌面模块间接触发的,这里显式写死,避免以后换桌面环境时莫名其妙丢硬件加速。
  hardware.graphics.enable = true;

  hardware.nvidia = {
    # ── 为什么不用默认的 stable 分支 ────────────────────────────────
    # nixpkgs 的 stable 现在是 595 系列,而 NVIDIA 从 580 之后就不再支持
    # Maxwell/Pascal/Volta。GTX 1050 是 Pascal,必须用 580 LTSB 分支
    # (nixpkgs 注释:支持到 2028-08)。用 595 会直接加载失败。
    branch = "legacy_580";

    # 开源内核模块只支持 Turing(RTX 20 系/GTX 16 系)及以后,Pascal 必须用闭源的。
    # 另外驱动 >= 560 时这个选项没有默认值,NixOS 会强制要求你显式写出来。
    open = false;

    # 让内核把独显也注册成 DRM 设备。Wayland 下必需;
    # X11 下也能减少画面撕裂。
    modesetting.enable = true;

    prime = {
      offload.enable = true;
      # 生成 nvidia-offload 命令(见下方用法)
      offload.enableOffloadCmd = true;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # 下面这些用默认值即可,列出来是为了说明「为什么不改」:
    #   nvidiaSettings    = true  → 自带 nvidia-settings 图形界面
    #   videoAcceleration = true  → 装 nvidia-vaapi-driver,给浏览器/播放器硬解
    #   powerManagement   = false → 动态给独显断电只支持 Turing 及以后,
    #                               在 Pascal 上开启会出问题,保持关闭
  };
}

# ── 用法 ────────────────────────────────────────────────────────────────
# 普通程序(自动走核显):
#   firefox
#
# 需要独显时:
#   nvidia-offload glxinfo | grep "OpenGL renderer"
#   nvidia-offload steam
#
# 只查询两张卡的状态:
#   nvidia-smi
