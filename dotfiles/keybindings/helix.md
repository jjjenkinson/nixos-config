# Helix 快捷键

> Helix 25.07.1。`dotfiles/helix/config.toml` 只改了主题、行号、软换行和剪贴板
> 寄存器，**没有改任何键位**；`home/common/helix.nix` 也只建软链。所以下表全是
> 官方默认键位，来源是 Helix 25.07.1 的 `keymap/default.rs`（运行时可用
> `:help keymap` 查看，但本机包的 runtime 没带 doc，直接看源码更可靠）。
>
> ⚠️ 和 Vim 容易记混的地方：
> `0` **没有绑定**，`$` 是 `shell_keep_pipe` —— 两者都不是行首 / 行尾；
> 行首行尾用 `Home` / `End` 或 `gh` / `gl`。
> `G` 是「跳到行号」（无计数时到最后一行）、`gg` 是文件开头、`ge` 才是文件末尾；
> `Q` 录制宏、`q` 回放宏，和 Vim 正好相反；`Tab` 等同 `Ctrl+i`（跳转前进）。
> 保存用 `:w`，`Ctrl+S` 是「把位置存进跳转列表」。
>
> 表格约定：`| 键 | 作用 | English |`，第 3 列是英文；一行所有列（含段名）合计
> ≤110 列宽（AGENTS.md 要求 ≤120，这里留余量，免得速查窗口截断）。
> `## ` 标题会作为速查里的段名。

## 模式

| 键        | 作用                        | English             |
| --------- | --------------------------- | ------------------- |
| `i` / `a` | 光标前 / 后进入插入模式     | Insert before/after |
| `I` / `A` | 行首 / 行尾进入插入模式     | Insert at edges     |
| `o` / `O` | 下方 / 上方新行并插入       | Open line           |
| `v`       | 选择（扩展）模式            | Select mode         |
| `Esc`     | 回到普通模式                | Normal mode         |
| `g`       | 进入跳转模式（前缀）        | Goto mode           |
| `m`       | 进入匹配 / 对象模式（前缀） | Match mode          |
| `z` / `Z` | 视图滚动模式 / 常驻版       | View mode           |
| `Ctrl+W`  | 窗口模式（前缀）            | Window mode         |
| `Space`   | Space 菜单（前缀）          | Space menu          |
| `:`       | 命令行                      | Command line        |

## 移动

| 键                    | 作用                                 | English                |
| --------------------- | ------------------------------------ | ---------------------- |
| `h` `j` `k` `l`       | 左 / 下 / 上 / 右                    | Move cursor            |
| `w` / `b` / `e`       | 下一个词 / 上一个词 / 词尾           | Word motions           |
| `W` / `B` / `E`       | 同上，但按空白分词                   | Same, by WORD          |
| `f` / `t`             | 向后找字符（停在 / 停前面）          | Find char              |
| `F` / `T`             | 向前找字符（同上两种停法）           | Find char back         |
| `Alt+.`               | 重复上次查找 / 对象跳转              | Repeat motion          |
| `Home` / `End`        | 行首 / 行尾                          | Line start/end         |
| `gh` / `gl` / `gs`    | 行首 / 行尾 / 首个非空白             | Line start/end/first   |
| `gg` / `G`            | 文件开头 / 跳到指定行                | File start / goto line |
| `ge`                  | 文件末尾                             | File end               |
| `g j` / `g k`         | 下 / 上一个逻辑行                    | Down / up logical line |
| `Ctrl+b` / `Ctrl+f`   | 上 / 下翻整页                        | Page up/down           |
| `Ctrl+u` / `Ctrl+d`   | 上 / 下翻半页                        | Half page              |
| `Ctrl+o` / `Ctrl+i`   | 跳转列表 后退 / 前进（`Tab` 同前进） | Jump back/forward      |
| `Ctrl+s`              | 把当前位置存进跳转列表               | Save to jumplist       |
| `Alt+b` / `Alt+e`     | 大语法节点开头 / 结尾                | Node start/end         |
| `Alt+o` / `Alt+i`     | 扩大 / 缩小语法节点                  | Node expand/shrink     |
| `Alt+p` / `Alt+n`     | 上一个 / 下一个兄弟节点              | Prev / next node       |
| `Alt+a` / `Alt+I`     | 选中所有兄弟 / 子节点                | All siblings/children  |
| `g t` / `g c` / `g b` | 窗口顶 / 中 / 底                     | Window top/mid/bottom  |
| `g w`                 | 按标签跳词                           | Jump to word           |

