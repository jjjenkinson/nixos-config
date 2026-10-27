# Zed 快捷键

> Zed 1.25.2。`settings.json` 里开了 `helix_mode = true`：编辑键位是 **Helix 风格的
> 子集**，不是完整 Helix。键位分三层叠加，越具体越优先：
> Helix 专用键 → vim 通用键（`w` / `gg` / `Ctrl+O` 这些仍可用）→ Zed 默认键
> （vim 层没占用的键继续生效，所以 `F12`、`Ctrl+Shift+V` 之类照样能用）。
>
> ⚠️ 焦点在**编辑器**时 vim 层优先：`Ctrl+B/D/E/F/J/U/Y` 会变成翻页或滚动，
> 这时侧栏、搜索要用 `Ctrl+Shift+E` / `Ctrl+Shift+F`。焦点在侧栏或面板里才是默认行为。
>
> 默认键位来源：v1.25.2 的 `assets/keymaps/default-linux.json`、
> `specific-overrides.json`（Picker 与预览键只在这里）以及 `vim.json`（vim / Helix 层）。
>
> 权威表：`Ctrl+K Ctrl+S` 打开 Keymap 编辑器；`Alt+/` 可看多键前缀的后续候选。
>
> 表格约定：`| 键 | 作用 | English |`，第 3 列是英文；一行所有列（含段名）合计
> ≤110 列宽。`## ` 标题会作为速查里的段名。

## 预览

| 键                             | 作用                             | English             |
| ------------------------------ | -------------------------------- | ------------------- |
| `Ctrl+Shift+V`                 | 打开预览（Markdown / SVG / CSV） | Open preview        |
| `Ctrl+K V`                     | 在右侧打开预览                   | Preview to the side |
| `Ctrl+Alt+P`                   | Picker 内开关预览                | Toggle preview      |
| `Ctrl+Alt+→`                   | Picker 预览放到右侧              | Preview right       |
| `Ctrl+Alt+↓`                   | Picker 预览放到下方              | Preview below       |
| `Ctrl+Alt+↑`                   | 收起 Picker 预览                 | Hide preview        |
| `Ctrl+Shift+V`                 | 预览窗内：关预览回编辑器         | Close preview       |
| `Ctrl+F`                       | 预览窗内查找                     | Find in preview     |
| `PageUp` / `PageDown`          | 预览翻页                         | Page up / down      |
| `Alt+↑` / `Alt+↓`              | 按标题 / 元素滚动                | Scroll by item      |
| `Ctrl+Home` / `Ctrl+End`       | 预览顶部 / 底部                  | Top / bottom        |
| `Ctrl+=` / `Ctrl+-` / `Ctrl+0` | 图片放大 / 缩小 / 重置           | Zoom in/out/reset   |
| `Ctrl+1`                       | 图片原始尺寸                     | Actual size         |
| `Ctrl+Shift+0`                 | 图片适应窗口                     | Fit to view         |

> 同一个 `Ctrl+Shift+V` 有两个上下文：编辑器里是「打开预览」，
> 预览窗里是「关预览」。`Ctrl+K V` 只对 Markdown / SVG / CSV 这类可预览文件有效。

## 全局

