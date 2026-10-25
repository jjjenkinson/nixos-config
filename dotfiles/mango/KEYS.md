# Mango 快捷键速查

> `Super+Shift+/` 随时呼出本页。
> 配置在 `~/.config/mango/config.conf`（→ 仓库 `dotfiles/mango/config.conf`），保存即生效。

## 最常用

| 按键           | 作用                             |
| -------------- | -------------------------------- |
| `Super+D`      | 启动器 fuzzel                    |
| `Super+T`      | 终端 kitty                       |
| `Super+Q`      | 关闭窗口                         |
| `Super+F`      | 铺满屏幕（最大化）               |
| `Super+Ctrl+R` | 重载配置（平时自动重载，用不到） |

> 本机约定：新键替代旧键，旧键在 `config.conf` 里注释掉，不两套并存。
> 上游的 `Alt+Space` / `Alt+Return` / `Alt+Q` 已注释，想恢复去掉 `#` 即可。

## 会话 / 电源

| 按键              | 作用                                           |
| ----------------- | ---------------------------------------------- |
| `Ctrl+Alt+Delete` | noctalia 会话面板（关机 / 重启 / 注销 / 锁屏） |
| `Ctrl+Alt+Insert` | 退出 mango（整个合成器，慎按）                 |
| `Super+Alt+L`     | 锁屏（swaylock），解锁需输密码                 |

## 截图

| 按键           | 作用                                       |
| -------------- | ------------------------------------------ |
| `Super+P`      | 选区 → satty 标注 → **回车** 存盘 + 剪贴板 |
| `Super+Ctrl+P` | 整屏截图 → 存盘 + 剪贴板                   |

satty 窗口里：回车 = 保存并复制；Esc = 退出（保留未标注原图）；
工具列里可以画箭头 / 矩形 / 文字 / 模糊。

## 焦点与移动

| 按键                  | 作用                       |
| --------------------- | -------------------------- |
| `Super+H/J/K/L`       | 按方向切焦点（同 niri）    |
| `Super+←/→/↑/↓`       | 同上，方向键版（同 niri）  |
| `Super+Ctrl+H/J/K/L`  | 把窗口往对应方向移         |
| `Super+Shift+←/→/↑/↓` | 同上，方向键版             |
| `Super+Tab`           | 最近使用的窗口间交替       |
| `Alt+Tab`             | 跳转标签（显示字母直接跳） |

> 上游的 `Alt+←/→/↑/↓`（焦点）已注释。顺带：`Super+←/→` 本来在 mango 里是切 tag，
> 现已让位给焦点（niri 的 `Mod+←/→` 就是焦点）；切 tag 用 `Super+1..9`。

## 工作区（tag）

| 按键              | 作用                      |
| ----------------- | ------------------------- |
| `Super+1..9`      | 切到 tag 1–9（同 niri）   |
| `Super+Ctrl+1..9` | 把窗口移到 tag 并跟过去   |
| `Ctrl+←/→`        | 切到左/右**有窗口**的 tag |
| `Ctrl+Super+←/→`  | tag 整体左/右移           |

> 上游的 `Ctrl+1..9`（切）/ `Alt+1..9`（移）已注释——功能和上面两条重复。
> 上游的 `Super+←/→`（切相邻 tag）也已注释，那个键位让给了焦点。

## 窗口状态

| 按键                        | 作用                           |
| --------------------------- | ------------------------------ |
| `Super+F`                   | 铺满屏幕（同 niri 的 Mod+F）   |
| `Super+Shift+F`             | 全屏（同 niri 的 Mod+Shift+F） |
| `Alt+Shift+F`               | 伪全屏                         |
| `Super+V`                   | 浮动 ↔ 平铺（同 niri）         |
| `Alt+Z`                     | 便签窗口（scratchpad）         |
| `Super+I` / `Super+Shift+I` | 最小化 / 恢复                  |
| `Super+O`                   | overlay 总览                   |
| `Super+G`                   | 全局窗口（所有 tag 可见）      |

