# 当前应用快捷键速查（命令 `keys`）。
#
# 绑定：
#   niri   Alt+Shift+Slash  → spawn-sh "$HOME/.nix-profile/bin/keys"
#   mango  ALT+SHIFT,Slash  → spawn_shell $HOME/.nix-profile/bin/keys
#   KDE    手动绑一次：系统设置 → 快捷键 → 添加命令 → 填：
#          /home/<用户>/.nix-profile/bin/keys
#
# 显示：foot 里跑 fzf，单栏列表 + 实时过滤。
#   - 表格是手写在 markdown 里的，运行时用 awk 拍平成「段名 TAB 按键 TAB 中文 [TAB 英文]」，
#     再用 column -t 按显示宽度对齐（fzf 自己不做列对齐，中文宽度也对不上）。
#   - 英文单独一列：源文件里给表格加第 3 列就会自动多一列，没写就空着。
#   - 左右键是编辑查询文字，所以不存在「内容被推出视野」的问题；Enter 只关闭窗口。
#
# 为什么弹窗用 foot 而不是 kitty：
#   实测按一次 Alt+Shift+/ 到窗口出现 ≈285ms，其中 kitty 新开窗口占 240ms
#   （脚本+fzf 合计才 45ms），而且 kitty 在这个版本里不复用已有进程
#   （`single_instance=yes` 实测第二个窗口仍 265ms）、跳过自己配置（`--config NONE`）
#   也只快 10ms —— 冷启动就是它固有的成本。foot 是 ~1MB 的 Wayland 原生终端，
#   新窗口在 30–50ms 量级。kitty 仍然是 Mod+T 的默认终端，这里只是换弹窗。
#
# 设计取舍：
#   - 脚本放 Nix 侧：它依赖 column / fzf / foot 的 store 路径，必须由 Nix 固定。
#   - 键位表放 dotfiles/keybindings/：脚本运行时直接读仓库，改表不用 `nh home switch`。
#     应用表与合成器表（niri / mango）共用一个目录，文件名 = 归一化后的 app_id。
#   - 不做常驻监视：只在按下的那一刻查一次焦点窗口，零后台开销。
#   - 调试：`keys --print` 只打印解析到的文件，不开窗口
#
# 为什么通知用 notify-send 而不是 `noctalia msg`：
#   libnotify 走 org.freedesktop.Notifications，noctalia、Plasma 都实现了，
#   换桌面环境不用改脚本。
{
  config,
  lib,
  pkgs,
  ...
}:

let
  keysDir = "${config.my.repoDir}/dotfiles/keybindings";

  # foot 的弹窗配置：只覆盖字体、留白和底色，其余用 foot 默认值。
  # 用独立配置文件（而不是一串 -o 参数）：键名/语法一目了然，也不会和
  # ~/.config/foot/foot.ini 互相影响（弹窗不应该改用户平时的终端外观）。
  #
  # 为什么不直接用 foot 默认色：默认是纯黑底 + 纯白字（#000000/#ffffff），
  # 对比太硬。这里换成深灰底 + 淡灰字，和下面的 fzf 配色保持一致，
  # 免得弹出窗口比周围窗口亮一大截。
  footConf = pkgs.writeText "foot-keys.ini" ''
    [main]
    font=Maple Mono NF CN:size=12
    pad=6x6

    [colors]
    background=1b1b1b
    foreground=646883
  '';
