{ ... }:

{
  time.timeZone = "Asia/Shanghai";

  # 界面语言用中文。
  i18n.defaultLocale = "zh_CN.UTF-8";

  # 但程序输出/报错单独走英文:编译错误、nix 报错、脚本输出更便于搜索。
  # 界面语言由 LANG 决定,不受影响;en_US.UTF-8 已在 supportedLocales 里。
  i18n.extraLocaleSettings.LC_MESSAGES = "en_US.UTF-8";

  # 硬件时钟按本地时间(双系统与 Windows 共存时才需要)。
  # 本机没有 Windows,理应改成 false(让 RTC 存 UTC),改后执行一次:
  #   sudo timedatectl set-local-rtc 0
  time.hardwareClockInLocalTime = true;

  # ── 关于 ~/ 下的「文档、下载、音乐…」目录名 ──────────────────────────
  # 这里**不需要**配置 environment.etc."xdg/user-dirs.defaults":
  #
  #   1. 它挡不住中文名。xdg-user-dirs-update 会拿 "Documents" 这类英文值
  #      去 gettext 查当前语言的翻译(实测:设成 zh_CN 时,有没有这个文件
  #      都会生成 ~/文档、~/下载)。
  #   2. 现在之所以是英文,靠的是上面的 LC_MESSAGES=en_US.UTF-8 ——
  #      gettext 不翻译,上游默认值本身就是英文。
  #   3. 对已有用户没有影响:目录名真正的来源是 ~/.config/user-dirs.dirs,
  #      只有在该文件缺失、或 user-dirs.locale 变化时才会被重新生成。
  #
  # 所以删掉了原来的 user-dirs.defaults(它还写着 DOWNLOAD=Download 单数,
  # 和实际的 ~/Downloads 不一致)。想改某个目录指向,直接编辑
  # ~/.config/user-dirs.dirs 即可;要声明式管理就用 home-manager 的 xdg.userDirs。
}
