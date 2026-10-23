{ ... }:

{
  # ── 音频 ─────────────────────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    alsa.enable = true; # 兼容直接用 ALSA 的程序
    pulse.enable = true; # 兼容用 PulseAudio 的程序
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