| 键                             | 作用                     | English              |
| ------------------------------ | ------------------------ | -------------------- |
| `Ctrl+P` / `Ctrl+E`            | 文件搜索                 | File finder          |
| `Ctrl+Shift+P` / `F1`          | 命令面板                 | Command palette      |
| `Ctrl+N` / `Ctrl+Shift+N`      | 新建文件 / 新窗口        | New file / window    |
| `Ctrl+S` / `Ctrl+Shift+S`      | 保存 / 另存为            | Save / save as       |
| `Ctrl+K S`                     | 保存（不格式化）         | Save without format  |
| `Ctrl+Alt+S`                   | 全部保存                 | Save all             |
| `Ctrl+O`                       | 打开文件 / 文件夹        | Open files           |
| `Ctrl+K Ctrl+O`                | 打开（可输入路径）       | Open path            |
| `Ctrl+R` / `Alt+Ctrl+O`        | 最近项目（编辑器内重做） | Recent / redo        |
| `Alt+Ctrl+Shift+O`             | 打开远程项目             | Remote project       |
| `Ctrl+W`                       | 关闭当前编辑区           | Close item           |
| `Ctrl+Shift+T`                 | 恢复刚关闭的编辑区       | Reopen closed        |
| `Ctrl+,`                       | 打开设置                 | Settings             |
| `Ctrl+K Ctrl+S`                | 打开键位映射表           | Open keymap          |
| `Ctrl+Shift+X`                 | 扩展管理                 | Extensions           |
| `Ctrl+K Ctrl+T`                | 主题选择器               | Theme selector       |
| `Ctrl+K Ctrl+Shift+T`          | 切换浅色 / 深色          | Toggle light/dark    |
| `Ctrl+K M`                     | 语言选择器               | Language selector    |
| `Ctrl+K N`                     | 编码选择器               | Encoding             |
| `Ctrl+反引号`                  | 终端面板                 | Terminal panel       |
| `Ctrl+~`                       | 新建终端                 | New terminal         |
| `Ctrl+B`                       | 左侧栏（编辑器内翻页）   | Left dock / page up  |
| `Ctrl+J`                       | 底部面板（编辑器内下移） | Bottom dock / down   |
| `Ctrl+Alt+B`                   | 右侧栏                   | Right dock           |
| `Ctrl+Alt+J`                   | 工作区侧栏               | Workspace sidebar    |
| `Ctrl+Alt+Y`                   | 开关所有侧栏             | Toggle all docks     |
| `Ctrl+?`                       | AI 助手面板              | Agent panel          |
| `F11`                          | 全屏                     | Full screen          |
| `F6` / `Shift+F6`              | 焦点移到下 / 上一个区域  | Focus next/prev part |
| `Shift+Esc`                    | 当前编辑区最大化         | Toggle zoom          |
| `Ctrl+Q`                       | 退出                     | Quit                 |
| `F10`                          | 应用菜单                 | App menu             |
| `Ctrl+=` / `Ctrl+-` / `Ctrl+0` | 字体放大 / 缩小 / 重置   | Font size            |
| `Alt+/`                        | 多键前缀的后续候选       | Pending keys         |
| `Ctrl+Shift+R`                 | 重跑上次任务             | Rerun task           |
| `Alt+T`                        | 重跑上次任务             | Rerun task           |
| `Alt+Shift+T`                  | 选择任务并运行           | Spawn task           |
| `Alt+Shift+Enter`              | 运行 toast 里的动作      | Run toast action     |

## Picker

> Picker 是文件搜索、命令面板、最近项目、分支选择这类**列表界面**的统称。
> 下面这组键只在 Picker 的输入框里生效（`specific-overrides.json` 优先级最高）；
> 带「文件搜索」「文本查找」的几项只属于各自的 Picker。

