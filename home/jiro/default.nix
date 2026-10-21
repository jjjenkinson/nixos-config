# jiro 的个人设置。
#
# 目录名必须与 flake.nix 主机表里的 user 一致:
#   XPS9560 = { user = "jiro"; }
# flake 会挂载整个 home/jiro 目录(自动加载 default.nix)。
#
# 以后 jiro 专属的配置变多时,在本目录下拆成多个 .nix,
# 再在 imports 里列出来即可,不会影响其他用户:
#
#   imports = [ ./git.nix ./shell.nix ];
{ ... }:

{
  # git 提交身份;GitHub 关联贡献需要邮箱与账号一致。
  my.git = {
    userName = "jiro";
    userEmail = "chjxg3@163.com";
  };

  # 默认编辑器(EDITOR / VISUAL / SUDO_EDITOR)。
  my.editor = "hx";

  # 双显卡:NVIDIA(gpu0)+ Intel 核显(gpu1)。
  my.btop.gpuCount = 2;
}
