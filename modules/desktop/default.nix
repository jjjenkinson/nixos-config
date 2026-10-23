# 桌面层入口:字体、输入法、登录管理器,以及各个桌面环境。
{
  lib,
  config,
  pkgs,
  ...
}:

let
  xcfg = config.services.xserver;

  # lemurs 默认直接 exec 裸的 X(pkgs.xorg-server),不带 NixOS 生成的
  # `-config .../xserver.conf`,于是 X 找不到 ModulePath,报
  #   (EE) Failed to load module "libinput"
  # 后果:能进 X11 会话但键盘鼠标全无。这里把 displayManager 的启动参数
  # 带上(等价于 sddm/lightdm 的做法,也是 nixpkgs PR #568385 的修法)。
  # 去掉 -terminate:xrdb 这类一次性客户端退出时会把整个 X 关掉。
  xserverWrapper = pkgs.writeShellScript "xserver-wrapper" ''
    exec systemd-cat -t xserver-wrapper \
      ${xcfg.displayManager.xserverBin} \
      ${toString (lib.remove "-terminate" xcfg.displayManager.xserverArgs)} \
      "$@"
  '';

  # 给 pam_env 用的小配置文件:告诉 pam_systemd 这个会话在 seat0 / VT1。
  # 为什么需要、为什么不能写进服务环境,见下面 lemurs 那段注释。
  lemursSeatEnv = pkgs.writeText "lemurs-seat-env" ''
    XDG_SEAT DEFAULT=seat0
    XDG_VTNR DEFAULT=1
  '';
in

{
  # 哪台机器要 KDE Plasma。默认开;纯 Niri 的机器在 hosts/*/default.nix 里设为 false。
  options.my.desktop.plasma.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "是否启用 KDE Plasma 6";
  };

  imports = [
    ./fonts.nix
    ./input-method.nix # fcitx5 + Rime 雾凇拼音
    ./plasma.nix # Plasma 6(受 my.desktop.plasma.enable 控制)
    ./niri.nix # Niri(与 Plasma 在登录界面并列可选)
  ];

  # 注:本文件顶部有 options / imports,其余配置必须写在显式 config 下。
  config = {
    # ── 登录管理器:lemurs ──────────────────────────────────────────────
    # 纯文本 TUI 登录界面(跑在 tty1),不需要合成器,所以没有 cage / regreet
    # 那一套图形栈,也就没有「图形界面起不来 → 黑屏」这类故障模式。
    #
    # 记住上次会话全用 lemurs 自己的配置项(默认值就是 true,这里写明是为了
    # 一眼看得出行为,不依赖上游默认值):
    #   username_field.remember       —— 记住上次登录的用户名
    #   environment_switcher.remember  —— 记住上次选的桌面环境(Plasma / Niri)
    # 缓存写在 lemurs 默认的 /var/cache/lemurs,重启后仍然有效。
    #
    # max_display_length:会话名显示长度。默认只有 8,"Plasma (Wayland)" 会被
    # 截成 "Plasma (",这里设成 16 —— 刚好放得下这个最长的名字。
    #
    # ⚠️ Wayland 会话需要登录用户在 seat 组(见 modules/users/default.nix),
    # 模块会自动启 services.seatd。
    # ── 登录界面的「字号」= 控制台字体 ────────────────────────────────
    # lemurs 是纯文本 TUI,没有字号配置:字多大完全取决于 VGA 控制台字体。
    # Terminus 提供 12/14/16/18/20/22/24/28/32 像素高的点阵字体,默认字高16
    # 例如 ter-124n(12x24)、ter-128n(14x28)、ter-132n(16x32)。
    # 1080p 下 ter-128n = 137 列 × 38 行,字明显变大又不至于挤。
    # 注意:这对所有 tty 生效(包括 Ctrl+Alt+F2 的应急终端)。
    console = {
      packages = [ pkgs.terminus_font ];
      font = "ter-124n";
    };

    services.displayManager.lemurs = {
      enable = true;
      settings = {
        username_field.remember = true;
        environment_switcher = {
          remember = true;
          max_display_length = 16;
        };
        x11.xserver_path = "${xserverWrapper}";
      };
    };

    # ── 让 pam_systemd 把会话绑定到 seat0 ────────────────────────────
    # lemurs 0.4.0 在**主进程**里调 pam_open_session,而且开会话前会把
    # XDG_SEAT / XDG_VTNR 从自己的环境里删掉("preemptively removed")，
    # 于是 pam_systemd 算不出 VT，会话变成
    #   Seat= 空、VTNr=0
    # → logind 不给 /dev/dri 与 /dev/input 的权限。KWin 不用 libseat、只靠
    # logind 的 TakeDevice，所以直接报
    #   kwin_wayland: No suitable DRM devices have been found
    # 然后整套 Plasma 的 Qt 进程跟着 abort(这就是「猜密码后瞬间回登录界面」)。
    # niri 能动是因为它回退到 seatd，而用户已在 seat 组里。
    #
    # 上游修复(commit 7283f01，改成在子进程里开会话)尚未发布。
    # 这里在 PAM 堆栈里插一个 pam_env，把两个变量写进 PAM 环境，
    # pam_systemd 会优先读 PAM 环境(上游 issue #256 的绕法)。
    security.pam.services.lemurs.rules.session.seat-env = {
      # 必须落在 pam_env(env) 之后、pam_systemd(systemd) 之前；
      # 用相对位置而不是写死数字，避免以后 nixpkgs 调整默认顺序时撞车。
      order = config.security.pam.services.lemurs.rules.session.systemd.order - 1;
      control = "optional";
      modulePath = "${pkgs.linux-pam}/lib/security/pam_env.so";
      args = [
        "conffile=${lemursSeatEnv}"
        "readenv=0"
      ];
    };

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
  };
}
