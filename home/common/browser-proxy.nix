# Chromium 系浏览器的自动代理（Chrome / Edge）。
#
# 为什么需要这个文件：
#   Chrome / Edge 在 Linux 上只从 GNOME（gsettings）或 KDE（kioslaverc）读
#   「系统代理」，靠 XDG_CURRENT_DESKTOP 判断桌面环境。niri / mango 不在支持
#   列表里，浏览器于是提示「你的系统可能不受支持」，然后回退到环境变量——
#   而本仓库的代理变量只在 `proxy_on` 时存在于当前 shell，从菜单启动的浏览器
#   拿不到它们，等于完全不经过代理。
#
# 做法：不改系统代理，也不常开代理变量，只给 .desktop 的 Exec 包一层启动器：
#   127.0.0.1:7890 在监听（flclash 开着） → 加 --proxy-server
#   不在监听（flclash 关了）              → 原样启动，直连
#   这样浏览器自动跟随 flclash 的开关，flclash 没开时也不会把浏览器弄断网。
#
# 为什么覆盖 .desktop 而不是改包：
#   包里的 .desktop 直接写死了 store 里的二进制路径；改包等于重打包几百 MB 的
#   浏览器。把改好的文件放 ~/.local/share/applications，优先级高于
#   /run/current-system 和 ~/.nix-profile，而且只在 Exec 行前加一个词，
#   图标 / MIME / Actions / NoDisplay 全部沿用上游文件，升级不会漂移。
#
# 注意：浏览器已经在运行时，新传入的 --proxy-server 会被忽略（Chrome 会把 URL
#       转给旧进程）。切换代理状态后要完全退出浏览器再打开。
{ pkgs, ... }:

let
  # 与 home/common/shell.nix 里 proxy_on / proxy_off 的地址保持一致。
  host = "127.0.0.1";
  port = 7890;
  url = "http://${host}:${toString port}";

  # $1 是真正的浏览器二进制，其余参数原样转发。
  # 用 bash 内建的 /dev/tcp 只探端口，不额外依赖 curl / ss；
  # 探测放在子 shell 里，失败时不会因 set -e 退出，fd 也随子 shell 关掉。
  launcher = pkgs.writeShellScript "browser-proxy" ''
    set -eu
    bin=$1
    shift

    flags=()
    if (exec 3<>/dev/tcp/${host}/${toString port}) 2>/dev/null; then
      flags+=(--proxy-server=${url})
    fi

    exec "$bin" "''${flags[@]}" "$@"
  '';

  # 复制上游 .desktop，把 Exec 的绝对路径换成命令名：
  #   Exec=/nix/store/…-google-chrome/bin/google-chrome-stable %U
  #   → Exec=<launcher> google-chrome-stable %U
  # 这样生成的 .desktop 里不含浏览器包的 store 路径，Chrome 就不会被算进
  # home 闭包（保留绝对路径时实测多 444 MiB）。命令名由会话 PATH 解析，
  # 系统 profile / ~/.nix-profile 本来就在 PATH 里。
  # 只匹配行首的 Exec=，不会误伤 TryExec=。
  proxied =
    name: package: file:
    pkgs.runCommand "${name}-${file}" { } ''
      ${pkgs.gnused}/bin/sed -E \
        -e 's|^Exec=[^ ]*/bin/|Exec=${launcher} |' \
        ${package}/share/applications/${file} > $out
    '';
in
{
  # 两个文件名都来自上游包：桌面菜单用普通名，反向域名那份 NoDisplay=true，
  # 但「用其他程序打开 / gio launch」会按它查找，所以一起覆盖。
  xdg.dataFile = {
    "applications/google-chrome.desktop".source =
      proxied "google-chrome" pkgs.google-chrome
        "google-chrome.desktop";
    "applications/com.google.Chrome.desktop".source =
      proxied "google-chrome-dbus" pkgs.google-chrome
        "com.google.Chrome.desktop";

    "applications/microsoft-edge.desktop".source =
      proxied "microsoft-edge" pkgs.microsoft-edge
        "microsoft-edge.desktop";
    "applications/com.microsoft.Edge.desktop".source =
      proxied "microsoft-edge-dbus" pkgs.microsoft-edge
        "com.microsoft.Edge.desktop";
  };
}
