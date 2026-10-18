{
  config,
  lib,
  pkgs,
  ...
}:
{
  # # rime default.yaml 改名
  # # rime的候选词数量
  # home.file.".local/share/fcitx5/rime/default.custom.yaml".text = ''
  #   patch:
  #     __include: rime_ice_suggestion:/
  #     menu/page_size: 6
  # '';
  # # Rime 只按文件 mtime 判断配置有没有变，而 Nix store 里文件 mtime 恒为 1，
  # # 所以重建后必须删掉编译产物，否则改动静默不生效。
  # # 删整个 build 会连雾凇字典一起重编（几十秒，之后启动正常），但升级 nixpkgs
  # # 改了词库/schema 时只有它管用；只想覆盖 default.custom.yaml 的改动、要秒级的话，
  # # 把那行换成：run rm -f "$HOME/.local/share/fcitx5/rime/build/default.yaml"
  # home.activation.clearRimeBuild = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   run rm -rf "$HOME/.local/share/fcitx5/rime/build"
  # '';

  # 最贴合你的需求:`default.custom.yaml` 内容没变的开关机完全不做事,内容变了才清缓存。
  # 代价是它只覆盖这一个文件;哪天你想连 schema/词库一起重编(比如升级 nixpkgs 改了 rime-ice),
  # 那就手动 `rm -rf ~/.local/share/fcitx5/rime/build` 一次。
  home.file.".local/share/fcitx5/rime/default.custom.yaml" = {
    text = ''
      patch:
        # 引入雾凇拼音的默认设置(方案列表、快捷键、中西文切换等)。
        # nixpkgs 把上游 default.yaml 改名成了 rime_ice_suggestion.yaml,必须这样引入。
        __include: rime_ice_suggestion:/
        # 候选词个数
        menu/page_size: 7
        # 按 Shift:把已输入的拼音原样上屏为英文,并切到英文
        ascii_composer/switch_key/Shift_L: commit_code
        # 按 Shift:已输入的拼音作为英文字母留在输入框,进入临时西文模式,
        # 空格/回车确认上屏后自动回中文;未改动时再按 Shift 可还原中文
        ascii_composer/switch_key/Shift_R: inline_ascii
    '';
    onChange = ''
      rm -f "$HOME/.local/share/fcitx5/rime/build/default.yaml"
    '';
  };
}
