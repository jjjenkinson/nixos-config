# ════════════════════════════════════════════════════════════════════════
# unstable 包 overlay —— 与 unstable 相关的配置全部集中在这里。
#
# 职责:
#   1. 拿到 nixpkgs-unstable 的包集
#   2. 维护「哪些包用 unstable」的名单
#   3. 返回标准 overlay 函数:final: prev: { ... }
#
# 用法:flake.nix 里只有一处 import,注释掉它就回到纯 stable,
# 不需要改任何安装文件(包都写成 pkgs.xxx)。
# ════════════════════════════════════════════════════════════════════════
{
  nixpkgs, # stable 源,这里只取 lib
  nixpkgs-unstable, # unstable 源
  system, # 系统架构,如 x86_64-linux
  config, # 与主 pkgs 共用的 nixpkgs config(含 allowUnfree)
}:

let
  lib = nixpkgs.lib;

  # unstable 实例。
  #
  # 为什么不用 legacyPackages:它用的是 nixpkgs 默认 config(allowUnfree = false),
  # 而下面的 wechat 是 unfree 包,会直接报“unfree license”。
  # 所以这里 import 一遍,并把主 pkgs 的 config 原样传进去(flake.nix 里的 pkgsConfig)。
  pkgsUnstable = import nixpkgs-unstable {
    inherit system config;
  };

  # ← 唯一需要维护的地方:nixpkgs 里的顶层属性名。
  names = [
    "zed-editor"
    # "helix"  # unstable版本与stable差不多
    "noctalia" # Niri 的桌面外壳,上游迭代很快

    # 微信 Linux 原生版(腾讯官方 AppImage)。unfree,所以上面必须传 config。
    # stable 4.1.1.4 → unstable 4.1.13.26,差了很多个小版本。
    "wechat"

    # Wayland 合成器。注意两个通道的命名差异:
    #   属性名(overlay 的键):两个通道都叫 mangowc → 必须写 "mangowc"
    #   包名(pname)        :stable 叫 mangowc-0.12.8,unstable 叫 mango-0.18.2
    #                          (unstable 里还有 mango 这个别名属性,不要用它,
    #                           因为 nixpkgs 的 programs.mangowc 模块找的是 pkgs.mangowc)
    "mangowc"
  ];
in
# 标准 overlay 签名。这里不依赖 final/prev,只做「替换」:
# 名单里的包取 unstable 版,其余包及其依赖仍来自 stable。
_final: _prev: lib.genAttrs names (name: pkgsUnstable.${name})

# ── 嵌套路径(如 python3Packages.requests)─────────────────────────────
# names 只支持顶层属性名。嵌套包要手写,且必须先把上一层展开再合并,
# 否则会把整片属性覆盖掉:
#
#   _final: _prev:
#     lib.genAttrs names (name: pkgsUnstable.${name})
#     // {
#       python3Packages = _prev.python3Packages // {
#         requests = pkgsUnstable.python3Packages.requests;
#       };
#     }
#
# ❌ 不能写成 { python3Packages = { requests = ...; }; } —— overlay 是浅合并,
#    整个 python3Packages 会被换成只剩 requests 的集合。
#
# 另:stable 解释器 + unstable 包可能有 ABI 不匹配;
# 想整套用 unstable 的 Python,更稳的做法是直接换掉整个属性:
#   python3 = pkgsUnstable.python3;
