# FlClash —— 基于 ClashMeta 的代理客户端(GUI)。
#
# 为什么不直接用 nixpkgs?
#   stable(nixos-26.05)是 0.8.92;unstable 里这个包已被移除
#   (all-packages 直接 throw "removed due to low number of users and lack of
#   maintenance"),overlay 也拿不到。
#
# 为什么不从源码构建?
#   上游用 Flutter + Go,nixpkgs 那份表达式需要 flutter335、pubspec.lock.json、
#   git-hashes.json、Go vendorHash,每升一版都要重新生成两个锁文件。
#   官方 release 同时提供 .deb,里面已经是编译好的 Flutter bundle + ClashCore,
#   重新打包只改 version 和 hash 两行,和 pkgs/kopuz.nix 是同一套路。
#
# .deb 内容(dpkg-deb -c 可查,0.9.2):
#   opt/FlClash/FlClash               Flutter 启动器(动态链接 GTK3)
#   opt/FlClash/FlClashCore           Clash 内核(静态)
#   opt/FlClash/FlClashHelperService  TUN/提权辅助进程
#   opt/FlClash/lib/                  引擎与插件 .so
#   opt/FlClash/data/                 Flutter assets(图标、geo 数据等)
#   usr/share/applications/FlClash.desktop
#   usr/share/icons/hicolor/{128x128,256x256}/apps/FlClash.png
#   ⚠️ 没有 usr/bin,所以必须自己在 $out/bin 里造一个入口。
#
# 升级步骤(上游发新 release 时):
#   1. 改下面的 version
#   2. nix store prefetch-file --json \
#        https://github.com/chen08209/FlClash/releases/download/v<版本>/FlClash-<版本>-linux-amd64.deb
#      用输出里的 hash 替换(也可以对照 release 里的 SHA256SUMS)
#   3. sudo nh os switch
{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  # ── 运行时链接库(autoPatchelfHook 自动补 RPATH)──────────────
  gtk3, # libgtk-3 / libgdk-3 / pango / cairo / gdk-pixbuf / atk
  glib, # libgio / libgobject / libglib
  harfbuzz,
  libepoxy, # Flutter GTK 后端直接依赖
  fontconfig,
  libx11,
  # ── 托盘 ────────────────────────────────────────────────────
  # libtray_plugin.so 的 NEEDED 里有 libayatana-appindicator3.so.1。
  # 它是链接依赖(不是 dlopen),所以放 buildInputs 就够。
  libayatana-appindicator,
  libayatana-indicator,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flclash";
  version = "0.9.2";

  src = fetchurl {
    url = "https://github.com/chen08209/FlClash/releases/download/v${finalAttrs.version}/FlClash-${finalAttrs.version}-linux-amd64.deb";
    # 与 release 里的 SHA256SUMS 一致,可核对
    hash = "sha256-xso3RG25K1cwnRxwn7piCfLGebbTPPx0j3O46xpZpug=";
  };

  nativeBuildInputs = [
    dpkg # 提供 dpkg-deb,用来解 .deb
    autoPatchelfHook
    makeWrapper
  ];

  # stdenv 不认识 .deb,手动展开到当前目录
  unpackCmd = "dpkg-deb -x $curSrc source";

  buildInputs = [
    gtk3
    glib
    harfbuzz
    libepoxy
    fontconfig
    libx11
    libayatana-indicator
    libayatana-appindicator
    stdenv.cc.cc.lib # libstdc++.so.6 / libgcc_s.so.1
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # 保持上游的 /opt/FlClash 目录结构:程序按可执行文件旁边的
    # lib/ 和 data/ 找引擎与 resources,不能拆散。
    mkdir -p $out/opt
    cp -r opt/FlClash $out/opt/

    # libdartjni.so 是 Android 的 JNI 插件,Linux 上不会加载,
    # 但它 NEEDED libjvm.so —— 留着就得把整个 JDK 拖进闭包。
    # 主程序 FlClash 的 strings 里也没有它的引用,删掉是安全的。
    rm -f $out/opt/FlClash/lib/libdartjni.so

    # .deb 不自带 usr/bin,desktop 文件却写 Exec=FlClash,
    # 所以补一个同名入口;LD_LIBRARY_PATH 让插件能 dlopen 同目录的 .so。
    makeWrapper $out/opt/FlClash/FlClash $out/bin/FlClash \
      --prefix LD_LIBRARY_PATH : $out/opt/FlClash/lib

    install -Dm644 usr/share/applications/FlClash.desktop \
      $out/share/applications/FlClash.desktop
    install -Dm644 usr/share/icons/hicolor/128x128/apps/FlClash.png \
      $out/share/icons/hicolor/128x128/apps/FlClash.png
    install -Dm644 usr/share/icons/hicolor/256x256/apps/FlClash.png \
      $out/share/icons/hicolor/256x256/apps/FlClash.png

    runHook postInstall
  '';

  meta = {
    description = "Proxy client based on ClashMeta, simple and easy to use";
    homepage = "https://github.com/chen08209/FlClash";
    license = lib.licenses.gpl3Plus;
    # 装的是上游预编译二进制,不是从源码构建
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "FlClash";
  };
})