## 选择

| 键                | 作用                        | English                |
| ----------------- | --------------------------- | ---------------------- |
| `x` / `X`         | 选中当前行 / 扩到整行       | Select line            |
| `Alt+x`           | 缩回到整行边界              | Shrink to line bounds  |
| `%`               | 全选                        | Select all             |
| `s` / `S`         | 正则选择 / 按正则拆成多选区 | Regex split            |
| `Alt+s`           | 按换行拆成多选区            | Split on newlines      |
| `C` / `Alt+C`     | 向下 / 向上加光标           | Add cursor below/above |
| `,` / `Alt+,`     | 只留主选区 / 删掉主选区     | Keep / remove primary  |
| `;` / `Alt+;`     | 折叠到光标 / 翻转选区两端   | Collapse / flip        |
| `(` / `)`         | 轮换主选区                  | Rotate selection       |
| `K` / `Alt+K`     | 保留 / 移除匹配正则的选区   | Keep / remove matching |
| `&`               | 按列对齐选区                | Align selections       |
| `_`               | 去掉选区首尾空白            | Trim whitespace        |
| `Alt+-` / `Alt+_` | 合并选区 / 合并相邻选区     | Merge selections       |

## 编辑

| 键                      | 作用                       | English               |
| ----------------------- | -------------------------- | --------------------- |
| `d` / `Alt+d`           | 删除选区 / 删除但不复制    | Delete                |
| `c` / `Alt+c`           | 修改选区 / 修改但不复制    | Change                |
| `y` / `p` / `P`         | 复制 / 粘贴后 / 粘贴前     | Yank / paste          |
| `R`                     | 用复制的内容替换选区       | Replace with yank     |
| `r`                     | 替换为单个字符             | Replace char          |
| `"` 然后寄存器名        | 选择寄存器                 | Select register       |
| `~`                     | 切换选中文字大小写         | Toggle case           |
| `反引号` / `Alt+反引号` | 转小写 / 大写              | Lower / upper case    |
| `>` / `<` / `=`         | 缩进 / 反缩进 / 格式化     | Indent/dedent/format  |
| `J` / `Alt+J`           | 合并行 / 合并并选中空格    | Join lines            |
| `u` / `U`               | 撤销 / 重做                | Undo / redo           |
| `Alt+u` / `Alt+U`       | 历史 后退 / 前进           | Earlier / later       |
| `Ctrl+a` / `Ctrl+x`     | 光标处数字 +1 / −1         | Increment/decrement   |
| `Ctrl+c`                | 注释 / 取消注释            | Toggle comment        |
| `Q` / `q`               | 录制 / 回放宏              | Record / replay macro |
| `竖线`                  | 选区经命令过滤并替换       | Pipe through shell    |
| `Alt+竖线`              | 选区送进命令，忽略输出     | Pipe, keep text       |
| `!` / `Alt+!`           | 命令输出插到选区前 / 后    | Shell insert/append   |
| `$`                     | 管道过滤，按退出码保留选区 | Keep where exit 0     |

> `竖线` 就是 `Shift+反斜杠`；表格里不能直接写，会被当成列分隔符。
> `$` 在这里是 shell 的过滤命令，不是 Vim 的行尾。

## 搜索

| 键        | 作用                     | English           |
| --------- | ------------------------ | ----------------- |
| `/`       | 正则搜索                 | Search            |
| `?`       | 反向搜索                 | Search backward   |
| `n` / `N` | 下一个 / 上一个匹配      | Next / prev match |
| `*`       | 用选区搜索（自动词边界） | Search selection  |
| `Alt+*`   | 用选区搜索（不加词边界） | Search raw        |

## 跳转