| 键                              | 作用                                | English              |
| ------------------------------- | ----------------------------------- | -------------------- |
| `↑` / `↓` / `Ctrl+P` / `Ctrl+N` | 移动选中                            | Move selection       |
| `PageUp` / `PageDown`           | 翻页                                | Page up / down       |
| `Home` / `End`                  | 首项 / 末项                         | First / last         |
| `Enter`                         | 确认                                | Confirm              |
| `Ctrl+Enter`                    | 次要确认                            | Secondary confirm    |
| `Alt+Enter`                     | 用输入内容确认                      | Confirm input        |
| `Esc` / `Ctrl+Esc`              | 取消                                | Cancel               |
| `Tab`                           | 下一个 / 文件搜索：多选下一个       | Next / multi-select  |
| `Shift+Tab`                     | 上一个                              | Previous             |
| `Ctrl+Shift+S`                  | 切换多重选择                        | Toggle multi-select  |
| `Ctrl+Shift+A`                  | 切换动作菜单                        | Toggle actions menu  |
| `Ctrl+Shift+P`                  | 文件搜索：上一个                    | File finder previous |
| `Ctrl+J` / `Ctrl+K`             | 文件搜索 / 文本查找：下 / 上分屏    | Split down / up      |
| `Ctrl+H` / `Ctrl+L`             | 文件搜索 / 文本查找：左 / 右分屏    | Split left / right   |
| `Ctrl+Alt+F`                    | 文本查找：转到项目搜索              | To project search    |
| `Ctrl+{` / `Ctrl+}`             | 文本查找：折叠 / 展开               | Fold / unfold        |
| `Ctrl+Shift+Enter`              | 文本查找：折叠全部结果              | Toggle fold all      |
| `Ctrl+Alt+P` 等                 | 有预览时开关 / 换位置（见「预览」） | Preview keys         |
| `Ctrl+K`                        | 最近项目：动作菜单                  | Recent actions       |
| `Shift+Backspace`               | 从列表移除选中项                    | Remove selected      |
| `Ctrl+Shift+Enter`              | 最近项目：加入当前工作区            | Add to workspace     |
| `Ctrl+Shift+I`                  | 文件搜索：包含忽略文件              | Include ignored      |
| `Alt+Ctrl+Shift+O`              | 打开已有远程连接                    | Remote connection    |

> `Ctrl+Shift+S` 在 Workspace 里是另存为，只在 Picker 里才是多选。

## 跳转

| 键                              | 作用                     | English                 |
| ------------------------------- | ------------------------ | ----------------------- |
| `F12`                           | 跳到定义                 | Definition              |
| `Alt+F12`                       | 分屏打开定义             | Definition in split     |
| `Ctrl+F12`                      | 跳到类型定义             | Type definition         |
| `Alt+Ctrl+F12`                  | 分屏打开类型定义         | Type in split           |
| `Shift+F12`                     | 跳到实现                 | Implementation          |
| `Alt+Shift+F12`                 | 查找全部引用             | All references          |
| `g d`                           | 跳到定义（同 F12）       | Definition              |
| `g y`                           | 跳到类型定义             | Type definition         |
| `g Shift+I`                     | 跳到实现                 | Implementation          |
| `g r r`                         | 查找全部引用             | All references          |
| `g r n`                         | 重命名符号               | Rename symbol           |
| `g r a`                         | 代码操作菜单             | Code actions            |
| `Ctrl+O` / `Ctrl+I`             | 后退 / 前进              | Back / forward          |
| `Ctrl+Alt+-` / `Ctrl+Alt+_`     | 后退 / 前进              | Back / forward          |
| `G`                             | 跳到指定行               | Go to line              |
| `Ctrl+G`                        | 显示文件与位置信息       | Show location           |
| `gg` / `g e`                    | 文件开头 / 结尾          | File start / end        |
| `g h` / `g l` / `g s`           | 行首 / 行尾 / 首个非空白 | Line start/end/first    |
| `g t` / `g c` / `g b`           | 窗口顶 / 中 / 底         | Window top/mid/bot      |
| `F8` / `Shift+F8`               | 下一个 / 上一个诊断      | Next / prev diag        |
| `g ]` / `g [`                   | 下一个 / 上一个诊断      | Next / prev diag        |
| `Space d`                       | 跳到下一个诊断           | Next diagnostic         |
| `Ctrl+Shift+O`                  | 文件内符号大纲           | File symbols            |
| `Space s` / `Space Shift+S`     | 文件符号 / 项目符号      | File / project syms     |
| `Ctrl+Shift+E`                  | 项目文件树               | Project panel           |
| `Ctrl+Shift+B`                  | 大纲面板                 | Outline panel           |
| `Ctrl+Shift+G`                  | Git 面板                 | Git panel               |
| `Ctrl+Shift+M`                  | 诊断面板                 | Diagnostics panel       |
| `Ctrl+Shift+D`                  | 调试面板                 | Debug panel             |
| `g a` / `Ctrl+^`                | 头文件与源文件互跳       | Alternate file          |
| `g .`                           | 跳到上次修改处           | Last modification       |
| `g ;` / `g ,`                   | 改动列表 旧 / 新         | Change list older/newer |
| `g n` / `g p`                   | 下一个 / 上一个标签      | Next / prev tab         |
| `Shift+L` / `Shift+H`           | 下一个 / 上一个标签      | Next / prev tab         |
| `Ctrl+PageDown` / `Ctrl+PageUp` | 下一个 / 上一个标签      | Next / prev tab         |
| `g w`                           | 跳到指定词（Helix）      | Jump to word            |
| `Ctrl+W d`                      | 分屏打开定义             | Definition in split     |
| `Ctrl+W Shift+D`                | 分屏打开类型定义         | Type in split           |
| `m m`                           | 跳到匹配括号             | Matching bracket        |
| `Ctrl+K Ctrl+H`                 | 查看调用者               | Incoming calls          |
| `Ctrl+F8` / `Alt+,`             | 下一个 / 上一个改动块    | Next / prev hunk        |
| `Alt+Shift+←/→`                 | 缩小 / 扩大语法节点      | Node smaller/larger     |
| `Alt+O` / `Alt+I`               | 扩大 / 缩小语法节点      | Node larger/smaller     |
| `Alt+P` / `Alt+N`               | 上一个 / 下一个语法节点  | Prev / next node        |
| `Alt+B` / `Alt+E`               | 大节点开头 / 结尾        | Big node start/end      |
| `]` / `[`                       | 下一个 / 上一个对象      | Next / prev object      |
| `Ctrl+K Ctrl+B`                 | Git blame（悬停）        | Git blame hover         |
| `Ctrl+K Ctrl+P`                 | 重开上次 Picker          | Reopen last picker      |

