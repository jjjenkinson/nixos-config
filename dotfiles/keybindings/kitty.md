# Kitty 快捷键

> kitty 0.49.1。`kitty_mod` 是 **`Ctrl+Shift`**（默认值，本仓库没改）。
> 本仓库（`home/common/shell.nix`）只相对默认改了两处：`Ctrl+Shift+W` 从
> 「关闭分屏」改成「关闭标签」，并新增 `Alt+1..9` 跳标签；其余都是默认值。
> 默认表的权威来源：`kitty +runpy 'from kitty.config import *; print(commented_out_default_config())'`。
>
> 表格约定：`| 键 | 作用 | English |`，第 3 列是英文；一行所有列（含段名）合计
> ≤110 列宽（速查窗口里超宽会被 fzf 截断）。`## ` 标题会作为速查里的段名。

## 标签

| 键                            | 作用                      | English             |
| ----------------------------- | ------------------------- | ------------------- |
| `Ctrl+Shift+T`                | 新建标签页                | New tab             |
| `Ctrl+Shift+W`                | 关闭标签页（本机改）      | Close tab (custom)  |
| `Ctrl+Shift+Q`                | 关闭标签页（kitty 默认）  | Close tab (stock)   |
| `Ctrl+Shift+→` / `←`          | 下一个 / 上一个标签       | Next / prev tab     |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | 同上                      | Same                |
| `Ctrl+Shift+.` / `,`          | 标签右移 / 左移           | Move tab right/left |
| `Alt+1…9`                     | 跳到第 1–9 个标签（本机） | Go to tab 1-9       |
| `Ctrl+Shift+Alt+T`            | 重命名当前标签页          | Set tab title       |

> `Ctrl+Shift+W` 被本机改成关标签后，kitty 默认的「关闭分屏」快捷键就空缺了；
> 要一次关掉整个标签（连同它的所有分屏）用 `Ctrl+Shift+Q`。

## 窗口

| 键                       | 作用                       | English               |
| ------------------------ | -------------------------- | --------------------- |
| `Ctrl+Shift+Enter`       | 新建分屏                   | New window            |
| `Ctrl+Shift+N`           | 新建 OS 窗口               | New OS window         |
| `Ctrl+Shift+]` / `[`     | 下一个 / 上一个分屏        | Next / prev window    |
| `Ctrl+Shift+F` / `B`     | 分屏前移 / 后移            | Move window fwd/back  |
| `Ctrl+Shift+反引号`      | 分屏移到最前               | Window to top         |
| `Ctrl+Shift+R`           | 进入缩放模式（方向键调整） | Resize window         |
| `Ctrl+Shift+1…0`         | 跳到第 1–10 个分屏         | Window 1-10           |
| `Ctrl+Shift+F7` / `F8`   | 聚焦可见分屏 / 与它交换    | Focus / swap          |
| `Ctrl+Shift+F10` / `F11` | 最大化 / 全屏              | Maximize / fullscreen |
| `Ctrl+Shift+L`           | 切换分屏布局               | Next layout           |

## 剪贴板

| 键                   | 作用                       | English         |
| -------------------- | -------------------------- | --------------- |
| `Ctrl+Shift+C` / `V` | 复制 / 粘贴                | Copy / paste    |
| `Shift+Insert`       | 粘贴 X11 主选区            | Paste selection |
| `Ctrl+Shift+S`       | 同上                       | Paste selection |
| `Ctrl+Shift+O`       | 用系统默认程序打开选区内容 | Open selection  |

## 滚动与搜索

| 键                         | 作用                          | English             |
| -------------------------- | ----------------------------- | ------------------- |
| `Ctrl+Shift+↑` / `↓`       | 上 / 下滚一行（`K` / `J` 同） | Scroll one line     |
| `Ctrl+Shift+PgUp` / `PgDn` | 上 / 下翻页                   | Scroll page         |
| `Ctrl+Shift+Home` / `End`  | 滚到顶部 / 底部               | Scroll top/bottom   |
| `Ctrl+Shift+Z` / `X`       | 跳到上 / 下一个命令提示符     | Jump to prompt      |
| `Ctrl+Shift+H`             | 在分页器里看回滚缓冲区        | Open scrollback     |
| `Ctrl+Shift+G`             | 只看上一条命令的输出          | Last command output |
| `Ctrl+Shift+/`             | 搜索回滚内容                  | Search scrollback   |

## 字号与外观

| 键                            | 作用                   | English         |
| ----------------------------- | ---------------------- | --------------- |
| `Ctrl+Shift+=` / `-`          | 字号 +2 / −2           | Font size +/-   |
| `Ctrl+Shift+Backspace`        | 字号还原               | Font reset      |
| `Ctrl+Shift+A` 然后 `M` / `L` | 背景不透明度 + / − 0.1 | Opacity +/-     |
| `Ctrl+Shift+A` 然后 `1`       | 背景完全不透明         | Opacity 100%    |
| `Ctrl+Shift+A` 然后 `D`       | 背景恢复默认           | Opacity default |

## 打开与工具

| 键                            | 作用                      | English           |
| ----------------------------- | ------------------------- | ----------------- |
| `Ctrl+Shift+E`                | 用 hints 打开终端里的 URL | Open URL          |
| `Ctrl+Shift+P` 然后 `F`       | 选文件路径并输出到终端    | Hint: path        |
| `Ctrl+Shift+P` 然后 `Shift+F` | 选文件路径并打开          | Hint: open path   |
| `Ctrl+Shift+P` 然后 `L`       | 选一行输出到终端          | Hint: line        |
| `Ctrl+Shift+P` 然后 `W`       | 选一个词输出到终端        | Hint: word        |
| `Ctrl+Shift+P` 然后 `H`       | 选一个 hash 输出到终端    | Hint: hash        |
| `Ctrl+Shift+P` 然后 `N`       | 选行号并跳到对应行        | Hint: line number |
| `Ctrl+Shift+P` 然后 `Y`       | 选超链接并打开            | Hint: hyperlink   |
| `Ctrl+Shift+P` 然后 `C` / `D` | 选文件 / 选目录           | Hint: file / dir  |
| `Ctrl+Shift+U`                | Unicode 字符输入          | Unicode input     |
| `Ctrl+Shift+F3`               | 命令面板                  | Command palette   |

## 配置

| 键                  | 作用                | English        |
| ------------------- | ------------------- | -------------- |
| `Ctrl+Shift+F2`     | 编辑 kitty.conf     | Edit config    |
| `Ctrl+Shift+F5`     | 重新加载配置        | Reload config  |
| `Ctrl+Shift+F6`     | 打印当前生效的配置  | Debug config   |
| `Ctrl+Shift+F1`     | 查看 kitty 自带文档 | Kitty docs     |
| `Ctrl+Shift+Delete` | 清屏并重置终端      | Clear terminal |
| `Ctrl+Shift+Escape` | 打开 kitty shell    | Kitty shell    |

> `Ctrl+Shift+P`、`Ctrl+Shift+A` 是**前缀**：按下后松开，再按后面那个键。
> 分屏布局只有 `Ctrl+Shift+L`（默认的 tall / fat / grid / splits 循环）。
