# Rime(雾凇拼音)的覆盖配置。
#
# 为什么用 default.custom.yaml 而不是直接改 default.yaml:
#   雾凇的默认值来自 rime-ice,升级 nixpkgs 会变;这里只写要覆盖的键。
#
# 为什么要 onChange 删 build/default.yaml:
#   Rime 只按 mtime 判断配置是否变化,而 Nix store 里文件的 mtime 恒为 1。
#   不删编译产物,改了配置也不会生效。只删 default.yaml 是秒级方案;
#   升级 rime-ice 词库后需要手动清整个 build:
#     rm -rf ~/.local/share/fcitx5/rime/build
{ ... }:

{
  home.file.".local/share/fcitx5/rime/default.custom.yaml" = {
    text = ''
      patch:
        # nixpkgs 把上游 default.yaml 改名成了 rime_ice_suggestion.yaml
        __include: rime_ice_suggestion:/
        menu/page_size: 7

        # 左 Shift:已输入的拼音原样上屏为英文,并切到英文
        ascii_composer/switch_key/Shift_L: commit_code
        # 右 Shift:已输入的拼音留在输入框,进入临时西文模式;
        # 空格/回车确认后回中文,未改动时再按 Shift 可还原
        ascii_composer/switch_key/Shift_R: inline_ascii
    '';

    onChange = ''
      rm -f "$HOME/.local/share/fcitx5/rime/build/default.yaml"
    '';
  };
}
