# 系统基础模块的汇总入口:hosts/ 只需要 import 这个目录。
# 新增文件时,在这里加一行 import。
{ ... }:

{
  imports = [
    ./nix.nix # nix 本体设置 + nh
    ./base.nix # 基础设置，音频，蓝牙，网络
    ./boot.nix # 引导
    ./btrfs.nix # btrfs 策略(scrub / fstrim / 快照)
    ./locale.nix # 时区 / 语言 / 主目录规范
  ];
}
