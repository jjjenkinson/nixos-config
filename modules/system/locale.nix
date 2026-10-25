{ ... }:

{
  time.timeZone = "Asia/Shanghai";

  # 界面语言用中文。它写入 /etc/locale.conf 的 LANG=,是所有 LC_* 分类的兜底值。
  # 注意:/etc/locale.conf 只在【登录时】由 PAM 读取并注入环境,
  # 所以改完要注销重新登录(或重启)才会对图形会话生效。
  i18n.defaultLocale = "zh_CN.UTF-8";

  # 这里【不要】再写 i18n.extraLocaleSettings.LC_MESSAGES = "en_US.UTF-8"。
  # LC_MESSAGES 同时管「GUI 菜单」和「终端报错」,设成 en_US 会把
  # Dolphin / noctalia / Chrome 的界面一起变成英文。
  #
  # 想要「GUI 中文 + 终端英文」得在 shell 层拆:
  #   home/common/shell.nix 里 fish / bash 各自 export LC_MESSAGES=en_US.UTF-8
  #
  # 但**必须只在交互式 shell 里 export**:
  #   fish → programs.fish.interactiveShellInit
  #   bash → programs.bash.initExtra
  # 不能用 fish 的 shellInit / bash 的 bashrcExtra——那两个在非交互 shell 里
  # 也会执行,而 niri-session 会先 exec 一个登录 shell 再 exec niri,非交互
  # export 的变量会顺着 exec 进入整个图形会话,等于又把它设到了系统级。
  # 放在交互分支里,就只有终端里的子进程是英文;由 niri / fuzzel 直接启动的
  # 图形程序继承登录会话环境(只有 LANG=zh_CN),仍然是中文。
  #
  # 但 shell 要能切到 en_US,glibc 里必须先有这个 locale:
  i18n.extraLocales = [ "en_US.UTF-8/UTF-8" ];

  # 硬件时钟按本地时间。本机与 Windows 双系统共存,Windows 默认把 RTC 当本地时间,
  # 所以这里必须保持 true,否则两边会差 8 小时。
  # 以后不再装 Windows 时可改成 false(让 RTC 存 UTC),改后执行一次:
  #   sudo timedatectl set-local-rtc 0
  time.hardwareClockInLocalTime = true;

  # ── 关于 ~/ 下的「文档、下载、音乐…」目录名 ──────────────────────────
  # 这里**不需要**配置 environment.etc."xdg/user-dirs.defaults":
  #
  #   1. 它挡不住中文名。xdg-user-dirs-update 会拿 "Documents" 这类英文值
  #      去 gettext 查当前语言的翻译(实测:LANG=zh_CN 时,有没有这个文件
  #      都会生成 ~/文档、~/下载)。
  #   2. 现在英文名能稳定保持,靠的是 Home Manager 的 xdg.userDirs:
  #      它生成只读的 ~/.config/user-dirs.dirs,并额外写一个
  #      ~/.config/user-dirs.conf(enabled=False),让 xdg-user-dirs-update
  #      直接不工作。不依赖 LC_MESSAGES,和界面语言互不影响。
  #   3. 对已有用户没有影响:目录名真正的来源是 ~/.config/user-dirs.dirs。
  #
  # 所以删掉了原来的 user-dirs.defaults(它还写着 DOWNLOAD=Download 单数,
  # 和实际的 ~/Downloads 不一致)。想改某个目录指向,直接编辑
  # home/common/default.nix 里的 xdg.userDirs 即可。
}
