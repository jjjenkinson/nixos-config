# Kopuz —— Rust + Dioxus 写的 YouTube Music 客户端。
#
# 为什么不从 nixpkgs 装?
#   nixpkgs(stable 和 unstable)里都没有这个包。
#
# 为什么不用 Flathub?
#   1. Flathub 版本落后上游一版(v0.22.0 发布时 Flathub 还是 0.21.0);
#   2. Flathub 要额外拉 GNOME runtime(约 400 MB),国内下载很容易卡住,
#      而且首次安装会拖慢系统激活流程。
# 反过来看,官方 .deb 里只有「一个自包含二进制 + desktop + 图标」,
# 依赖库 nixpkgs 全都有,重新打包只有几十行,所以走本地方案更划算。
#
# .deb 内容(用 dpkg-deb -c 可查):
#   usr/bin/kopuz                                     约 110 MB(前端资源内嵌在二进制里)
#   usr/share/applications/kopuz.desktop
#   usr/share/icons/hicolor/{256x256,440x440}/apps/kopuz.png
#
# 它是普通动态链接程序,所以:
#   - autoPatchelfHook:把解释器和 RPATH 改写到 Nix store
#   - wrapGAppsHook3:启动时准备好 GTK 主题、图标、gsettings schema
#
# 升级步骤(上游发新 release 时):
#   1. 改下面的 version
#   2. nix store prefetch-file --json https://github.com/Kopuz-org/kopuz/releases/download/v<版本>/kopuz_<版本>_amd64.deb
# → 用输出里的 hash 替换(也可以直接看官方 .deb.sha256 文件)
#   3. sudo nh os switch
{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  # ── 运行时链接库(由 autoPatchelfHook 自动补 RPATH)──────────────
  alsa-lib, # 音频输出
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  libsoup_3,
  openssl, # libssl / libcrypto
  wayland, # libwayland-client
  webkitgtk_4_1, # 内嵌页面(WebView UI)
  xdotool, # libxdo.so.3,媒体键
  # ── 运行时数据(不参与链接,但缺了界面会变丑/报 schema 错)──────
  adwaita-icon-theme,
  gsettings-desktop-schemas,

  # ── 托盘(运行时 dlopen,不属于链接依赖)────────────────
  libayatana-appindicator,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kopuz";
  version = "0.22.0";

  src = fetchurl {
    url = "https://github.com/Kopuz-org/kopuz/releases/download/v${finalAttrs.version}/kopuz_${finalAttrs.version}_amd64.deb";
    # 与官方 kopuz_<版本>_amd64.deb.sha256 一致,可直接核对
    hash = "sha256-+Y76pRuNExXuBXT48jVI/GMboQ3SFJpqEH++FAI7t60=";
  };

  nativeBuildInputs = [
    dpkg # 提供 dpkg-deb,用来解 .deb
    autoPatchelfHook
    wrapGAppsHook3
  ];

  # stdenv 不认识 .deb,手动展开到当前目录
  unpackCmd = "dpkg-deb -x $curSrc source";

  buildInputs = [
    alsa-lib
    cairo
    gdk-pixbuf
    glib
    gtk3
    libsoup_3
    openssl
    wayland
    webkitgtk_4_1
    xdotool
    adwaita-icon-theme
    gsettings-desktop-schemas
    stdenv.cc.cc.lib # libstdc++.so.6 / libgcc_s.so.1
  ];

  dontConfigure = true;
  dontBuild = true;

  # 托盘图标:上游用 libappindicator 在**运行时** dlopen
  # libayatana-appindicator3.so.1(找不到再试 libappindicator3.so.1)。
  # 这类库不会出现在 ELF 的 NEEDED 里,autoPatchelfHook 默认看不见,
  # 只写进 buildInputs 是没用的;必须用 runtimeDependencies 告诉它
  # 「这个路径也要进 RPATH」,dlopen 才能找到。
  # 缺了它的表现:Kopuz 只打一行 “Failed to build tray icon”,
  # “最小化到托盘”退化成关闭窗口 = 直接退出。
  runtimeDependencies = [ libayatana-appindicator ];

  installPhase = ''
    runHook preInstall

    # desktop 文件里写的是 Exec=kopuz,所以二进制要留在 bin/ 下同名
    install -Dm755 usr/bin/kopuz $out/bin/kopuz

    install -Dm644 usr/share/applications/kopuz.desktop \
      $out/share/applications/kopuz.desktop

    # 上游只带了这两个尺寸,照装即可
    for size in 256x256 440x440; do
      install -Dm644 "usr/share/icons/hicolor/$size/apps/kopuz.png" \
        "$out/share/icons/hicolor/$size/apps/kopuz.png"
    done

    runHook postInstall
  '';

  meta = {
    description = "Music player for YouTube Music, built with Rust and Dioxus";
    homepage = "https://github.com/Kopuz-org/kopuz";
    license = lib.licenses.eupl12;
    # 装的是上游预编译二进制,不是从源码构建
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "kopuz";
  };
})