## 搜索

| 键                          | 作用                       | English             |
| --------------------------- | -------------------------- | ------------------- |
| `Ctrl+Shift+F`              | 项目内搜索                 | Project search      |
| `Ctrl+Shift+H`              | 项目内搜索并替换           | Project replace     |
| `Ctrl+F`                    | 文件内查找（编辑器内翻页） | Find / page down    |
| `Ctrl+H`                    | 查找并替换（搜索栏内）     | Find and replace    |
| `/`                         | 编辑器内搜索               | Search              |
| `?`                         | 向上搜索                   | Search backward     |
| `n` / `Shift+N`             | 选中下一个 / 上一个匹配    | Next / prev match   |
| `*`                         | 用选区内容搜索             | Search selection    |
| `Space /`                   | 项目内搜索（Helix）        | Project search      |
| `g /`                       | 项目内搜索（vim）          | Project search      |
| `Alt+Enter`                 | 选中全部匹配               | Select all matches  |
| `Ctrl+Shift+Enter`          | 展开 / 收起全部结果        | Toggle all results  |
| `Alt+C` / `Alt+W` / `Alt+R` | 搜索栏内 大小写/整词/正则  | Case / word / regex |

## 滚动

| 键                  | 作用                | English           |
| ------------------- | ------------------- | ----------------- |
| `Ctrl+D` / `Ctrl+U` | 下 / 上翻半页       | Half page down/up |
| `Ctrl+E` / `Ctrl+Y` | 下 / 上滚一行       | Line down / up    |
| `z t` / `z b`       | 光标行到顶部 / 底部 | Cursor top/bottom |
| `z z` / `z c`       | 光标行居中          | Center line       |

## 编辑

