# Helix。版本由 overlays/unstable.nix 决定(不写 package 即 pkgs.helix)。
# 设为默认编辑器由 home/common/default.nix 的 EDITOR/VISUAL 负责。
#
# 配置内容在 dotfiles/helix/,这里只建软链:
# 改配置不需要 `nh home switch`,在 Helix 里执行 :config-reload 即可。
#
# ⚠️ 不要再写 programs.helix.settings / languages:
#    一旦写了,Home Manager 会生成同名的 store 文件,把软链顶掉。
{
  config,
  pkgs,
  lib,
  ...
}:

let
  dotfiles = "${config.my.repoDir}/dotfiles/helix";

  # 软链变化时通知正在运行的 Helix 重载配置(SIGUSR1)。
  # 内容改动不会触发这一行(软链本身没变),那种情况用 :config-reload。
  onChange = "${lib.getExe' pkgs.procps "pkill"} -USR1 -u $USER -x '(hx|\\.hx-wrapped)' || true";
in
{
  programs.helix.enable = true;

  xdg.configFile = {
    "helix/config.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config.toml";
      inherit onChange;
    };
    "helix/languages.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/languages.toml";
      inherit onChange;
    };
  };
}
