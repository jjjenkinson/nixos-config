{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true; # 用 systemd-boot(EFI 机器推荐)
  boot.loader.efi.canTouchEfiVariables = true; # 允许安装器写 EFI 变量
  boot.loader.systemd-boot.configurationLimit = 15; # 启动菜单最多保留旧代个数

  # ── 内核 ────────────────────────────────────────────────────────────
  # 不写这一行时,内核由 nixpkgs 的 stable 系列决定(本仓库曾求值为 6.18.57 LTS)。
  # 想用更新的内核,就固定一个「系列」:
  #   linuxPackages_7_2 / _7_3 → 固定 7.2.x / 7.3.x
  #   linuxPackages_latest     → 跟着 nixpkgs 跳到最新主版本(不推荐:会悄悄跨大版本)
  # 固定系列的好处:只在 7.3.x 内升级补丁;等这个系列 EOL、nixpkgs 把它删掉时,
  # 求值会直接报错提醒你换一个,而不是某次更新后内核突然变了个大版本。
  #
  # ⚠️ 换内核必须验证独显:本机 GTX 1050 是 Pascal,只能用 nvidia legacy_580,
  #    已实测 580.178.04 能针对 7.3 编译出内核模块。如果 nvidia 模块构建失败,
  #    就退回上一个能用的系列(比如 6.18),否则会卡在构建或开机加载不了驱动。
  boot.kernelPackages = pkgs.linuxPackages_7_3;
}