| 键                  | 作用                      | English                 |
| ------------------- | ------------------------- | ----------------------- |
| `gd`                | 跳到定义                  | Definition              |
| `gD`                | 跳到声明                  | Declaration             |
| `gy`                | 跳到类型定义              | Type definition         |
| `gr`                | 查看引用                  | References              |
| `gi`                | 跳到实现                  | Implementation          |
| `gf`                | 打开选区里的文件名        | Goto file               |
| `ga` / `gm`         | 上次访问 / 上次修改的文件 | Last accessed/modified  |
| `gn` / `gp`         | 下一个 / 上一个缓冲区     | Next / prev buffer      |
| `g.`                | 当前文件上次修改处        | Last modification       |
| `]d` / `[d`         | 下一个 / 上一个诊断       | Next / prev diagnostic  |
| `]D` / `[D`         | 最后一个 / 第一个诊断     | Last / first diagnostic |
| `]f` / `[f`         | 下一个 / 上一个函数       | Next / prev function    |
| `]t` / `[t`         | 下一个 / 上一个类型定义   | Next / prev class       |
| `]a` / `[a`         | 下一个 / 上一个参数       | Next / prev parameter   |
| `]c` / `[c`         | 下一个 / 上一个注释       | Next / prev comment     |
| `]e` / `[e`         | 下一个 / 上一个条目       | Next / prev entry       |
| `]T` / `[T`         | 下一个 / 上一个测试       | Next / prev test        |
| `]p` / `[p`         | 下一个 / 上一个段落       | Next / prev paragraph   |
| `]g` / `[g`         | 下一个 / 上一个改动       | Next / prev change      |
| `]Space` / `[Space` | 下方 / 上方插入空行       | Newline below/above     |

## 匹配与对象

| 键             | 作用                   | English          |
| -------------- | ---------------------- | ---------------- |
| `m m`          | 跳到匹配的括号         | Matching bracket |
| `m s` 加字符   | 给选区加包围字符       | Surround add     |
| `m r` 加两字符 | 替换包围字符           | Surround replace |
| `m d` 加字符   | 删除包围字符           | Surround delete  |
| `m a` 加对象   | 选中文本对象（含外围） | Select around    |
| `m i` 加对象   | 选中文本对象（内部）   | Select inside    |

## Space 菜单

| 键                    | 作用                            | English                      |
| --------------------- | ------------------------------- | ---------------------------- |
| `Space f` / `Space F` | 文件选择器（工作区 / 当前目录） | File picker                  |
| `Space e` / `Space E` | 文件树（当前目录 / 缓冲区目录） | File explorer                |
| `Space b`             | 缓冲区选择器                    | Buffer picker                |
| `Space j`             | 跳转列表选择器                  | Jumplist picker              |
| `Space g`             | 改动文件选择器                  | Changed files                |
| `Space s` / `Space S` | 文档符号 / 工作区符号           | Document / workspace symbols |
| `Space d` / `Space D` | 文档诊断 / 工作区诊断           | Document / workspace diags   |
| `Space a`             | 代码操作                        | Code actions                 |
| `Space r`             | 重命名符号                      | Rename symbol                |
| `Space k`             | 悬停文档                        | Hover docs                   |
| `Space h`             | 选中光标处符号的所有引用        | Symbol references            |
| `Space '`             | 重开上次选择器                  | Last picker                  |
| `Space /`             | 全局搜索                        | Global search                |
| `Space ?`             | 命令面板                        | Command palette              |
| `Space c` / `Space C` | 注释 / 块注释                   | Comment / block comment      |
| `Space Alt+c`         | 强制按行注释                    | Line comment                 |
| `Space y` / `Space Y` | 复制到系统剪贴板 / 只复制主选区 | Yank to clipboard            |
| `Space p` / `Space P` | 系统剪贴板粘贴到后 / 前         | Paste clipboard              |
| `Space R`             | 用剪贴板内容替换选区            | Replace with clipboard       |
| `Space w`             | 进入窗口模式                    | Window mode                  |
| `Space G`             | 调试菜单（实验性，见下）        | Debug menu                   |

## 窗口

