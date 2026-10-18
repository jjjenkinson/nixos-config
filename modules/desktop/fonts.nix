{ config, lib, pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true; # 在/run/current-system/sw/share/X11/fonts中显示字体目录
    packages = with pkgs; [
      # 英文字体
      noto-fonts
      inter
      libertinus

      # 中文字体
      lxgw-wenkai
      lxgw-neoxihei
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # 等宽字体
      maple-mono.NF-CN

      # emoji
      noto-fonts-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Libertinus" "Liberation Serif" "LXGW WenKai" "Noto Serif CJK SC" ];
        sansSerif = [ "Inter" "Liberation Sans" "LXGW Neo XiHei" "Noto Sans CJK SC" ];
        monospace = [ "Maple Mono NF CN" "Liberation Mono" "Noto Sans Mono CJK SC" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
