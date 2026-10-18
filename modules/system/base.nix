{ ... }:

{

  # =========== audio ============

  services.pipewire = {
    enable = true;
    alsa.enable = true; # 兼容直接用 ALSA 的程序
    pulse.enable = true; # 兼容用 PulseAudio 的程序
  };

  # 桌面/音频软件要低延迟时建议开启(需要 rtkit 给进程实时优先级)
  security.rtkit.enable = true;

  # ========= 蓝牙 ==========
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # 启用实验性功能，显示设备电量
      };
    };
  };

  # ============网络==============
  # NetworkManager:桌面环境下最常用的网络管理服务(Wi-Fi/有线/VPN)
  networking.networkmanager.enable = true;

}
