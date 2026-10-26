# MangoWC 的用户侧配置(按键、外观、启动项)。
#
# mango 按固定顺序找配置(源码 src/config/load.c):
#   ~/.config/mango/config.conf → ~/.config/mango/config.toml
#   → /etc/mango/config.conf    → /etc/mango/config.toml
# 所以只要把 config.conf 放到 ~/.config/mango/ 即可,不需要 -c 参数。
#
# 和 niri / noctalia 一样的做法:软链到仓库里的 dotfiles,配置不在 Nix store 里。
# mango 自带 auto_reload_config=1(默认就是开的),保存文件即热重载,
# 改键位/颜色不需要 `nh home switch`。
#
# 包本身由系统侧的 modules/desktop/mango.nix 安装(programs.mangowc),
# 这里只管配置文件和截图工具。
{
  config,
  pkgs,
  ...
}:

let
  # 路径统一来自 my.repoDir(home/common/default.nix),不写死 ~/nixos-config。
  editableConfig = "${config.my.repoDir}/dotfiles/mango/config.conf";
  # 速查表统一放在 dotfiles/keybindings/（文件名 = 表名）。
  editableKeys = "${config.my.repoDir}/dotfiles/keybindings/mango.md";

  # 截图脚本(被 config.conf 里的 Super+P / Super+Ctrl+P 调用)。
  # 放在 home 侧是为了只靠 `nh home switch` 就能生效(不需要 sudo)。
  #
  #   mango-shot region  选区 → satty 标注 → 回车保存并复制到剪贴板
  #   mango-shot full    整屏 → 直接保存并复制
  #
  # satty 的按键:回车 = save-to-clipboard + save-after-copy(存盘 + 进剪贴板);
  # Esc = 退出(文件保留未经标注的原始截图)。
  screenshot = pkgs.writeShellScriptBin "mango-shot" ''
    set -eu
    dir="$HOME/Pictures/Screenshots"
    file="$dir/prtScr$(date +%Y%m%d-%H%M%S).png"
    mkdir -p "$dir"

    case "''${1:-region}" in
      region)
        region=$(slurp) || exit 0
        [ -n "$region" ] || exit 0
        grim -g "$region" "$file"
        satty \
          --filename "$file" \
          --output-filename "$file" \
          --actions-on-enter save-to-clipboard \
          --save-after-copy \
          --copy-command wl-copy \
          --early-exit
        ;;
      full)
        grim "$file"
        wl-copy < "$file"
        ;;
      *)
        echo "用法: mango-shot [region|full]" >&2
        exit 2
        ;;
    esac
  '';
  # 切换平铺算法 + 弹出当前算法名。
  # mango 本身没有 OSD;但 `mmsg get tags` 能查到当前 tag 的 layout 符号,
  # `mmsg get layouts` 能查到符号对应的名字,再用 noctalia 弹个通知。
  layoutCycle = pkgs.writeShellScriptBin "mango-layout" ''
    set -u
    mmsg dispatch switch_layout || exit 1

    # 当前焦点窗口所在的显示器(没有窗口时退回到第一块显示器)
    mon=$(mmsg get focusing-client 2>/dev/null | sed -n 's/.*"monitor":"\([^"]*\)".*/\1/p')
    if [ -z "$mon" ]; then
      mon=$(mmsg get all-monitors 2>/dev/null | sed -n 's/.*"monitors":\[{"name":"\([^"]*\)".*/\1/p')
    fi
    [ -n "$mon" ] || exit 0

    # 当前激活 tag 的布局符号(T / RT / M / VS …)
    sym=$(mmsg get tags "$mon" 2>/dev/null \
      | sed -n 's/.*"is_active":true,"is_urgent":[a-z]*,"layout":"\([^"]*\)".*/\1/p')
    [ -n "$sym" ] || exit 0

    # 符号 → 名字,从 mmsg 自己的表里查,不写死
    name=$(mmsg get layouts 2>/dev/null \
      | sed -n "s/.*\"symbol\":\"$sym\",\"name\":\"\([^\"]*\)\".*/\1/p")
    [ -n "$name" ] || name=$sym

    noctalia msg notification-show "Mango 布局" "$name" >/dev/null 2>&1 || true
  '';
in
{
  home.packages = [
    pkgs.grim # 截屏
    pkgs.slurp # 选区
    pkgs.satty # 标注
    pkgs.wl-clipboard # wl-copy
    screenshot
    layoutCycle
  ];

  xdg.configFile."mango/config.conf".source = config.lib.file.mkOutOfStoreSymlink editableConfig;

  # 快捷键速查(Super+Shift+/ 走 `keys mango`,foot + fzf)。
  # 在 ~/.config/mango/ 里再留一份副本,方便手动打开。
  xdg.configFile."mango/KEYS.md".source = config.lib.file.mkOutOfStoreSymlink editableKeys;
}
