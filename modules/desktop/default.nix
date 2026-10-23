# 桌面层入口:字体、输入法、登录管理器,以及各个桌面环境。
#
# 这里只负责「组装」:
#   - 每部分的实际配置在同目录下各自的文件里(选项也声明在各自文件里)
#   - 加一个桌面环境 = 新增一个 xxx.nix + 在这里加一行 import
{ ... }:

{
  imports = [
    ./fonts.nix
    ./input-method.nix # fcitx5 + Rime 雾凇拼音
    ./login-manager.nix # 登录界面(lemurs)+ 控制台字体
    ./plasma.nix # Plasma 6(my.desktop.plasma.enable,默认关)
    ./niri.nix # Niri(my.desktop.niri.enable,默认开)
    ./mango.nix # MangoWC(my.desktop.mango.enable,默认关)
  ];

  # 本文件没有顶层 options,所以配置可以直接写在顶层。
  # ── KDE 应用在非 Plasma 会话里的「应用数据库」 ─────────────────────────
  # KDE 的 KService 建立 ~/.cache/ksycoca6_* 缓存前,要先读一个菜单文件:
  #   $XDG_CONFIG_DIRS/menus/${XDG_MENU_PREFIX}applications.menu
  # Plasma 会话会自动设 XDG_MENU_PREFIX=plasma-,而 niri 不会设。NixOS 的
  # plasma-workspace 只提供 plasma-applications.menu,于是 niri 会话里
  # kbuildsycoca 找不到菜单,建出来的库里 **一个 .desktop 都没有**。
  # 结果:Dolphin 双击任何文件,KIO 都认为「没有默认程序」,只弹一个选择
  # 应用的窗口(看起来就像双击没反应)。
  # 这里补一份不含 Plasma 分类的通用菜单,没有前缀的会话也能正常建库。
  # Plasma 会话带 plasma- 前缀,仍然用 plasma-applications.menu,不受影响。
  environment.etc."xdg/menus/applications.menu".text = ''
    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN" "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">
    <Menu>
      <Name>Applications</Name>
      <DefaultAppDirs/>
      <DefaultDirectoryDirs/>
      <Include>
        <All/>
      </Include>
    </Menu>
  '';
}
