# 登录管理器:lemurs —— 与具体桌面环境无关(Plasma / Niri / 以后加的其它会话共用)。
#
# 为什么单独成文件:
#   - 换登录管理器(sddm / greetd / ly / lemurs…)或调登录界面时,只动这一个文件
#   - 桌面的其余部分(字体、输入法、各个 DE)不受影响
#
# 为什么选 lemurs:
#   纯文本 TUI 登录界面(跑在 tty1),不需要合成器,所以没有 cage / regreet
#   那一套图形栈,也就没有「图形界面起不来 → 黑屏」这类故障模式。
{
  config,
  lib,
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
  # 为什么需要、为什么不能写进服务环境,见下面 pam 那段注释。
  lemursSeatEnv = pkgs.writeText "lemurs-seat-env" ''
    XDG_SEAT DEFAULT=seat0
    XDG_VTNR DEFAULT=1
  '';
in

{
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

  # ── lemurs 本体 ────────────────────────────────────────────────────
  # 记住上次会话全用 lemurs 自己的配置项(默认值就是 true,这里写明是为了
  # 一眼看得出行为,不依赖上游默认值):
  #   username_field.remember       —— 记住上次登录的用户名
  #   environment_switcher.remember  —— 记住上次选的桌面环境(Plasma / Niri / ...)
  # 缓存写在 lemurs 默认的 /var/cache/lemurs,重启后仍然有效。
  #
  # max_display_length:会话名显示长度。默认只有 8,"Plasma (Wayland)" 会被
  # 截成 "Plasma (",这里设成 16 —— 刚好放得下这个最长的名字。
  #
  # ⚠️ Wayland 会话需要登录用户在 seat 组(见 modules/users/default.nix),
  # 模块会自动启 services.seatd。
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
  # logind 的 TakeDevice,所以直接报
  #   kwin_wayland: No suitable DRM devices have been found
  # 然后整套 Plasma 的 Qt 进程跟着 abort(这就是「猜密码后瞬间回登录界面」)。
  # niri 能动是因为它回退到 seatd,而用户已在 seat 组里。
  #
  # 上游修复(commit 7283f01,改成在子进程里开会话)尚未发布。
  # 这里在 PAM 堆栈里插一个 pam_env,把两个变量写进 PAM 环境,
  # pam_systemd 会优先读 PAM 环境(上游 issue #256 的绕法)。
  security.pam.services.lemurs.rules.session.seat-env = {
    # 必须落在 pam_env(env) 之后、pam_systemd(systemd) 之前;
    # 用相对位置而不是写死数字,避免以后 nixpkgs 调整默认顺序时撞车。
    order = config.security.pam.services.lemurs.rules.session.systemd.order - 1;
    control = "optional";
    modulePath = "${pkgs.linux-pam}/lib/security/pam_env.so";
    args = [
      "conffile=${lemursSeatEnv}"
      "readenv=0"
    ];
  };
}
