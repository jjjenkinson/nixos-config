# 默认应用关联:xdg-open、文件管理器双击、浏览器下载后「打开」都走这里。
#
# 只维护五个分类:
#   video     → 视频文件(mpv)
#   audio     → 音频文件(mpv)
#   image     → 图片(gwenview 或 swayimg,随 Plasma 开关)
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
{
  config,
  lib,
  plasma,
  ...
}:

let
  videoPlayer = "mpv.desktop";
  audioPlayer = "mpv.desktop";
  browser = "firefox.desktop";
  # 图片查看器:有 Plasma 用随附的 gwenview,没有则用 swayimg
  # (由 home/common/default.nix 在 !plasma 时安装)。
  # 两边都有查看器,所以下面无条件写关联;若像以前那样只在有 Plasma 时写,
  # 没有 KDE 的机器双击图片会退回系统默认(通常什么都没装)。
  # ⚠️ swayimg 自带的 desktop 文件带 NoDisplay=true:关联能正常工作,
  # 只是应用菜单里看不到。需要菜单可见得自己覆盖一份 desktop 文件。
  imageViewer = if plasma then "org.kde.gwenview.desktop" else "swayimg.desktop";
  # 注意:desktop ID 就是文件名去掉 .desktop。
  # Dolphin 的文件叫 org.kde.dolphin.desktop,写成 dolphin.desktop 会指向不存在的程序,
  # 于是 inode/directory 会回退到 kitty 自带的 kitty-open.desktop。
  # 具体用哪个由 my.fileManager 决定(见下方 options),默认值随 Plasma 开关变化。
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

  # 常见图片格式。列表写成精确 MIME,mimeapps.list 不支持 image/* 通配。
  imageMimes = [
    "image/png"
    "image/jpeg"
    "image/gif"
    "image/webp"
    "image/avif"
    "image/bmp"
    "image/x-bmp"
    "image/tiff"
    "image/svg+xml"
    "image/x-icon"
    "image/vnd.microsoft.icon"
    "image/heic"
    "image/heif"
    "image/jxl"
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
  # 有 Plasma 就用它自带的 Dolphin;没有则由 home/common/default.nix 装上
  # Thunar。两边的 plasma 都来自 flake.nix 主机表的同一个字段,
  # 不会出现「关联了却没装」的情况。
  # 想换别的文件管理器,在 home/<用户>/default.nix 覆盖成
  #   "nautilus.desktop"   GNOME 的,依赖多一些(pkgs.nautilus)
  # 并自己把程序装上。
  options.my.fileManager = lib.mkOption {
    type = lib.types.str;
    default = if plasma then "org.kde.dolphin.desktop" else "thunar.desktop";
    description = "inode/directory 的默认程序(desktop ID,即文件名去掉 .desktop)";
  };

  # 注:本文件有顶层 options,其余配置必须写在显式 config 下。
  config.xdg.mimeApps = {
    enable = true;

    defaultApplications =
      lib.genAttrs videoMimes (_: videoPlayer)
      // lib.genAttrs audioMimes (_: audioPlayer)
      // lib.genAttrs imageMimes (_: imageViewer)
      // lib.genAttrs webMimes (_: browser)
      // {
        # LX Music 只声明了这个 scheme;它面向在线音乐,不接管本地音频文件。
        "x-scheme-handler/lxmusic" = "lx-music-desktop.desktop";
        "inode/directory" = fileManager;
      };
  };
}