| 键                                | 作用                      | English               |
| --------------------------------- | ------------------------- | --------------------- |
| `i` / `a`                         | 光标前 / 后插入           | Insert before/after   |
| `Shift+I` / `Shift+A`             | 行首 / 行尾插入           | Insert at edges       |
| `o` / `Shift+O`                   | 下方 / 上方新行插入       | Open line             |
| `Esc` / `Ctrl+[`                  | 回到普通模式              | Normal mode           |
| `v`                               | 切换到选择模式            | Select mode           |
| `h` / `l`                         | 左 / 右（可跨行）         | Left / right          |
| `j` / `k`                         | 下 / 上（按显示行）       | Down / up             |
| `g j` / `g k`                     | 下 / 上（按逻辑行）       | Down / up logical     |
| `w` / `b` / `e`                   | 下个词 / 上个词 / 词尾    | Word motions          |
| `W` / `B` / `E`                   | 同上，但按空白分词        | Same, by WORD         |
| `0` / `$`                         | 行首 / 行尾               | Line start / end      |
| `f` / `t`                         | 向后找字符（停前 / 停后） | Find char             |
| `Shift+F` / `Shift+T`             | 向前找字符                | Find char backward    |
| `Alt+.`                           | 重复上次字符查找          | Repeat find           |
| `d` / `c`                         | 删除 / 修改选区           | Delete / change       |
| `Alt+D` / `Alt+C`                 | 删除 / 修改但不复制       | Delete/change no yank |
| `y` / `p` / `Shift+P`             | 复制 / 粘贴后 / 粘贴前    | Yank / paste          |
| `Shift+R`                         | 从系统剪贴板粘贴          | Paste from clipboard  |
| `x`                               | 选中整行                  | Select line           |
| `%`                               | 全选                      | Select all            |
| `s`                               | 正则选择                  | Select regex          |
| `u` / `Ctrl+R`                    | 撤销 / 重做               | Undo / redo           |
| `~`                               | 切换选中文字大小写        | Toggle case           |
| `反引号` / `Alt+反引号`           | 转小写 / 大写             | Lower / upper case    |
| `>` / `<` / `=`                   | 缩进 / 反缩进 / 自动缩进  | Indent/dedent/fmt     |
| `Shift+C` / `Alt+Shift+C`         | 向下 / 向上复制选区       | Duplicate down/up     |
| `Alt+S`                           | 按行拆分选区              | Split into lines      |
| `_`                               | 去掉选区首尾空白          | Trim whitespace       |
| `,`                               | 只保留最新选区            | Keep newest           |
| `;` / `Alt+;`                     | 折叠选区 / 跳到另一端     | Collapse / other end  |
| `q` / `Shift+Q`                   | 回放 / 录制宏             | Replay / record       |
| `:`                               | 命令面板                  | Command palette       |
| `Ctrl+S`                          | 保存并记住位置            | Save location         |
| `Ctrl+Enter` / `Ctrl+Shift+Enter` | 下方 / 上方新行（默认层） | Newline below/above   |

## 插入模式

| 键                  | 作用                         | English                |
| ------------------- | ---------------------------- | ---------------------- |
| `Esc` / `Ctrl+C`    | 回到普通模式                 | Normal mode            |
| `Ctrl+O`            | 临时普通模式（执行一个命令） | One normal command     |
| `Ctrl+X Ctrl+O`     | 补全菜单                     | Completions            |
| `Ctrl+P` / `Ctrl+N` | 从缓冲区按词补全             | Word completion        |
| `Ctrl+X Ctrl+A`     | 行内 AI 助手                 | Inline assist          |
| `Ctrl+S`            | 函数签名提示                 | Signature help         |
| `Ctrl+W` / `Ctrl+U` | 删前一个词 / 删到行首        | Delete word / to start |
| `Ctrl+T` / `Ctrl+D` | 缩进 / 反缩进                | Indent / outdent       |
| `Ctrl+Y` / `Ctrl+E` | 复制上一行 / 下一行          | Copy line above/below  |
| `Ctrl+R`            | 插入寄存器内容               | Insert register        |

## 选择

| 键              | 作用              | English            |
| --------------- | ----------------- | ------------------ |
| `Shift+Alt+↑/↓` | 向上 / 向下加光标 | Add cursor         |
| `Ctrl+K Ctrl+D` | 加选下一个相同词  | Select next match  |
| `Ctrl+Shift+L`  | 选中全部相同词    | Select all matches |
| `Space h`       | 选中全部相同词    | Select all matches |

## Space 菜单

