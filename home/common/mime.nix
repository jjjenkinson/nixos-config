# 默认应用关联:xdg-open、文件管理器双击、浏览器下载后「打开」都走这里。
#
# 只维护四个分类:
#   video     → 视频文件(mpv)
#   audio     → 音频文件(mpv)
#   browser   → 网页
#   directory → 目录(文件管理器,niri 的 Mod+E 也走它)
#
# 音频统一交给 mpv:它解码格式最全(mp3/flac/ogg/opus/wav/m4a/aac/wma/ape…),
# 不会出现“双击某个格式打不开”的情况。
#
# 注:kopuz 虽然装在了系统里,但上游的 desktop 文件既没有声明 MIME 类型,
# Exec 也不带 %f/%U 字段码——双击文件时它拿不到路径,所以不适合接文件关联。
#
# 注意:生成后的 ~/.config/mimeapps.list 是只读软链,
# 在桌面环境里临时改默认程序会被下次 `nh home switch` 覆盖。
{ config, lib, ... }:

let
  videoPlayer = "mpv.desktop";
  audioPlayer = "mpv.desktop";
  browser = "firefox.desktop";
  # 注意:desktop ID 就是文件名去掉 .desktop。
  # Dolphin 的文件叫 org.kde.dolphin.desktop,写成 dolphin.desktop 会指向不存在的程序,
  # 于是 inode/directory 会回退到 kitty 自带的 kitty-open.desktop。
  # 具体用哪个由 my.fileManager 决定(见下方 options),默认保持 Dolphin。
  fileManager = config.my.fileManager;

  videoMimes = [
    "video/mp4"
    "video/x-matroska"
    "video/mkv"
    "video/webm"
    "video/x-msvideo"
    "video/avi"
    "video/x-avi"
    "video/quicktime"
    "video/x-m4v"
    "video/mp4v-es"
    "video/mpeg"
    "video/mp2t"
    "video/ogg"
    "video/x-theora+ogg"
    "video/x-flv"
    "video/x-ms-wmv"
    "video/x-ms-asf"
    "video/3gpp"
    "video/3gpp2"
    "application/x-matroska"
    "application/x-extension-mp4"
  ];

  # 所有音频格式(含播放列表),统一用 mpv 打开
  audioMimes = [
    "audio/mpeg"
    "audio/mp3"
    "audio/x-mp3"
    "audio/flac"
    "audio/x-flac"
    "application/flac"
    "audio/ogg"
    "audio/x-vorbis+ogg"
    "application/ogg"
    "audio/x-ogg"
    "audio/opus"
    "audio/x-opus+ogg"
    "audio/wav"
    "audio/x-wav"
    "audio/x-wavpack"
    # 播放列表
    "audio/mpegurl"
    "audio/x-mpegurl"
    "audio/m3u"
    "audio/x-scpls"
    "audio/x-pls"
    "audio/scpls"
    # 下面这些以前 Tauon 解不了、单独回退给 mpv;现在统一了
    "audio/mp4"
    "audio/m4a"
    "audio/x-m4a"
    "audio/aac"
    "audio/x-aac"
    "audio/webm"
    "audio/x-matroska"
    "audio/x-ms-wma"
    "audio/x-ms-asf"
    "audio/ac3"
    "audio/eac3"
    "audio/x-ape"
    "audio/3gpp"
    "audio/AMR"
  ];

  webMimes = [
    "text/html"
    "application/xhtml+xml"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/chrome"
  ];

in
{
  # 默认文件管理器(决定 inode/directory 走谁,也就是双击目录 /
  # `xdg-open 目录` / niri 里绑定「打开文件管理器」的快捷键)。
  # 纯 niri、不装 KDE 的机器上别继续用 Dolphin:那样这个 desktop ID
  # 根本不存在,双击目录会什么都不发生。在 home/<用户>/default.nix 里覆盖成
  #   "thunar.desktop"   轻量 GTK(xfce 的 Thunar,pkgs.thunar)
  #   "nautilus.desktop" GNOME 的,依赖多一些(pkgs.nautilus)
  # 并在装它的那一侧(hosts/*/default.nix 或 home.packages)把程序装上。
  options.my.fileManager = lib.mkOption {
    type = lib.types.str;
    default = "org.kde.dolphin.desktop";
    description = "inode/directory 的默认程序(desktop ID,即文件名去掉 .desktop)";
  };

  # 注:本文件有顶层 options,其余配置必须写在显式 config 下。
  config.xdg.mimeApps = {
    enable = true;

    defaultApplications =
      lib.genAttrs videoMimes (_: videoPlayer)
      // lib.genAttrs audioMimes (_: audioPlayer)
      // lib.genAttrs webMimes (_: browser)
      // {
        # LX Music 只声明了这个 scheme;它面向在线音乐,不接管本地音频文件。
        "x-scheme-handler/lxmusic" = "lx-music-desktop.desktop";
        "inode/directory" = fileManager;
      };
  };
}