in
{
  home.packages = [
    # 弹窗专用的轻量终端（见文件头的「为什么」）。
    pkgs.foot
    (pkgs.writeShellScriptBin "keys" ''
            set -u

            keys_dir=${lib.escapeShellArg keysDir}
            # 自己的路径：窗口里要重新执行本脚本的 --show 阶段
            self=$0
            foot=${lib.escapeShellArg "${pkgs.foot}/bin/foot"}
            foot_conf=${lib.escapeShellArg "${footConf}"}
            fzf=${lib.escapeShellArg "${pkgs.fzf}/bin/fzf"}
            jq=${lib.escapeShellArg "${pkgs.jq}/bin/jq"}
            notify=${lib.escapeShellArg "${pkgs.libnotify}/bin/notify-send"}
            kdotool=${lib.escapeShellArg "${pkgs.kdotool}/bin/kdotool"}
            xdotool=${lib.escapeShellArg "${pkgs.xdotool}/bin/xdotool"}
            column=${lib.escapeShellArg "${pkgs.util-linux}/bin/column"}

            notify_missing() {
              "$notify" -a "快捷键" "没有 $1 的快捷键表" \
                "新建：$keys_dir/$1.md（保存后重按一次即可）" 2>/dev/null || true
            }

            # 调试用：只打印解析结果，不弹窗
            print_only=0
            if [ "''${1:-}" = --print ]; then
              print_only=1
              shift
            fi

            # markdown 表格 → 段名<TAB>单元格1<TAB>单元格2…（列数随表而定）
            #   段名取最近一个 `## ` 标题；散文/代码块不收录（fzf 只要一行一个条目）。
            #
            # 只收录「表头里有一列叫 作用」的表 —— 这条约定用来区分两类表：
            #   按键表   | 按键 | 作用 | English |   → 收录（速查的主体）
            #   对照表   | 功能 | niri | mango |      → 不收录（列语义不同，混进来会
            #                                            把 column -t 的列宽撑坏）
            # 判定在「表的第一行」（即表头）上做：表头有「作用」列才收录。
            # hdr 是“本表表头已处理”的标记，空行 / 新标题都会重置它。
            md_rows() {
              awk '
      function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
      /^[ \t]*$/ { hdr = 0; next }
      /^## / { sec = trim(substr($0, 4)); hdr = 0; next }
      /^\|/ {
        line = $0
        sub(/^\|/, "", line); sub(/\|$/, "", line)
        n = split(line, a, "|"); out = ""; sep = 1
        for (i = 1; i <= n; i++) {
          c = trim(a[i])
          # 反引号 / 粗体标记只对 markdown 渲染有意义，在 fzf 列表里是噪音
          gsub(/`/, "", c); gsub(/\*\*/, "", c)
          if (c != "" && c !~ /^[-:]+$/) sep = 0
          out = out (i > 1 ? "\t" : "") c
        }
        if (sep) next                     # |---| 分隔行
        if (!hdr) { hdr = 1; keep = (out ~ /(^|\t)作用(\t|$)/); next }
        if (!keep) next
        print (sec == "" ? "-" : sec) "\t" out
        next
      }' "$1"
            }

            show_file() {
              local file=$1 label=$2
              if [ ! -f "$file" ]; then
                notify_missing "$label"
                return 0
              fi
              if [ "$print_only" -eq 1 ]; then
                printf '%s\n' "$file"
                return 0
              fi
              # 窗口尺寸交给 niri/mango 的 window-rule（0.66×0.8，按 app-id=keys 匹配），
              # 这里不再按内容算，也就没有「排版比窗口宽 → 内容被截断」那类问题。
              exec "$foot" --config "$foot_conf" --app-id=keys \
                --title="$label 常用快捷键速查" -- "$self" --show "$file"
            }

            # 窗口内部入口（只发生在 foot 里）：表格拍平 → 对齐 → fzf
            if [ "''${1:-}" = --show ]; then
              file=''${2:-}
              [ -f "$file" ] || exit 0
              TAB=$'\t'
              rows=$(md_rows "$file" | "$column" -t -s "$TAB")
              if [ -z "$rows" ]; then
                "$notify" -a "快捷键" "这个文件里没有表格" "$(basename "$file")" 2>/dev/null || true
                exit 0
              fi
              # 配色：显式指定，不依赖 fzf 的自动主题——默认主题把当前行画成
              # 256 色的 bg+=237（浅灰），配合 --layout=reverse 就贴在顶部，
              # 在深色窗口里像一条白条。这里改成比底色只亮一档的 #2f2f2f，
              # 并且 bg 和 foot-keys.ini 的 background 保持一致，不会有拼缝。
              printf '%s\n' "$rows" | "$fzf" \
                --layout=reverse --header-first --cycle --info=inline-right \
                --pointer='>' --prompt='快捷键 > ' \
                --header='输入关键字过滤（中文 / 英文都能搜，空格表示同时包含）· Enter 关闭' \
                --color='fg:#c8c8c8,bg:#1b1b1b,hl:#e0af68,fg+:#e6e6e6,bg+:#2f2f2f,hl+:#ffd787,info:#767676,prompt:#8fb4d8,pointer:#8fb4d8,marker:#9ecf9e,spinner:#8fb4d8,header:#767676' \
                --tiebreak=index
              exit 0
            fi

            # app_id → 表名：取最后一个 . 之后的部分并转小写
            #   dev.zed.Zed       → zed
            #   org.kde.dolphin   → dolphin
            normalize() {
              local s=$1
              s=''${s##*.}
              printf '%s' "$s" | tr '[:upper:]' '[:lower:]'
            }

            is_terminal() {
              case $1 in
                kitty|ghostty|wezterm|alacritty|foot|konsole|org.kde.konsole|gnome-terminal|gnome-terminal-server|xterm|st)
                  return 0
                  ;;
              esac
              return 1
            }

            children_of() {
              cat "/proc/$1/task/$1/children" 2>/dev/null
            }

            is_shell() {
              case $1 in
                fish|bash|zsh|sh|dash|nu|xonsh|elvish) return 0 ;;
              esac
              return 1
            }

            # 终端窗口 → 前台程序名（可能有几层，返回空格分隔的候选，从浅到深）。
            #
            # kitty 每个窗口是一个独立进程，直接子进程里既有 shell 也有
            # `kitten __atexit__` 之类的辅助进程，所以先找到 shell，
            # 再从 shell 往下找前台作业。沿途的名字都留着：编辑器还会再派生
            # LSP（hx → nixd / rust-analyzer），只看最深那层会认成 LSP。
            foreground_child() {
              local pid=$1 depth=0 shell="" c comm next out=""

              for c in $(children_of "$pid"); do
                comm=$(cat "/proc/$c/comm" 2>/dev/null) || continue
                if is_shell "$comm"; then
                  shell=$c
                  break
                fi
              done
              [ -n "$shell" ] || return 0

              pid=$shell
              while [ "$depth" -lt 5 ]; do
                next=""
                for c in $(children_of "$pid"); do
                  comm=$(cat "/proc/$c/comm" 2>/dev/null) || continue
                  is_shell "$comm" && continue
                  out="$out $comm"
                  next=$c
                  break
                done
                [ -n "$next" ] || break
                pid=$next
                depth=$((depth + 1))
              done

              printf '%s' "''${out# }"
            }

            # 进程名 → 表名（调用处会再检查文件是否存在，不存在就试下一个候选）
            #
            # Nix 包装过的程序，/proc/<pid>/comm 带的是包装器的名字：
            #   helix → .hx-wrapped    kitty → .kitty-wrapped
            # 去掉前缀点和 -wrapped 后缀再匹配，否则永远认不出来。
            map_proc() {
              local p=''${1#.}
              p=''${p%-wrapped}
              case $p in
                hx|helix) printf '%s' helix ;;
                nvim|vim|vi) printf '%s' neovim ;;
                yazi) printf '%s' yazi ;;
                lazygit) printf '%s' lazygit ;;
                btop) printf '%s' btop ;;
                k9s) printf '%s' k9s ;;
                tmux) printf '%s' tmux ;;
              esac
            }

            # ── 1. 显式指定：keys niri / keys kitty ──────────────────────────
            # 合成器表（niri / mango）和应用表同一个目录，所以只有一条查找路径。
            if [ "$#" -gt 0 ]; then
              if [ -f "$keys_dir/$1.md" ]; then
                show_file "$keys_dir/$1.md" "$1"
                exit 0 # --print 模式下 show_file 会返回，别继续走到下面的 notify
              fi
              notify_missing "$1"
              exit 0
            fi

            # ── 2. 找焦点窗口，同时识别桌面环境 ─────────────────────────────
            de=""
            app=""
            pid=""

            if [ -n "''${NIRI_SOCKET:-}" ]; then
              de=niri
              json=$(niri msg --json focused-window 2>/dev/null || true)
              if [ -n "$json" ] && [ "$json" != "null" ]; then
                app=$(printf '%s' "$json" | "$jq" -r '.app_id // empty' 2>/dev/null || true)
                pid=$(printf '%s' "$json" | "$jq" -r '.pid // empty' 2>/dev/null || true)
              fi
            else
              # mango 没有环境变量可用，直接看 mmsg 是否成功
              json=$(mmsg get focusing-client 2>/dev/null || true)
              if [ -n "$json" ]; then
                de=mango
                app=$(printf '%s' "$json" | "$jq" -r '.app_id // .class // empty' 2>/dev/null || true)
                pid=$(printf '%s' "$json" | "$jq" -r '.pid // empty' 2>/dev/null || true)
              fi

              if [ -z "$de" ]; then
                case "''${XDG_CURRENT_DESKTOP:-}" in
                  *KDE*)
                    de=kde
                    win=$("$kdotool" getactivewindow 2>/dev/null || true)
                    if [ -n "$win" ]; then
                      app=$("$kdotool" getwindowclassname "$win" 2>/dev/null || true)
                      pid=$("$kdotool" getwindowpid "$win" 2>/dev/null || true)
                    fi
                    ;;
                esac
              fi

              if [ -z "$de" ] && [ -n "''${DISPLAY:-}" ]; then
                de=x11
                win=$("$xdotool" getactivewindow 2>/dev/null || true)
                if [ -n "$win" ]; then
                  app=$("$xdotool" getwindowclassname "$win" 2>/dev/null || true)
                  pid=$("$xdotool" getwindowpid "$win" 2>/dev/null || true)
                fi
              fi
            fi

            # ── 3. 没有焦点窗口 → 显示合成器自己的表（niri / mango）─────────
            if [ -z "$app" ]; then
              case "$de" in
                niri) show_file "$keys_dir/niri.md" niri ;;
                mango) show_file "$keys_dir/mango.md" mango ;;
                *)
                  "$notify" -a "快捷键" "没有焦点窗口" \
                    "无法判断当前应用（''${de:-unknown}）" 2>/dev/null || true
                  ;;
              esac
              exit 0
            fi

            # ── 4. 终端窗口：优先显示终端里正在跑的程序 ─────────────────────
            name=$(normalize "$app")

            if is_terminal "$name" && [ -n "$pid" ]; then
              candidates=$(foreground_child "$pid")
              for child in $candidates; do
                mapped=$(map_proc "$child")
                if [ -n "$mapped" ] && [ -f "$keys_dir/$mapped.md" ]; then
                  name=$mapped
                  break
                fi
              done
            fi

            # ── 5. 查表 ─────────────────────────────────────────────────────
            if [ -f "$keys_dir/$name.md" ]; then
              show_file "$keys_dir/$name.md" "$name"
            else
              notify_missing "$name"
            fi
    '')
  ];
}