| 键                                    | 作用                 | English              |
| ------------------------------------- | -------------------- | -------------------- |
| `Space f`                             | 文件搜索             | File finder          |
| `Space b`                             | 标签切换             | Tab switcher         |
| `Space /`                             | 项目内搜索           | Project search       |
| `Space s` / `Space Shift+S`           | 文件符号 / 项目符号  | File / project syms  |
| `Space d`                             | 下一个诊断           | Next diagnostic      |
| `Space a`                             | 代码操作菜单         | Code actions         |
| `Space r`                             | 重命名符号           | Rename symbol        |
| `Space k`                             | 悬停文档             | Hover docs           |
| `Space c`                             | 注释 / 取消注释      | Toggle comment       |
| `Space y` / `Space p`                 | 复制 / 粘贴          | Copy / paste         |
| `Space w v` / `Space w s`             | 垂直 / 水平分屏      | Split vertical/horiz |
| `Space w h/j/k/l`                     | 焦点移到 左/下/上/右 | Focus pane           |
| `Space w q`                           | 关闭当前编辑区       | Close item           |
| `Space Shift+G b`                     | 切换断点             | Toggle breakpoint    |
| `Space Shift+G l` / `Space Shift+G r` | 启动 / 重启调试      | Start / restart      |
| `Space Shift+G c` / `Space Shift+G h` | 继续 / 暂停          | Continue / pause     |
| `Space Shift+G n` / `Space Shift+G i` | 单步跳过 / 单步进入  | Step over / into     |
| `Space Shift+G o` / `Space Shift+G t` | 单步跳出 / 停止      | Step out / stop      |
| `Space Shift+G Ctrl+L`                | 编辑日志断点         | Log breakpoint       |

## 窗口与标签