| 键                      | 作用                      | English                   |
| ----------------------- | ------------------------- | ------------------------- |
| `Ctrl+W` 然后 `w`       | 切到下一个窗口            | Next window               |
| `Ctrl+W` 然后 `v` / `s` | 垂直 / 水平分屏           | Split vertical/horizontal |
| `Ctrl+W` 然后 `t`       | 横 / 竖分屏方向互换       | Toggle split layout       |
| `Ctrl+W` 然后 `h/j/k/l` | 焦点移到 左/下/上/右      | Focus window              |
| `Ctrl+W` 然后 `q`       | 关闭当前窗口              | Close window              |
| `Ctrl+W` 然后 `o`       | 只保留当前窗口            | Only this window          |
| `Ctrl+W` 然后 `H/J/K/L` | 把窗口往 左/下/上/右 挪   | Swap window               |
| `Ctrl+W` 然后 `f` / `F` | 在水平 / 垂直分屏打开文件 | Goto file in split        |

## 视图

| 键                    | 作用                       | English               |
| --------------------- | -------------------------- | --------------------- |
| `z c` / `z t` / `z b` | 光标行到 中 / 顶 / 底      | Center / top / bottom |
| `z m`                 | 光标行水平居中             | Center horizontally   |
| `z j` / `z k`         | 视图向下 / 向上滚动        | Scroll view           |
| `Z`                   | 常驻视图模式（`Esc` 退出） | Sticky view mode      |

> `z` / `Z` 模式里也保留 `/` `?` `n` `N`，可以边看边搜索。

## 调试

`Space G` 是实验性的 DAP 菜单（需要配好 debugger）。

| 键          | 作用     | English           |
| ----------- | -------- | ----------------- |
| `Space G l` | 启动调试 | Launch            |
| `Space G r` | 重启调试 | Restart           |
| `Space G b` | 切换断点 | Toggle breakpoint |
| `Space G c` | 继续运行 | Continue          |
| `Space G h` | 暂停     | Pause             |
| `Space G i` | 单步进入 | Step into         |
| `Space G o` | 单步跳出 | Step out          |
| `Space G n` | 单步跳过 | Step over         |
| `Space G t` | 终止调试 | Terminate         |
| `Space G v` | 查看变量 | Variables         |

## 插入模式

| 键                         | 作用               | English                |
| -------------------------- | ------------------ | ---------------------- |
| `Esc`                      | 回到普通模式       | Normal mode            |
| `Ctrl+s`                   | 提交一次撤销检查点 | Undo checkpoint        |
| `Ctrl+x`                   | 补全               | Completion             |
| `Ctrl+r`                   | 插入寄存器内容     | Insert register        |
| `Ctrl+w` / `Alt+Backspace` | 删前一个词         | Delete word back       |
| `Alt+d` / `Alt+Delete`     | 删后一个词         | Delete word forward    |
| `Ctrl+u` / `Ctrl+k`        | 删到行首 / 行尾    | Kill to line start/end |
| `Ctrl+h` / `Backspace`     | 删前一个字符       | Backspace              |
| `Ctrl+d` / `Delete`        | 删后一个字符       | Delete                 |
| `Ctrl+j` / `Enter`         | 换行               | Newline                |

## 选择器

| 键                    | 作用                          | English                   |
| --------------------- | ----------------------------- | ------------------------- |
| `Tab` / `Shift+Tab`   | 下一个 / 上一个条目           | Next / prev item          |
| `Ctrl+n` / `Ctrl+p`   | 同上                          | Same                      |
| `Ctrl+d` / `Ctrl+u`   | 向下 / 向上翻页               | Page down/up              |
| `Enter` / `Alt+Enter` | 打开 / 后台打开（不关选择器） | Open / open in background |
| `Ctrl+s` / `Ctrl+v`   | 水平 / 垂直分屏打开           | Open in split             |
| `Ctrl+t`              | 切换预览                      | Toggle preview            |
| `Esc` / `Ctrl+c`      | 关闭选择器                    | Close                     |

## 保存与退出

| 键               | 作用                   | English           |
| ---------------- | ---------------------- | ----------------- |
| `:w`             | 保存                   | Save              |
| `:q` / `:q!`     | 退出 / 强制退出        | Quit / force quit |
| `:wq`            | 保存并退出             | Save and quit     |
| `:config-reload` | 重新加载 config.toml   | Reload config     |
| `:theme`         | 切换主题               | Theme picker      |
| `Ctrl+z`         | 挂起 Helix，回到 shell | Suspend           |
