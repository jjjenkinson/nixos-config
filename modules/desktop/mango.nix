# MangoWC:基于 dwl + scenefx 的平铺式 Wayland 合成器(dwl 那一系的手感)。
#
# 和 Plasma / Niri 一样,只是在登录界面多一个可选会话,互不影响。
# 是否启用由 my.desktop.mango.enable 控制(默认关,在 hosts/*/default.nix 里打开)。
#
# 截图工具(grim / slurp / satty / wl-clipboard)在用户侧安装,
# 见 home/common/mango.nix —— 这样只需 `nh home switch` 就能生效。
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.desktop.mango.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "是否启用 MangoWC 会话";
  };

  config = lib.mkIf config.my.desktop.mango.enable {
    # 这个 NixOS 模块替我们做了三件事,不用自己拼:
    #   1. 把 mango 装进 environment.systemPackages
    #   2. 打开 xdg.portal 并注册 wlr(ScreenCast / Screenshot)+ gtk 后端
    #   3. 把包写进 services.displayManager.sessionPackages
    #      → lemurs 的会话列表里自动出现 "Mango"
    #
    # 版本由 overlays/unstable.nix 决定(名单里有 mangowc → unstable 0.18.x)。
    # 用户侧的按键/外观配置在 dotfiles/mango/config.conf,
    # 由 home/common/mango.nix 软链到 ~/.config/mango/。
    programs.mangowc.enable = true;

    # ── XDG 自启动(/etc/xdg/autostart + ~/.config/autostart)────────────
    # 问题:mango 只激活 graphical-session.target,不会拉起
    # xdg-desktop-autostart.target;而那个 target 是 RefuseManualStart=yes,
    # 不能直接 `systemctl --user start`。所以系统生成的 app-*.service
    # (fcitx5、FlClash …)全都躺着不动。
    #
    # 解法:补一个 oneshot 单元,用 Wants= 把那个 target 拉起来。
    # niri 是把它写在 niri.service 里的,而 mango 的会话文件只是
    # `Exec=mango`(普通进程,不是 systemd 服务),没有地方能挂,只好自己加。
    #
    # 效果:清单里的应用都会启动;OnlyShowIn=KDE / GNOME 之类的条目,
    # systemd 会用 ExecCondition 自动跳过,不会把 KDE 那套拉起来。
    #
    # 触发点在 dotfiles/mango/config.conf:
    #   exec_once=systemctl --user start mango-xdg-autostart.service
    # 放在 exec_once 里是有意的:必须等合成器起来(有 WAYLAND_DISPLAY)再启动。
    systemd.user.services.mango-xdg-autostart = {
      description = "Pull in XDG autostart apps for the Mango session";
      wants = [ "xdg-desktop-autostart.target" ];
      after = [ "xdg-desktop-autostart.target" ];
      # 跟着会话来去:会话结束就停,不会把 target 和实例挂在图形会话之外
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        # 保持 active(exited):否则本单元一退出,
        # xdg-desktop-autostart.target 因为 StopWhenUnneeded=yes 会被停掉
        RemainAfterExit = true;
        ExecStart = "${pkgs.coreutils}/bin/true";
      };
    };
  };
}
