{
  ...
}:

{
  boot.loader.systemd-boot.enable = true; # 用 systemd-boot(EFI 机器推荐)
  boot.loader.efi.canTouchEfiVariables = true; # 允许安装器写 EFI 变量
  boot.loader.systemd-boot.configurationLimit = 10; # 启动菜单最多保留 10 个旧代
}
