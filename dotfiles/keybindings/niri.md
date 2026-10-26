# niri 快捷键速查

> `Mod+/` 随时呼出本页（浮动终端 + fzf，可输入关键字过滤）。
> `Mod+Shift+/` 是 niri 自带的「重要快捷键」浮层，内容更少，两个互补。
> `Alt+Shift+/` 是**当前应用**的表（在终端里跑 `hx` 就显示 helix 的表），
> 没有该应用的表会弹通知；应用表都在仓库 `dotfiles/keybindings/*.md`。
>
> **Mod = Super（Win 键）**。在 niri 里 `Mod` 是特殊修饰键：跑在 TTY 上等于 Super，
> 跑在窗口里（winit）等于 Alt。
>
> 表格约定：`| 键 | 作用 | English |`，第 3 列是英文；一行所有列（含段名）合计
> ≤110 列宽（速查窗口里超宽会被 fzf 截断）。`## ` 标题会作为速查里的段名。
> 键位用键帽写法（`Mod+[`、`Mod+-`），config.kdl 里的 keysym 拼写在表下注明。
>
> 配置来源两份，都在 `~/.config/niri/`：`base.kdl`（niri 自带默认配置生成，
> Nix 管理，随升级更新）和 `config.kdl`（本仓库，软链，保存即热重载）。
> 标注「本机」的条目就是 `config.kdl` 改掉默认值的那几条。

## 常用

| 键            | 作用                           | English           |
| ------------- | ------------------------------ | ----------------- |
| `Mod+T`       | 终端 kitty                     | Terminal          |
| `Mod+D`       | 启动器 fuzzel（可搜应用/文件） | Launcher (fuzzel) |
| `Mod+Q`       | 关闭当前窗口                   | Close window      |
| `Mod+O`       | 概览（鼠标甩左上角也能触发）   | Overview          |
| `Mod+Shift+/` | niri 内置重要快捷键浮层        | Built-in sheet    |
| `Mod+/`       | 本速查表（浮动窗口）           | This cheatsheet   |
| `Alt+Shift+/` | 当前应用的快捷键表             | Focused app keys  |

## 焦点

| 键                             | 作用                        | English                  |
| ------------------------------ | --------------------------- | ------------------------ |
| `Mod+←/↓/↑/→`                  | 焦点移到 左 / 下 / 上 / 右  | Focus left/down/up/right |
| `Mod+H/J/K/L`                  | 同上（vim 风格：H 左 L 右） | Same, vim style          |
| `Mod+Ctrl+←/→ 或 Mod+Ctrl+H/L` | 把**整列**往左 / 右挪       | Move column L/R          |
| `Mod+Ctrl+↓/↑ 或 Mod+Ctrl+J/K` | 把**单个窗口**往下 / 上挪   | Move window D/U          |
| `Mod+Home` / `Mod+End`         | 焦点跳到第一列 / 最后一列   | First / last column      |
| `Mod+Ctrl+Home/End`            | 把当前列移到最前 / 最后     | Column to first/last     |

> niri 是「列」式平铺：`Mod+←/→` 换列，`Mod+↑/↓` 在列内换窗口。
> 列里的窗口上下堆叠，`Mod+W` 可以改成标签页式。

## 工作区

工作区是动态的，用完即回收。

| 键                    | 作用                      | English                  |
| --------------------- | ------------------------- | ------------------------ |
| `Mod+PgUp / PgDn`     | 上一个 / 下一个工作区     | Prev / next workspace    |
| `Mod+I` / `Mod+U`     | 同上（I 上、U 下）        | Same                     |
| `Mod+1..9`            | 直接跳到工作区 1–9        | Workspace 1-9            |
| `Mod+Ctrl+PgUp/PgDn`  | 把当前列移到上 / 下工作区 | Move column to workspace |
| `Mod+Ctrl+1..9`       | 把当前列移到工作区 1–9    | Move column to 1-9       |
| `Mod+Shift+PgUp/PgDn` | 工作区整体上移 / 下移     | Move workspace up/down   |
| `Mod+Shift+Home/End`  | 工作区顶到最上 / 最下     | Workspace to top/bottom  |
| `Mod+滚轮上/下`       | 切工作区（150ms 冷却）    | Switch workspace (wheel) |

