# Mango 快捷键速查

> `Super+Shift+/` 随时呼出本页。
> `Alt+Shift+/` 是**当前应用**的表（在终端里跑 `hx` 就显示 helix 的表），
> 没有该应用的表会弹通知；应用表都在仓库 `dotfiles/keybindings/*.md`。
> 配置在 `~/.config/mango/config.conf`（→ 仓库 `dotfiles/mango/config.conf`），保存即生效。
>
> 表格约定：`| 键 | 作用 | English |`，第 3 列是英文；一行所有列（含段名）合计
> ≤110 列宽（速查窗口里超宽会被 fzf 截断）。`## ` 标题会作为速查里的段名。

## 常用

| 键             | 作用                     | English           |
| -------------- | ------------------------ | ----------------- |
| `Super+D`      | 启动器 fuzzel            | Launcher (fuzzel) |
| `Super+T`      | 终端 kitty               | Terminal          |
| `Super+Q`      | 关闭窗口                 | Close window      |
| `Super+F`      | 铺满屏幕（最大化）       | Maximize          |
| `Super+Ctrl+R` | 重载配置（平时自动重载） | Reload config     |
| `Alt+Shift+/`  | 当前应用的快捷键表       | Focused app keys  |

> 本机约定：新键替代旧键，旧键在 `config.conf` 里注释掉，不两套并存。
> 上游的 `Alt+Space` / `Alt+Return` / `Alt+Q` 已注释，想恢复去掉 `#` 即可。

## 会话

| 键                | 作用                           | English       |
| ----------------- | ------------------------------ | ------------- |
| `Ctrl+Alt+Delete` | 会话面板：关机/重启/注销/锁屏  | Session panel |
| `Ctrl+Alt+Insert` | 退出 mango（整个合成器，慎按） | Quit mango    |
| `Super+Alt+L`     | 锁屏（swaylock），解锁需输密码 | Lock screen   |

## 截图

| 键             | 作用                                  | English              |
| -------------- | ------------------------------------- | -------------------- |
| `Super+P`      | 选区 → satty 标注 → 回车存盘 + 剪贴板 | Screenshot, annotate |
| `Super+Ctrl+P` | 整屏截图 → 存盘 + 剪贴板              | Full screen          |

satty 窗口里：回车 = 保存并复制；Esc = 退出（保留未标注原图）；
工具列里可以画箭头 / 矩形 / 文字 / 模糊。

## 焦点

| 键                    | 作用                       | English          |
| --------------------- | -------------------------- | ---------------- |
| `Super+H/J/K/L`       | 按方向切焦点（同 niri）    | Focus direction  |
| `Super+←/→/↑/↓`       | 同上，方向键版（同 niri）  | Same, arrow keys |
| `Super+Ctrl+H/J/K/L`  | 把窗口往对应方向移         | Move window      |
| `Super+Shift+←/→/↑/↓` | 同上，方向键版             | Same, arrow keys |
| `Super+Tab`           | 最近使用的窗口间交替       | Last window      |
| `Alt+Tab`             | 跳转标签（显示字母直接跳） | Jump to tag      |

> 上游的 `Alt+←/→/↑/↓`（焦点）已注释。顺带：`Super+←/→` 本来在 mango 里是切 tag，
> 现已让位给焦点（niri 的 `Mod+←/→` 就是焦点）；切 tag 用 `Super+1..9`。

## 工作区

mango 用「tag」：每个屏幕一组 1–9，切走再切回窗口还在。

| 键                | 作用                      | English              |
| ----------------- | ------------------------- | -------------------- |
| `Super+1..9`      | 切到 tag 1–9（同 niri）   | Tag 1-9              |
| `Super+Ctrl+1..9` | 把窗口移到 tag 并跟过去   | Move window to tag   |
| `Ctrl+←/→`        | 切到左/右**有窗口**的 tag | Prev / next used tag |
| `Ctrl+Super+←/→`  | tag 整体左/右移           | Move tag L/R         |

> 上游的 `Ctrl+1..9`（切）/ `Alt+1..9`（移）已注释——功能和上面两条重复。
> 上游的 `Super+←/→`（切相邻 tag）也已注释，那个键位让给了焦点。

## 窗口