| 键                                          | 作用                      | English             |
| ------------------------------------------- | ------------------------- | ------------------- |
| `Ctrl+Tab` / `Ctrl+Shift+Tab`               | 标签切换器（后 / 前）     | Tab switcher        |
| `Ctrl+PageDown` / `Ctrl+PageUp`             | 下一个 / 上一个标签       | Next / prev tab     |
| `Alt+1…9`                                   | 跳到第 1–9 个编辑区       | Activate pane N     |
| `Alt+0`                                     | 最后一个编辑区            | Last pane           |
| `Ctrl+\`                                    | 向右分屏                  | Split right         |
| `Ctrl+K ←/→/↑/↓`                            | 向 左/右/上/下 分屏       | Split direction     |
| `Ctrl+K Ctrl+←/→`                           | 焦点移到 左 / 右编辑区    | Focus pane L/R      |
| `Ctrl+K Ctrl+↑/↓`                           | 焦点移到 上 / 下编辑区    | Focus pane U/D      |
| `Ctrl+K Shift+←/→/↑/↓`                      | 把编辑区往 左/右/上/下 移 | Swap pane           |
| `Ctrl+W` / `Ctrl+F4`                        | 关闭当前标签              | Close item          |
| `Alt+Ctrl+T`                                | 关闭其他标签              | Close others        |
| `Ctrl+K E` / `Ctrl+K T`                     | 关闭左侧 / 右侧标签       | Close left / right  |
| `Ctrl+K U`                                  | 关闭所有未修改的编辑区    | Close clean items   |
| `Ctrl+K W`                                  | 关闭全部编辑区            | Close all items     |
| `Ctrl+K Ctrl+W`                             | 关闭所有标签与窗格        | Close all           |
| `Ctrl+K Shift+Enter`                        | 固定 / 取消固定标签       | Pin tab             |
| `Ctrl+Shift+T`                              | 恢复刚关闭的标签          | Reopen closed       |
| `Ctrl+Shift+W`                              | 关闭窗口                  | Close window        |
| `Ctrl+Shift+PageDown` / `Ctrl+Shift+PageUp` | 标签右 / 左移             | Move tab right/left |
| `Shift+Z Shift+Q`                           | 关闭且不保存              | Close without save  |
| `Shift+Z Shift+Z`                           | 保存并关闭                | Save and close      |

## 终端

| 键                                | 作用                | English              |
| --------------------------------- | ------------------- | -------------------- |
| `Ctrl+反引号`                     | 打开 / 关闭终端面板 | Terminal panel       |
| `Ctrl+~`                          | 新建终端            | New terminal         |
| `Ctrl+Shift+C` / `Ctrl+Shift+V`   | 复制 / 粘贴         | Copy / paste         |
| `Ctrl+Shift+Space`                | 进入 vi 模式        | Vi mode              |
| `Ctrl+Shift+L`                    | 清屏                | Clear                |
| `Ctrl+Shift+F`                    | 终端内搜索          | Search terminal      |
| `Ctrl+Shift+R` / `Alt+T`          | 重跑上次任务        | Rerun task           |
| `Ctrl+Shift+W`                    | 关闭终端            | Close terminal       |
| `Shift+PageUp` / `Shift+PageDown` | 向上 / 向下翻页     | Scroll page up/down  |
| `Shift+Home` / `Shift+End`        | 滚到顶部 / 底部     | Scroll to top/bottom |
| `Ctrl+Shift+5`                    | 向右分屏            | Split right          |

## 调试

| 键                 | 作用         | English           |
| ------------------ | ------------ | ----------------- |
| `F4`               | 开始调试     | Start             |
| `F5`               | 继续 / 重跑  | Continue / rerun  |
| `F6`               | 暂停         | Pause             |
| `Shift+F5`         | 停止         | Stop              |
| `F7` / `F10`       | 单步跳过     | Step over         |
| `F11` / `Ctrl+F11` | 单步进入     | Step into         |
| `Shift+F11`        | 单步跳出     | Step out          |
| `Ctrl+Shift+F5`    | 重启调试会话 | Rerun session     |
| `F9`               | 切换断点     | Toggle breakpoint |
| `Shift+F9`         | 编辑日志断点 | Log breakpoint    |

> 这些键只在调试会话里接管；其余时候 `F5` 是重跑、`F6` 是切换焦点、
> `F10` 是应用菜单、`F11` 是全屏。

## AI 助手

| 键                  | 作用                 | English           |
| ------------------- | -------------------- | ----------------- |
| `Ctrl+?`            | 打开 / 关闭助手面板  | Agent panel       |
| `Ctrl+N`            | 新建线程             | New thread        |
| `Enter`             | 发送消息             | Send              |
| `Ctrl+Enter`        | 发送并跟随           | Send and follow   |
| `Ctrl+Shift+Enter`  | 立即发送（跳过排队） | Send immediately  |
| `Ctrl+I`            | 配置文件选择器       | Profile selector  |
| `Shift+Tab`         | 循环切换模式         | Cycle mode        |
| `Ctrl+Alt+/`        | 模型选择器           | Model selector    |
| `Alt+L` / `Alt+Tab` | 循环收藏模型         | Cycle favorite    |
| `Ctrl+Alt+K`        | 思考模式开关         | Thinking mode     |
| `Ctrl+Alt+.`        | 快速模式开关         | Fast mode         |
| `Ctrl+Alt+Shift+N`  | 新线程菜单           | New thread menu   |
| `Ctrl+Alt+C`        | 助手设置             | Agent settings    |
| `Ctrl+-`            | 返回上一级           | Go back           |
| `Ctrl+F`            | 线程内搜索           | Search thread     |
| `F3` / `Shift+F3`   | 下 / 上一个匹配      | Next / prev match |
| `Ctrl+>`            | 把选区加入线程       | Add selection     |

## 编辑预测

| 键                  | 作用                | English            |
| ------------------- | ------------------- | ------------------ |
| `Alt+\`             | 显示预测            | Show prediction    |
| `Alt+]` / `Alt+[`   | 下一个 / 上一个预测 | Next / prev        |
| `Alt+Tab` / `Alt+L` | 接受整个预测        | Accept             |
| `Alt+K`             | 接受下一个词        | Accept next word   |
| `Alt+J`             | 接受下一行          | Accept next line   |
| `Ctrl+Alt+Shift+E`  | 开关编辑预测        | Toggle predictions |

## 代码与 Git

| 键                                | 作用                       | English             |
| --------------------------------- | -------------------------- | ------------------- |
| `Ctrl+/`                          | 注释 / 取消注释            | Toggle comment      |
| `Ctrl+K Ctrl+/`                   | 块注释                     | Block comment       |
| `Ctrl+C`                          | 普通模式注释；插入模式复制 | Comment / copy      |
| `=`                               | 格式化所选内容             | Format selection    |
| `Ctrl+Shift+I`                    | 格式化整个文件             | Format file         |
| `Alt+Shift+O`                     | 整理 import                | Organize imports    |
| `F2` / `Space r`                  | 重命名符号                 | Rename symbol       |
| `Ctrl+.`                          | 代码操作菜单               | Code actions        |
| `Ctrl+Space`                      | 触发补全                   | Completions         |
| `Ctrl+Shift+Space`                | 仅按词补全                 | Word completions    |
| `Ctrl+K Ctrl+L`                   | 折叠 / 展开当前块          | Toggle fold         |
| `Ctrl+{` / `Ctrl+}`               | 折叠 / 展开所选行          | Fold / unfold       |
| `Ctrl+K Ctrl+0` / `Ctrl+K Ctrl+J` | 全部折叠 / 全部展开        | Fold / unfold all   |
| `z Shift+M` / `z Shift+R`         | 全部折叠 / 全部展开（vim） | Fold / unfold all   |
| `Ctrl+M`                          | 跳到包围括号               | Enclosing bracket   |
| `Ctrl+K Z`                        | 自动换行开关               | Toggle soft wrap    |
| `Shift+K`                         | 悬停文档                   | Hover docs          |
| `Ctrl+K Ctrl+I`                   | 悬停文档                   | Hover docs          |
| `Shift+J`                         | 合并行                     | Join lines          |
| `Shift+D`                         | 删除到行尾                 | Delete to line end  |
| `Alt+↑` / `Alt+↓`                 | 上移 / 下移当前行          | Move line up/down   |
| `Ctrl+Alt+Shift+↑/↓`              | 向上 / 向下复制当前行      | Duplicate line      |
| `Ctrl+Shift+K`                    | 删除整行                   | Delete line         |
| `Ctrl+K R`                        | 在文件管理器中显示         | Reveal in files     |
| `Ctrl+K P`                        | 复制文件路径               | Copy path           |
| `Alt+Enter`                       | 在多缓冲区打开选区         | Open excerpts       |
| `Ctrl+Alt+Enter`                  | 分屏打开选区               | Open excerpts split |
| `Alt+G B`                         | 显示 Git blame             | Git blame           |
| `Alt+G M`                         | 打开所有改动文件           | Modified files      |
| `Alt+G R`                         | 审阅改动                   | Review diff         |
| `g o`                             | 显示 / 隐去当前改动块      | Toggle diff hunk    |
| `g u` / `g Shift+U`               | 暂存 / 取消暂存并下一个    | Stage / unstage     |
| `g Shift+R`                       | 还原改动块                 | Restore hunk        |
| `Ctrl+K Ctrl+R`                   | 还原当前改动块             | Restore hunk        |
| `Ctrl+Space`                      | 暂存全部（Git 面板）       | Stage all           |
| `Ctrl+Shift+Space`                | 取消暂存全部               | Unstage all         |
| `Ctrl+Enter` / `Ctrl+Shift+Enter` | 提交 / 修补提交            | Commit / amend      |
| `Alt+L`                           | 生成提交信息（提交框）     | Generate message    |
| `Ctrl+G Ctrl+G`                   | Fetch（Git 面板）          | Fetch               |
| `Ctrl+G ↑` / `Ctrl+G ↓`           | Push / pull                | Push / pull         |
| `Ctrl+G Shift+↓`                  | Pull --rebase              | Pull rebase         |
| `Ctrl+G Shift+↑`                  | Force push                 | Force push          |
