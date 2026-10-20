# Plasma 6 + SDDM。SDDM 同时承载 Plasma 和 Niri 两个会话。
{ ... }:

{
  services.xserver.enable = true; # Wayland 会话也需要它(xwayland/键盘等)
  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true; # SDDM 自己也跑在 Wayland 上
  };
}