| 键                          | 作用                           | English            |
| --------------------------- | ------------------------------ | ------------------ |
| `Super+F`                   | 铺满屏幕（同 niri 的 Mod+F）   | Maximize           |
| `Super+Shift+F`             | 全屏（同 niri 的 Mod+Shift+F） | Fullscreen         |
| `Alt+Shift+F`               | 伪全屏                         | Fake fullscreen    |
| `Super+V`                   | 浮动 ↔ 平铺（同 niri）         | Toggle floating    |
| `Alt+Z`                     | 便签窗口（scratchpad）         | Scratchpad         |
| `Super+I` / `Super+Shift+I` | 最小化 / 恢复                  | Minimize / restore |
| `Super+O`                   | overlay 总览                   | Overview           |
| `Super+G`                   | 全局窗口（所有 tag 可见）      | Global window      |

> `Super+F` 前是上游的 `Alt+A`，`Super+Shift+F` 前是上游的 `Alt+F`，两者均已注释。

## 布局

| 键                    | 作用                             | English        |
| --------------------- | -------------------------------- | -------------- |
| `Super+N`             | 切换平铺算法（弹通知显示算法名） | Cycle layout   |
| `Super+R`             | 循环单窗口宽度比例（同 niri）    | Cycle width    |
| `Super+Ctrl+F`        | 单窗口占满宽度（同 niri）        | Expand window  |
| `Alt+Super+Ctrl+方向` | scroller 布局堆叠                | Scroller stack |
| `Alt+Shift+Return`    | dwindle 布局手动切分屏方向       | Dwindle split  |
| `Alt+Shift+X` / `Z`   | 间隙 +1 / −1                     | Gap +/-1       |
| `Alt+Shift+R`         | 开关间隙                         | Toggle gaps    |

可用的 14 种布局：`tile`、`scroller`、`grid`、`monocle`、`deck`、`center_tile`、`right_tile`、
`vertical_scroller`、`vertical_tile`、`vertical_grid`、`vertical_deck`、`dwindle`、`fair`、`vertical_fair`。
布局是 **按 tag 记住** 的（`tag_rule`），所以不同工作区可以各自用不同算法。

## 多屏

| 键              | 作用                  | English         |
| --------------- | --------------------- | --------------- |
| `Alt+Shift+←/→` | 焦点移到左/右显示器   | Focus monitor   |
| `Super+Alt+←/→` | 把窗口丢到左/右显示器 | Move to monitor |

## 浮动

| 键                | 作用       | English      |
| ----------------- | ---------- | ------------ |
| `Ctrl+Shift+方向` | 平移 ±50px | Move ±50px   |
| `Ctrl+Alt+方向`   | 缩放 ±50px | Resize ±50px |

## 鼠标

| 操作              | 作用                      | English                 |
| ----------------- | ------------------------- | ----------------------- |
| `Super+左键拖动`  | 移动窗口                  | Drag to move            |
| `Super+右键拖动`  | 缩放窗口                  | Drag to resize          |
| `中键`            | 最大化 / 还原             | Maximize / restore      |
| `Super+滚轮上/下` | 切到左/右有窗口的 tag     | Prev / next used tag    |
| 三指左/右/上/下   | 按方向切焦点              | 3-finger: focus         |
| 四指左/右         | 切到上/下一个有窗口的 tag | 4-finger: prev/next tag |
| 四指上/下         | 进入 / 退出总览           | 4-finger: overview      |

## 媒体

| 键                         | 作用               | English           |
| -------------------------- | ------------------ | ----------------- |
| 音量 +/−                   | wpctl，步进 0.04   | Volume +/- 4%     |
| 静音 / 麦克风静音          | wpctl toggle       | Mute / mic mute   |
| 播放/暂停、停止、上/下一曲 | playerctl          | Media control     |
| 亮度 +/−                   | brightnessctl ±10% | Brightness +/-10% |

## 对照（不进取速查表）

下面两张表是「mango 与 niri 怎么对应」的参考，**不是按键表**，所以速查窗口里不出现
（速查只收录表头带「作用」列的表）。

niri 的主修饰键是 `Mod`(=`Super`)，所以 mango 这边**也用 Super**，两边按法完全一致。

> **为什么不用 Alt：** `bind=` 是合成器级抓取，被占的键客户端根本收不到。
> 而 `Alt+字母` 是 GTK / Qt 的菜单助记键（`Alt+F`=File、`Alt+E`=Edit、`Alt+V`=View、
> `Alt+H`=Help、`Alt+T`=Tools），用 Alt 就会把这些菜单全堵死。Super 没这个问题。