> `PgUp`/`PgDn` 的 keysym 是 `Page_Up` / `Page_Down`。
> `Mod+Shift+Home/End` 是向上/下连移 32 次实现的，所以会一路顶到边界。

## 布局

`Mod+[`/`Mod+]` = `BracketLeft`/`BracketRight`，`Mod+,`/`Mod+.` = `Comma`/`Period`，
`Mod+-`/`Mod+=` = `Minus`/`Equal`。

| 键                          | 作用                             | English               |
| --------------------------- | -------------------------------- | --------------------- |
| `Mod+R / Mod+Shift+R`       | 循环预设列宽 / 反向循环          | Cycle column width    |
| `Mod+- / Mod+=`             | 列宽 −10% / +10%                 | Column width -/+10%   |
| `Mod+Shift+- / Mod+Shift+=` | 行高 −10% / +10%（列内多窗口时） | Row height -/+10%     |
| `Mod+Ctrl+R`                | 重置行高                         | Reset row height      |
| `Mod+Ctrl+Shift+R`          | 切换预设行高                     | Cycle row preset      |
| `Mod+F`                     | 列最大化（保留间隙和边框）       | Maximize column       |
| `Mod+M`                     | 窗口最大化到屏幕边缘（无间隙）   | Maximize to edges     |
| `Mod+Shift+F`               | 窗口全屏（盖住状态栏）           | Fullscreen            |
| `Mod+Ctrl+F`                | 把列撑满剩余空间                 | Expand column         |
| `Mod+C / Mod+Ctrl+C`        | 居中当前列 / 居中所有可见列      | Center column(s)      |
| `Mod+W`                     | 列的标签页显示模式开关           | Column tabbed mode    |
| `Mod+[ / Mod+]`             | 吞进左 / 右侧相邻列              | Consume window L/R    |
| `Mod+, / Mod+.`             | 吞进列底 / 把底部窗口吐到右边    | Move window in/out    |
| `Mod+V`                     | 当前窗口 浮动 ↔ 平铺 切换        | Toggle floating       |
| `Mod+Shift+V`               | 浮动 / 平铺窗口间切换焦点        | Focus floating/tiling |
| `Mod+滚轮左/右`             | 焦点左 / 右列                    | Focus column          |
| `Mod+Ctrl+滚轮左/右`        | 列左 / 右移                      | Move column L/R       |
| `Mod+Shift+滚轮上/下`       | 焦点左 / 右列（应用内横向滚动）  | Focus column          |
| `Mod+Ctrl+Shift+滚轮上/下`  | 列左 / 右移                      | Move column L/R       |

## 多屏

| 键                       | 作用                        | English                |
| ------------------------ | --------------------------- | ---------------------- |
| `Mod+Shift+←/↓/↑/→`      | 焦点切到左 / 下 / 上 / 右屏 | Focus monitor          |
| `Mod+Shift+H/J/K/L`      | 同上                        | Same                   |
| `Mod+Shift+Ctrl+←/↓/↑/→` | 把当前列移到该显示器        | Move column to monitor |
| `Mod+Shift+Ctrl+H/J/K/L` | 同上                        | Same                   |

## 截图

| 键                       | 作用                           | English        |
| ------------------------ | ------------------------------ | -------------- |
| `Mod+P`                  | 截图：拖选 / 点窗口 / 回车全屏 | Screenshot UI  |
| `Mod+Ctrl+P`             | 直接截整屏                     | Full screen    |
| `Mod+Alt+P`              | 直接截当前窗口                 | Current window |
| `Print`                  | 同 `Mod+P`                     | Same as Mod+P  |
| `Ctrl+Print / Alt+Print` | 同 `Mod+Ctrl+P` / `Mod+Alt+P`  | Same           |

> 三组 `Mod+P` 是**本机**改动：75% 配列没有独立 PrtSc 键，而 `Mod+Shift+P` 已被
> `base.kdl` 用作关闭显示器，所以取无修饰 / Ctrl / Alt 三个组合。
> 保存到 `~/Pictures/Screenshots/prtScr-%Y%m%d-%H%M%S.png`，同时进剪贴板。
> niri 自带截图，不依赖 grim / spectacle / portal。

