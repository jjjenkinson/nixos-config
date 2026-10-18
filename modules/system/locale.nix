{
  ...
}:

{
  time.timeZone = "Asia/Shanghai";

  # 默认 locale 用中文。注意:terminal 里的报错信息也会变成中文
  i18n.defaultLocale = "zh_CN.UTF-8";

  # 硬件时钟按本地时间(和 Windows 双系统共存时保持一致)
  time.hardwareClockInLocalTime = true;

  # 新建用户时 ~/ 下生成的目录名(默认是中文,这里统一成英文,脚本更友好)
  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=Desktop
    DOWNLOAD=Download
    TEMPLATES=Templates
    PUBLICSHARE=Public
    DOCUMENTS=Documents
    MUSIC=Music
    PICTURES=Pictures
    VIDEOS=Videos
    PROJECTS=Projects
  '';
}
