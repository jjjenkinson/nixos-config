# Niri:可滚动的平铺式 Wayland 合成器(与 Plasma 共存,登录界面里选)。
#
# 分工:
#   - 本文件(系统侧):安装 niri、注册会话到登录管理器、X11 兼容、noctalia 需要的系统服务
#   - home/common/niri.nix(用户侧):niri 的 config.kdl 与 noctalia 桌面外壳
{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = [
    # X11 程序(Steam、部分游戏和工具)。
    # niri 25.08 起自带 xwayland-satellite 集成:只要 PATH 里有这个二进制,
    # 有 X11 客户端连接时 niri 会自动拉起它,它挂掉也会自动重启。
    # 所以不需要 programs.xwayland,也不需要写 spawn-at-startup。
    pkgs.xwayland-satellite

    # niri 默认键位里引用的几个小程序(见 home/common/niri.nix 的注释):
    pkgs.fuzzel # Mod+D 启动器
    pkgs.swaylock # Super+Alt+L 锁屏
    pkgs.brightnessctl # 亮度键
    pkgs.playerctl # 媒体键(播放/上一首/下一首)
  ];

  # brightnessctl 要写 /sys/class/backlight/*/brightness,默认只有 root 可写。
  # 这里把该文件交给 video 组(主用户已在 modules/users 里加入 video 组)。
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  # noctalia 的电池 / 电源模式面板依赖这两个服务
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # noctalia 会用到 freedesktop 音效主题
  xdg.sounds.enable = true;

  # 登录管理器是 Plasma Login Manager(见 modules/desktop/default.nix,与桌面环境无关):
  # programs.niri 会把 niri.desktop 注册进 displayManager.sessionPackages,
  # 于是登录界面会多出一个 Niri 会话,和 Plasma 并列。
}