| 功能           | niri               | mango                       |
| -------------- | ------------------ | --------------------------- |
| 终端           | `Mod+T`            | `Super+T`                   |
| 启动器         | `Mod+D`            | `Super+D`                   |
| 浏览器         | `Mod+N`            | 无（两边都不绑）            |
| 关闭窗口       | `Mod+Q`            | `Super+Q`                   |
| 焦点           | `Mod+H/J/K/L`      | `Super+H/J/K/L`             |
| 焦点（方向键） | `Mod+←/→/↑/↓`      | `Super+←/→/↑/↓`             |
| 移动窗口       | `Mod+Ctrl+H/J/K/L` | `Super+Ctrl+H/J/K/L`        |
| 切工作区       | `Mod+1..9`         | `Super+1..9`                |
| 移到工作区     | `Mod+Ctrl+1..9`    | `Super+Ctrl+1..9`           |
| 浮动切换       | `Mod+V`            | `Super+V`                   |
| 铺满屏幕       | `Mod+F`            | `Super+F`                   |
| 全屏           | `Mod+Shift+F`      | `Super+Shift+F`             |
| 列宽循环       | `Mod+R`            | `Super+R`                   |
| 占满宽度       | `Mod+Ctrl+F`       | `Super+Ctrl+F`              |
| 截图           | `Mod+P`            | `Super+P`（本来就一致）     |
| 总览           | `Mod+O`            | `Super+O`（本来就一致）     |
| 锁屏           | `Super+Alt+L`      | `Super+Alt+L`（本来就一致） |
| 会话面板       | `Ctrl+Alt+Delete`  | 同                          |

**有意的例外：**

| 功能       | niri          | mango                               | 原因               |
| ---------- | ------------- | ----------------------------------- | ------------------ |
| 切布局     | 无            | `Super+N`                           | mango 独有         |
| 退出合成器 | `Mod+Shift+E` | `Ctrl+Alt+Insert`                   | 退出没确认框，放远 |
| 窗口微调   | 无            | `Ctrl+Shift+方向` / `Ctrl+Alt+方向` | mango 独有         |
| 伪全屏     | 无            | `Alt+Shift+F`                       | niri 没有对应功能  |
| 便签窗口   | 无            | `Alt+Z`                             | niri 没有对应功能  |

---

**提示**

- `Ctrl+Alt+Insert` 是退出合成器，关窗口用 `Super+Q`。
- 常用键全部用 `Super`（= niri 的 `Mod`）：`Super+T`/`Super+D`/`Super+Q`/`Super+F`/
  `Super+Shift+F`/`Super+V`/`Super+方向`/`Super+H/J/K/L`/`Super+1..9`。
- 仍留在 `Alt` 上的只剩 niri 没有对应功能的那几个：`Alt+Tab`（跳窗口）、
  `Alt+Shift+F`（伪全屏）、`Alt+Z`（便签）、`Alt+Shift+X/Z/R`（间隙）、`Alt+Shift+方向`（多屏）。
- 锁屏用 `Super+Alt+L`（swaylock），和 niri 一致。
- 截图工具链是 `grim` + `slurp` + `satty` + `wl-clipboard`（由 `home/common/mango.nix` 安装）。
- 没有内置截图 UI：`Super+P` 之后用鼠标拖选区域，Esc 取消。

---

<!--
维护说明（注释，不在页面上渲染；fzf 只取表格行，所以放在文末不影响显示）
────────────────────────────────────────────
本文件是**纯文档**：mango 只读 config.conf，从来不读这个文件。两者不会互相同步。

  · 改 config.conf → 本表不会自动更新，会悄悄过期
  · 改本表         → 键位完全不变，唯一效果是 Super+Shift+/ 显示的文字变了

mango 没有运行时快捷键浮层（不像 niri 的 Mod+Shift+/），所以这张表是唯一总览，
更需要手动维护：新增 / 删掉 / 改动任何 bind= 之后，请顺手同步对应表格行。
另外，mango 的 config.conf 里行内 # 注释可能不被剥离，说明文字一律写在上一行。

表格约定：只收录表头带「作用」列的表（末尾两张「对照」表因此不进速查窗口）；
第 3 列是英文；一行所有列合计 ≤110 列宽。新增键位时中英各写一遍。
-->
