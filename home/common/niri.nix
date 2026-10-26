# niri 的用户侧配置。
#
# 配置分两层:
#   - base.kdl  :由 niri 自带的默认配置生成(键位、输入、动画、布局),在 Nix store 里,
#                 随 niri 升级自动更新,平时不用管
#   - config.kdl:仓库里的 dotfiles/niri/config.kdl,通过 out-of-store 软链挂到
#                 ~/.config/niri/config.kdl
#
# 这样日常改配置只要编辑仓库里的 config.kdl 然后保存 —— 文件不在 store 里,
# niri 的 inotify 会立刻热重载,完全不需要 `nh home switch`。
{ config, pkgs, ... }:

let
  # 以 niri 自带的默认配置为基底,只做两处调整:
  #   1. 去掉默认 spawn 的 waybar(我们改用 noctalia)
  #   2. 默认 Mod+T 开 alacritty;本机终端是 kitty
  #
  # 为什么用 runCommand 而不是 builtins.readFile?
  #   readFile 在「求值阶段」读文件,如果 niri 的 doc 输出还没进 store 就直接报错;
  #   放到构建期执行,doc 输出就只是普通构建依赖,换机器/清过 store 也不会炸。
  niriBase = pkgs.runCommand "niri-base.kdl" { } ''
    sed -e '/^spawn-at-startup "waybar"/d' \
        -e 's/alacritty/kitty/g' \
      ${pkgs.niri.doc}/share/doc/niri/default-config.kdl > $out
  '';

  # 仓库里那份可编辑的配置(不在 store 里)。
  # 路径统一来自 my.repoDir(home/common/default.nix),
  # 不要在这里写死 ~/nixos-config —— 换目录名时只改选项默认值。
  editableConfig = "${config.my.repoDir}/dotfiles/niri/config.kdl";
  # 速查表统一放在 dotfiles/keybindings/（文件名 = 表名）,
  # 这里再软链一份到 ~/.config/niri/，方便手动查看。
  editableKeys = "${config.my.repoDir}/dotfiles/keybindings/niri.md";
in
{
  # Nix 管理的基底
  xdg.configFile."niri/base.kdl".source = niriBase;

  # 日常编辑的主配置:软链到仓库文件,改了就地生效
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink editableConfig;

  # 快捷键速查(Mod+Slash 走 `keys niri`,foot + fzf)。
  # 同 mango:放进 ~/.config/niri/ ,单纯留一份可手动打开的副本。
  xdg.configFile."niri/KEYS.md".source = config.lib.file.mkOutOfStoreSymlink editableKeys;
}
