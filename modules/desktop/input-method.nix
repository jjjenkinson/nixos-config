# 输入法:fcitx5 + Rime 雾凇拼音。
{ pkgs, ... }:

{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;

    fcitx5 = {
      # Wayland 下走 text-input 协议(Niri / Plasma 都能用)。
      waylandFrontend = true;

      addons = with pkgs; [
        fcitx5-gtk
        kdePackages.fcitx5-qt
        kdePackages.fcitx5-configtool
        catppuccin-fcitx5 # 主题

        # Rime 本体 + 雾凇拼音词库
        (fcitx5-rime.override {
          rimeDataPkgs = [ rime-ice ];
        })

        # 拼音/双拼等方案与额外词库(平时用 Rime,留着不影响)
        qt6Packages.fcitx5-chinese-addons
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
      ];

      settings.addons.classicui.globalSection = {
        Font = "Maple Mono NF CN 13"; # 候选词
        MenuFont = "Maple Mono NF CN 13"; # 右键菜单
      };
    };
  };
}
