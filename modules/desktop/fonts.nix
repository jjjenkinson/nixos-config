# 字体与 fontconfig 默认字体。
{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true; # 在 /run/current-system/sw/share/X11/fonts 中暴露字体目录

    packages = with pkgs; [
      # 英文
      noto-fonts
      inter
      libertinus

      # 中文
      lxgw-wenkai
      lxgw-neoxihei
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # 等宽(带 Nerd Font 图标,终端/编辑器都用它)
      maple-mono.NF-CN

      # emoji
      noto-fonts-color-emoji
    ];

    # 每个字族按顺序回退:英文优先,中文兜底。
    fontconfig.defaultFonts = {
      serif = [
        "Libertinus"
        "Liberation Serif"
        "LXGW WenKai"
        "Noto Serif CJK SC"
      ];
      sansSerif = [
        "Inter"
        "Liberation Sans"
        "LXGW Neo XiHei"
        "Noto Sans CJK SC"
      ];
      monospace = [
        "Maple Mono NF CN"
        "Liberation Mono"
        "Noto Sans Mono CJK SC"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
