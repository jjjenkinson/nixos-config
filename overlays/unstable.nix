# ════════════════════════════════════════════════════════════════════════
# unstable 包 overlay(与 unstable 相关的配置全部在这里)
#
# 这个文件负责三件事:
#   1. 从 nixpkgs-unstable 构造一个独立的 pkgs 实例
#   2. 维护“哪些包用 unstable”的名单
#   3. 返回标准 overlay 函数:final: prev: { ... }
#
# flake.nix 里只有一个可注释的 import:
#   overlays = [
#     (import ./overlays/unstable.nix {
#       inherit (inputs) nixpkgs nixpkgs-unstable;
#       inherit system;
#       config = pkgsConfig;
#     })
#   ];
#
# 注释掉那一行 = 完全回到 stable,不需要改任何安装文件;
# 因为安装文件里始终写的是 pkgs.google-chrome / pkgs.zed-editor。
# ════════════════════════════════════════════════════════════════════════
{
  nixpkgs, # stable 源,这里只用来取 lib
  nixpkgs-unstable, # unstable 源
  system, # 系统架构,如 x86_64-linux
  config, # nixpkgs.config(allowUnfree 等),与系统保持一致
}:

let
  lib = nixpkgs.lib;

  # unstable 实例:必须继承同一份 config,
  # 否则 chrome 这类非自由软件会再次报 unfree。
  pkgsUnstable = import nixpkgs-unstable {
    inherit system config;
  };

  # ← 唯一需要维护的地方:写 nixpkgs 里的顶层属性名。
  # 新增/移除 unstable 包时只改这个列表。
  names = [
    # "google-chrome"
    "zed-editor"
    "helix"
    # Niri 的桌面外壳(26.05 是 5.0.1,unstable 已是 5.3.0,上游迭代很快)
    "noctalia"
  ];
in
# 标准 overlay 签名:
#   final = 套用所有 overlay 之后的最终包集
#   prev  = 套用本条 overlay 之前的包集
# 这里不依赖它俩,只做“替换”:名单里的包取 unstable 版,
# 其余包及其依赖仍来自 stable,不会把整个系统切成 unstable。
_final: _prev: lib.genAttrs names (name: pkgsUnstable.${name})

# ── 嵌套路径(如 python3Packages.requests)────────────────────────────
# 上面的 names 只支持顶层属性名。嵌套包要在 overlay 里手写,
# 且必须先把上一层的 attrset 展开再合并,否则会把整片属性覆盖掉:
#
#   _final: _prev:
#     lib.genAttrs names (name: pkgsUnstable.${name})
#     // {
#       python3Packages = _prev.python3Packages // {
#         requests = pkgsUnstable.python3Packages.requests;
#       };
#     }
#
# ❌ 不能写成下面这样:overlay 与 prev 是浅合并(pkgs // overlay),
#    这会把整个 python3Packages 换成只有 requests 的集合,
#    其余 Python 包全部丢失:
#
#   { python3Packages = { requests = ...; }; }
#
# 另:stable 解释器 + unstable 包可能有依赖/ABI 不匹配。
# 想整套用 unstable 的 Python,更稳的做法是直接把整个属性换掉:
#
#   python3 = pkgsUnstable.python3;
