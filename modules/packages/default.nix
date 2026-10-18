# 系统级软件包:所有用户都能用的“命令行基础设施”。
# 个人日常软件放到 home/jiro/default.nix 的 home.packages ——
# 独立模式下改那里不需要 sudo、也不用重建系统。
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    wget
    wl-clipboard # Wayland 剪贴板工具(wl-copy / wl-paste)
  ];
}