> `Super+F` 前是上游的 `Alt+A`，`Super+Shift+F` 前是上游的 `Alt+F`，两者均已注释。

## 布局

| 按键                    | 作用                                 |
| ----------------------- | ------------------------------------ |
| `Super+N`               | 切换平铺算法（弹通知显示当前算法名） |
| `Super+R`               | 循环单窗口宽度比例（同 niri）        |
| `Super+Ctrl+F`          | 单窗口占满宽度（同 niri）            |
| `Alt+Super+Ctrl+方向键` | scroller 布局堆叠                    |
| `Alt+Shift+Return`      | dwindle 布局手动切分屏方向           |
| `Alt+Shift+X` / `Z`     | 间隙 +1 / −1                         |
| `Alt+Shift+R`           | 开关间隙                             |

可用的 14 种布局：`tile`、`scroller`、`grid`、`monocle`、`deck`、`center_tile`、`right_tile`、
`vertical_scroller`、`vertical_tile`、`vertical_grid`、`vertical_deck`、`dwindle`、`fair`、`vertical_fair`。
布局是 **按 tag 记住** 的（`tag_rule`），所以不同工作区可以各自用不同算法。

## 多显示器

| 按键            | 作用                  |
| --------------- | --------------------- |
| `Alt+Shift+←/→` | 焦点移到左/右显示器   |
| `Super+Alt+←/→` | 把窗口丢到左/右显示器 |

## 浮动窗口

| 按键                | 作用       |
| ------------------- | ---------- |
| `Ctrl+Shift+方向键` | 平移 ±50px |
| `Ctrl+Alt+方向键`   | 缩放 ±50px |

## 鼠标 / 触摸板

| 操作              | 作用                      |
| ----------------- | ------------------------- |
| `Super+左键拖动`  | 移动窗口                  |
| `Super+右键拖动`  | 缩放窗口                  |
| `中键`            | 最大化 / 还原             |
| `Super+滚轮上/下` | 切到左/右有窗口的 tag     |
| 三指左/右/上/下   | 按方向切焦点              |
| 四指左/右         | 切到上/下一个有窗口的 tag |
| 四指上/下         | 进入 / 退出总览           |

## 多媒体键

| 按键                       | 作用               |
| -------------------------- | ------------------ |
| 音量 +/−                   | wpctl，步进 0.04   |
| 静音 / 麦克风静音          | wpctl toggle       |
| 播放/暂停、停止、上/下一曲 | playerctl          |
| 亮度 +/−                   | brightnessctl ±10% |

## 与 niri 的对应关系（方案四）

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

| 功能       | niri          | mango                               | 原因                               |
| ---------- | ------------- | ----------------------------------- | ---------------------------------- |
| 切布局     | 无            | `Super+N`                           | mango 独有                         |
| 退出合成器 | `Mod+Shift+E` | `Ctrl+Alt+Insert`                   | mango 的退出没确认框，特意放远一点 |
| 窗口微调   | 无            | `Ctrl+Shift+方向` / `Ctrl+Alt+方向` | mango 独有                         |
| 伪全屏     | 无            | `Alt+Shift+F`                       | niri 没有对应功能                  |
| 便签窗口   | 无            | `Alt+Z`                             | niri 没有对应功能                  |

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
维护说明（注释，不在页面上渲染；bat 直接显示原文，所以放在文末不挡表格）
────────────────────────────────────────────
本文件是**纯文档**：mango 只读 config.conf，从来不读这个文件。两者不会互相同步。

  · 改 config.conf → 本表不会自动更新，会悄悄过期
  · 改本表         → 键位完全不变，唯一效果是 Super+Shift+/ 显示的文字变了

mango 没有运行时快捷键浮层（不像 niri 的 Mod+Shift+/），所以这张表是唯一总览，
更需要手动维护：新增 / 删掉 / 改动任何 bind= 之后，请顺手同步对应表格行。
另外，mango 的 config.conf 里行内 # 注释可能不被剥离，说明文字一律写在上一行。
-->
