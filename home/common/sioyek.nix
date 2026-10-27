# sioyek 的用户侧配置。
#
# 包本身由系统侧 modules/packages/apps.nix 安装（大件 GUI 不进 home 闭包）。
# sioyek 从 ~/.config/sioyek/{prefs,keys}_user.config 读用户覆盖项，
# 和二进制装在哪无关，所以这里只挂配置文件，不装包。
#
# 为什么用文件级软链、而不是把整个 ~/.config/sioyek 目录链到仓库：
# 那个目录还混着运行时数据（shared.db 共享书签/高亮库、本地生成的
# sioyek-default.config）。目录级软链会把它们一起写进仓库，
# 造成 git 长期脏、二进制库可能被误提交。做法与 mango / niri / zed 一致。
#
# 配置不在 Nix store 里：改仓库文件就生效，不需要 `nh home switch`。
# 但 sioyek 没有配置热重载（包内 keys.config 的 reload 命令是重载文档），
# 改完要重启 sioyek 才会读到新值。
{
  config,
  ...
}:

let
  # 路径统一来自 my.repoDir（home/common/default.nix），不写死 ~/nixos-config。
  editableConfig = "${config.my.repoDir}/dotfiles/sioyek";
in
{
  xdg.configFile."sioyek/prefs_user.config".source =
    config.lib.file.mkOutOfStoreSymlink "${editableConfig}/prefs_user.config";
  xdg.configFile."sioyek/keys_user.config".source =
    config.lib.file.mkOutOfStoreSymlink "${editableConfig}/keys_user.config";
}
