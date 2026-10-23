# 用户 XXXX 的个人设置(占位模板)。
#
# 目录名必须与 flake.nix 主机表里对应主机的 user 一致:
#   HHHH = { user = "XXXX"; }
# flake 会挂载整个 home/XXXX 目录(自动加载 default.nix)。
# 实际使用前把目录名、用户名、下面的身份一起改成真的。
#
# 这个用户专属的配置变多时,在本目录下拆成多个 .nix,再在 imports 里列出:
#
#   imports = [ ./git.nix ./shell.nix ./apps.nix ];
#
# 不要在这里重复 home/common 已经写过的配置 —— 只需要覆盖想让这个用户不同的项。
{ pkgs, ... }:

{
  # git 提交身份;GitHub 关联贡献需要邮箱与账号一致。
  my.git = {
    userName = "XXXX";
    userEmail = "XXXX@example.com"; # ← 占位,请替换
  };

  # 默认编辑器(写入 EDITOR / VISUAL / SUDO_EDITOR)。
  # 可选值就是 PATH 里的命令,例如 "hx"、"nvim"、"vim"。
  my.editor = "nvim";

  # 这台机器只装 Niri、不装 KDE,所以不能指向 Dolphin(它不存在)。
  # 「用哪个文件管理器」和「把它装上」都放在用户这一层,两者不会分家。
  my.fileManager = "thunar.desktop";
  home.packages = [ pkgs.thunar ];
}
