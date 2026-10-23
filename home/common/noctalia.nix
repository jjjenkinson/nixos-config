# Noctalia 桌面外壳(由 niri 在登录后启动,见 home/common/niri.nix)。
#
# 配置管理方式(官方文档「How configuration works」+ 5.3.0 实测):
#   - ~/.config/noctalia/00-nix.toml  → 仓库里那份文件(out-of-store 软链),
#     保存即热重载(配置目录和 settings.toml 都被监听),不需要 rebuild,
#     也不需要手动执行命令(`noctalia msg config-reload` 只是兜底)
#   - ~/.local/state/noctalia/settings.toml 由 noctalia 自己写(设置界面),
#     优先级更高,会覆盖上面文件里的同名键
#   - noctalia 「永远不会重写」~/.config/noctalia/ 下的文件(包括版本迁移),
#     所以这里的软链和文件名都是稳定的
{ config, pkgs, ... }:

let
  # 路径统一来自 my.repoDir(home/common/default.nix),换目录名时只改选项默认值。
  editableConfig = "${config.my.repoDir}/dotfiles/noctalia/00-nix.toml";
in
{
  # 版本由 overlays/unstable.nix 决定(走 unstable)
  home.packages = [ pkgs.noctalia ];

  xdg.configFile."noctalia/00-nix.toml".source = config.lib.file.mkOutOfStoreSymlink editableConfig;
}
