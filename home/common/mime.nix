# 默认应用关联:xdg-open、文件管理器双击、浏览器下载后「打开」都走这里。
#
# 只维护三个分类:
#   video   → 视频文件
#   music   → 音乐文件(Tauon)
#   browser → 网页
#
# Tauon 使用 mp3/flac/ogg/opus/wav/wavpack 等解码库,不支持
# m4a/aac/wma/ac3/ape 等格式;这些继续交给 mpv,避免双击后打不开。
#
# 注意:生成后的 ~/.config/mimeapps.list 是只读软链,
# 在桌面环境里临时改默认程序会被下次 `nh home switch` 覆盖。
{ lib, ... }:

let
  videoPlayer = "mpv.desktop";
  musicPlayer = "tauonmb.desktop";
  musicFallback = "mpv.desktop";
  browser = "firefox.desktop";

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

  # Tauon 实际能解码的常见音乐格式(见它的 buildInputs 与 desktop 文件)
  musicMimes = [
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
  ];

  # Tauon 不支持的音频格式,回退到 mpv
  otherAudioMimes = [
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
  xdg.mimeApps = {
    enable = true;

    defaultApplications =
      lib.genAttrs videoMimes (_: videoPlayer)
      // lib.genAttrs musicMimes (_: musicPlayer)
      // lib.genAttrs otherAudioMimes (_: musicFallback)
      // lib.genAttrs webMimes (_: browser)
      // {
        # LX Music 只声明了这个 scheme;它面向在线音乐,不接管本地音频文件。
        "x-scheme-handler/lxmusic" = "lx-music-desktop.desktop";
      };
  };
}
