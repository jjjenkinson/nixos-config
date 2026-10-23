{ ... }:

{
  # ── 音频 ─────────────────────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    alsa.enable = true; # 兼容直接用 ALSA 的程序
    pulse.enable = true; # 兼容用 PulseAudio 的程序

    # ── 蓝牙音频不要被 logind 会话状态牵连 ─────────────────────────────
    # WirePlumber 默认开着「seat 监控」:logind 说座位不是 active 时,
    # 它会停掉 bluez 监视器,把所有 A2DP endpoint 反注册。
    # 后果:耳机能连上但立刻断开,bluetoothd 日志是
    #   a2dp-sink profile connect failed ... Protocol not available
    # (bluez 源码里 source_record_id == 0 → return -ENOPROTOOPT)。
    #
    # 我们的登录管理器 lemurs 会把整段登录维持在一个 logind session 里:
    # 注销再登录后,同一个 session 变成 State=closing,
    # WirePlumber 于是误判座位不活跃 → 蓝牙音频失效。
    # 关掉这个特性后,蓝牙音频不再跟随 logind 状态。
    wireplumber.extraConfig."51-bluez-no-seat-monitoring" = {
      "wireplumber.profiles".main."monitor.bluez.seat-monitoring" = "disabled";
    };
  };

  # 桌面/音频软件要低延迟时需要 rtkit 给进程实时优先级。
  security.rtkit.enable = true;

  # ── 蓝牙 ─────────────────────────────────────────────────────────────
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true; # 显示设备电量等实验性功能
  };

  # ── 网络 ────────────────────────────────────────────────────────────
  # NetworkManager: Wi-Fi / 有线 / VPN 都由桌面或 nmcli 管理。
  networking.networkmanager.enable = true;

  # ── 固件更新 ───────────────────────────────────────────────────────
  # fwupd 只负责硬件固件(Wi-Fi 网卡、SSD、扩展厂 ROM 等),和桌面环境无关,
  # 所以放共享层。以前它是由 plasma6 模块顺带开启的,不装 Plasma 的机器会缺。
  services.fwupd.enable = true;

  # ── 文档 ─────────────────────────────────────────────────────────────
  # 不构建 NixOS 手册和 options 文档,省掉每次 nh os switch 的固定开销。
  # 查选项用 https://search.nixos.org/options;普通命令的 man 不受影响。
  documentation.nixos.enable = false;

  # ── 日志 ─────────────────────────────────────────────────────────────
  # 不设上限时 journald 会按 /var 的 10% 截断(本机约 16G),实际已涨到 450MB+。
  # 500M 足够回溯最近几次启动;立即收缩用 journalctl --vacuum-size=500M。
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    SystemMaxFileSize=50M
  '';

  # ── 运行非 Nix 打包的二进制 ──────────────────────────────────────────
  # 给它们提供 /lib64/ld-linux-x86-64.so.2 这类动态链接器入口
  # (VSCode 的 server、第三方安装器、下载来的 CLI 等)。
  # 个别程序还缺某些共享库时,往 programs.nix-ld.libraries 里加。
  programs.nix-ld.enable = true;
}
