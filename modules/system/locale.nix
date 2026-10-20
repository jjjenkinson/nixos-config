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

  # 新建用户时 ~/ 下生成的目录名(默认是中文,这里统一成英文,脚本更友好)。
  # 注意:只影响新建用户,已有用户的 ~/.config/user-dirs.dirs 不会被改。
  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=Desktop
    DOWNLOAD=Download
    TEMPLATES=Templates
    PUBLICSHARE=Public
    DOCUMENTS=Documents
    MUSIC=Music
    PICTURES=Pictures
    VIDEOS=Videos
  '';
}