## 媒体

完整 keysym：`XF86AudioRaiseVolume` / `XF86AudioLowerVolume` / `XF86AudioMute` /
`XF86AudioMicMute` / `XF86AudioPlay` / `XF86AudioStop` / `XF86AudioPrev` /
`XF86AudioNext` / `XF86MonBrightnessUp` / `XF86MonBrightnessDown`。

| 键            | 作用                             | English       |
| ------------- | -------------------------------- | ------------- |
| `音量 +/−`    | ±4%（本机改，默认 ±10%）         | Volume ±4%    |
| `静音`        | 静音开关                         | Mute toggle   |
| `麦克风静音`  | 麦克风静音开关                   | Mic mute      |
| `播放/暂停等` | playerctl 播放 / 停止 / 上下一首 | Media control |
| `亮度 +/−`    | ±10%                             | Brightness    |

> 音量/亮度键带 `allow-when-locked=true`，锁屏状态下也能用。

## 会话

| 键                | 作用                                  | English       |
| ----------------- | ------------------------------------- | ------------- |
| `Ctrl+Alt+Delete` | 会话面板：关机/重启/注销/锁屏（本机） | Session panel |
| `Super+Alt+L`     | 锁屏 swaylock，解锁需输密码           | Lock screen   |
| `Mod+Shift+P`     | 关闭显示器（动鼠标或按键恢复）        | Display off   |
| `Mod+Shift+E`     | 退出 niri（会有确认对话框）           | Quit niri     |
| `Mod+Escape`      | 切换键盘快捷键拦截                    | Key intercept |

> 会话面板 = noctalia 面板。`base.kdl` 里 `Ctrl+Alt+Delete` 原本是「退出 niri」，
> 本机改成了会话面板；要退出请用 `Mod+Shift+E`。
> `Mod+Escape` 用于远程桌面 / 软件 KVM 抢键盘时放开拦截。

## 其他

| 键            | 作用                           | English       |
| ------------- | ------------------------------ | ------------- |
| `Super+Alt+S` | 屏幕阅读器 orca（基本用不到）  | Screen reader |
| `Mod+N`       | 未绑定（浏览器那条已解绑）     | Unbound       |
| `Mod+E`       | 未绑定（文件管理器那条已注释） | Unbound       |

> 文件管理器可以用 `Mod+D` 打开 fuzzel 输 `dolphin`，或者终端里 `xdg-open ~`。

## 鼠标

| 操作         | 作用                   | English            |
| ------------ | ---------------------- | ------------------ |
| `Mod+左键拖` | 移动窗口（平铺也支持） | Drag to move       |
| `Mod+右键拖` | 调整窗口大小           | Drag to resize     |
| `Mod+中键`   | 同左键拖               | Same as left       |
| `四指上滑`   | 打开概览（触摸板）     | Swipe up: overview |
| `左上角热区` | 打开概览               | Hot corner         |

> 窗口边框可拖拽调整尺寸；双击标题栏 = 最大化到边缘（同 `Mod+M`）。

---

<!--
维护说明（注释，不在页面上渲染；fzf 只取表格行，所以放在文末不影响显示）
────────────────────────────────────────────
本文件是**纯文档**：niri 只读 base.kdl / config.kdl，从来不读这个文件。两者不会互相同步。

  · 改 base.kdl 或 config.kdl → 本表不会自动更新，会悄悄过期
  · 改本表                  → 键位完全不变，唯一效果是 Mod+/ 显示的文字变了

唯一“自动”的是 Mod+Shift+/ 那个内置浮层：它由 niri 在运行时从实际加载的配置里读，
所以新增绑定时只要写了 hotkey-overlay-title=…，浮层里立刻就有 —— 但那是浮层，不是本文件。

因此：新增 / 删掉 / 改动任何绑定（含 base.kdl 因 niri 升级而变化）之后，
请手动同步对应表格行，否则 Mod+/ 看到的就是过期内容。

表格约定：只收录表头带「作用」列的表；第 3 列是英文；一行所有列合计 ≤110 列宽。
新增键位时中英各写一遍。
-->
