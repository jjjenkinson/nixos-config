# mdpreviewer —— 把 Markdown / Typst 文件用浏览器实时预览的 CLI。
# 给编辑器（Helix、nvim 等没有内建预览的）当外部预览器用。
#
# 为什么不从 nixpkgs 装？
#   stable（26.05）和 unstable 里都没有这个包。
#
# 为什么不从 crates.io 源码构建？
#   它内嵌了 typst 编译器，依赖树很大，构建要十几分钟，还要维护 cargoHash；
#   而上游 release 已经提供自包含的 x86_64-linux 二进制（浏览器资源也编译进去了），
#   重新打包只有二十来行，和 pkgs/kopuz.nix 是同一套路。
#
# 升级步骤（上游发新 release 时）：
#   1. 改 version
#   2. curl -sL https://github.com/jkellz-dev/mdpreviewer/releases/download/v<版本>/mdpreviewer-v<版本>-x86_64-unknown-linux-gnu.tar.gz.sha256
#   3. nix hash convert --hash-algo sha256 --to sri <sha256>
#      → 用结果替换 hash
#   4. nh home switch
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mdpreviewer";
  version = "0.1.3";

  src = fetchurl {
    url = "https://github.com/jkellz-dev/mdpreviewer/releases/download/v${finalAttrs.version}/mdpreviewer-v${finalAttrs.version}-x86_64-unknown-linux-gnu.tar.gz";
    # 与上游同目录下的 .tar.gz.sha256 一致,可直接核对
    hash = "sha256-4sKW2Kc9dkVjjLSb6kObQoR1N5ekYAUi/kD0KyEGvRs=";
  };

  # 压缩包里是 mdpreviewer-v<版本>-x86_64-unknown-linux-gnu/ 一层目录
  sourceRoot = "mdpreviewer-v${finalAttrs.version}-x86_64-unknown-linux-gnu";

  # 上游是通用 Linux 构建:解释器指向 /lib64/ld-linux-x86-64.so.2。
  # 本机虽然开了 nix-ld 也能跑,但包本身应该自包含,所以照常改写到 store。
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ]; # libgcc_s / libstdc++

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 mdpreviewer $out/bin/mdpreviewer

    # 上游只随包带了这两份许可证,照装不额外补
    install -Dm644 LICENSE-MIT $out/share/licenses/mdpreviewer/LICENSE-MIT
    install -Dm644 LICENSE-APACHE $out/share/licenses/mdpreviewer/LICENSE-APACHE

    runHook postInstall
  '';

  meta = {
    description = "Live-reloading browser preview for Markdown and Typst files";
    homepage = "https://github.com/jkellz-dev/mdpreviewer";
    license = with lib.licenses; [
      asl20
      mit
    ];
    # 装的是上游预编译二进制,不是从源码构建
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mdpreviewer";
  };
})
