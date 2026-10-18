{
  config,
  lib,
  pkgs,
  ...
}:

{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk
        catppuccin-fcitx5
        kdePackages.fcitx5-qt
        kdePackages.fcitx5-configtool
        fcitx5-pinyin-moegirl # 萌娘百科词库（可选）
        fcitx5-pinyin-zhwiki # 中文维基百科词库（可选）
        (fcitx5-rime.override {
          rimeDataPkgs = [
            rime-ice # 雾凇拼音核心词库
          ];
        })
      ];
      settings.addons.classicui.globalSection = {
        Font = "Maple Mono NF CN 13"; # 候选词字体 + 字号
        MenuFont = "Maple Mono NF CN 13"; # 右键菜单字体
      };
    };
  };

}
