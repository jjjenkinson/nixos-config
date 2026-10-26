# Neovim 快捷键

> Neovim 0.12.4。`home/common/neovim.nix` 只开了 `clipboard=unnamedplus`、
> `number`、`relativenumber`，**没有改任何键位**，所以下表全是官方默认值。
> 来源：`:help index`（按模式列全表）、`:help lsp-defaults`、`:help quickref`，
> 以及 `nvim --clean` 下 `:nmap` / `:imap` / `:xmap` 的实际输出。
>
> 0.12 起自带、容易和旧 Vim 记忆对不上的默认映射：
> matchit 默认启用（`%`、`[%`、`]%`、`a%` 都能用）；
> `[d` / `]d` / `[D` / `]D` 被**诊断跳转**占用（不再是 `#define`）；
> `gc` / `gcc` 注释、`gx` 用系统程序打开、`gn` / `gN` 选中匹配、
> `[<Space>` / `]<Space>` 上下加空行；
> `Y` 是 `y$`（复制到行尾），**不是**整行复制。
>
> ⚠️ 和 Helix 表容易混：这里的 `0` / `^` / `$` 是真正的行首 / 行尾，
> `G` 是「跳到行号」（无计数时到末行），`ge` 是上一个词尾而不是文件末尾，
> `q` 是开始录制宏、`Q` 才是回放。
>
> 表格约定：`| 键 | 作用 | English |`，第 3 列是英文；一行所有列（含段名）合计
> ≤120 列宽（AGENTS.md 的约定）。`## ` 标题会作为速查里的段名。
> 前缀键（如 `g`、`Ctrl+w`、`[`）不单独列一段，直接写在每行里。
> 带「可加计数」的键，在按之前输入数字即可重复 N 次。

## 模式

| 键               | 作用                                      | English                        |
| ---------------- | ----------------------------------------- | ------------------------------ |
| `i` / `a`        | 在光标前 / 后进入插入模式                 | Insert before / after cursor   |
| `I` / `A`        | 跳到行首 / 行尾后进入插入                 | Insert at line start / end     |
| `o` / `O`        | 在下方 / 上方新开一行并插入               | Open new line below / above    |
| `v` / `V`        | 进入字符 / 行可视模式                     | Visual: char / line            |
| `Ctrl+v`         | 进入块（矩形）可视模式                    | Visual: block                  |
| `R` / `gR`       | 替换模式 / 虚拟替换（按屏幕格不按字符）   | Replace / virtual replace      |
| `gh` / `gH`      | 选择模式：输入即替换选中内容（字符 / 行） | Select mode (char / line)      |
| `:`              | 打开命令行                                | Command line                   |
| `/` / `?`        | 向下 / 向上搜索                           | Search forward / backward      |
| `Esc` / `Ctrl+c` | 回到普通模式（`Ctrl+c` 不触发缩写展开）   | Back to Normal mode            |
| `Ctrl+g`         | 显示文件名、行号与浏览进度                | Show file name, line, position |
| `g` `Ctrl+g`     | 显示光标位置、行数与字数统计              | Show cursor and file stats     |
| `gv`             | 重选上次的可视区域                        | Reselect last visual area      |

## 移动

| 键                  | 作用                                    | English                        |
| ------------------- | --------------------------------------- | ------------------------------ |
| `h` `j` `k` `l`     | 光标 左 / 下 / 上 / 右 移一格           | Move cursor                    |
| `gj` / `gk`         | 按屏幕行下 / 上移（开了软换行时用它）   | Move by screen line            |
| `w` / `b` / `e`     | 下一个词首 / 上一个词首 / 当前词尾      | Word start / back / word end   |
| `W` / `B` / `E`     | 同上，但按空白分隔算一个词（WORD）      | Same, but by WORD              |
| `ge` / `gE`         | 上一个词尾（按词 / 按 WORD）            | End of previous word           |
| `0` / `^` / `$`     | 行首 / 行内第一个非空白 / 行尾          | Line start / first blank / end |
| `g0` / `g^` / `g$`  | 屏幕行的 行首 / 首个非空白 / 行尾       | Screen line start / end        |
| `gg` / `G`          | 跳到文件开头 / 第 N 行（默认最后一行）  | File start / line N            |
| `f` / `t`           | 本行向后找字符：停在它上面 / 停在前一位 | Find char: on it / before it   |
| `F` / `T`           | 本行向前找字符（同上两种停法）          | Find char backward             |
| `;` / `,`           | 重复上次 `f` `t` 查找：同方向 / 反方向  | Repeat find: same / opposite   |
| `Ctrl+d` / `Ctrl+u` | 向下 / 向上翻半页                       | Half page down / up            |
| `Ctrl+f` / `Ctrl+b` | 向下 / 向上翻一整页                     | Full page down / up            |
| `Ctrl+e` / `Ctrl+y` | 光标不动，画面向下 / 向上滚一行         | Scroll one line down / up      |
| `H` / `M` / `L`     | 跳到屏幕最顶 / 中间 / 最底 的一行       | Screen top / middle / bottom   |
| `zt` / `zz` / `zb`  | 把当前行滚到屏幕 顶部 / 中间 / 底部     | Line to top / middle / bottom  |
| `{` / `}`           | 跳到上一段 / 下一段的空行处             | Paragraph backward / forward   |
| `(` / `)`           | 跳到上一句 / 下一句的开头               | Sentence backward / forward    |
| `%`                 | 跳到配对括号；已在括号上时跳到另一半    | Matching bracket (matchit)     |
| `*` / `#`           | 向下 / 向上搜索光标下的整词             | Search whole word under cursor |
| `g*` / `g#`         | 同上，但不要求整词匹配                  | Same, without word boundary    |
| `n` / `N`           | 跳到下一个 / 上一个搜索结果             | Next / previous match          |
| `gn` / `gN`         | 选中下一个 / 上一个匹配，可直接改       | Select next / previous match   |
| `Ctrl+o` / `Ctrl+i` | 在跳转列表里后退 / 前进                 | Jump back / forward            |
| `Ctrl+]` / `Ctrl+t` | 跳到光标下的 tag / 从 tag 返回来处      | Goto tag / return from tag     |
| `m` + 字母          | 设标记（小写限本文件，大写可跨文件跳）  | Set mark                       |
| `'` + 字母          | 跳到标记所在行的第一个非空白            | Jump to mark's line            |
| 反引号 + 字母       | 跳到标记的精确行列位置                  | Jump to exact mark position    |
| `''` / 两个反引号   | 回到上次跳转前的位置                    | Jump back to previous position |
| `gi`                | 回到上次退出插入的位置，继续插入        | Insert where insert stopped    |

## 编辑

| 键                  | 作用                                       | English                        |
| ------------------- | ------------------------------------------ | ------------------------------ |
| `x` / `X`           | 删除光标下的字符 / 光标前一个字符          | Delete char under / before     |
| `d` / `c` / `y`     | 删除 / 修改 / 复制，后面接动作或文本对象   | Delete / change / yank         |
| `dd` / `cc` / `yy`  | 整行 删除 / 修改（进插入）/ 复制           | Whole line                     |
| `D` / `C` / `Y`     | 删到行尾 / 改到行尾 / 复制到行尾           | To end of line                 |
| `s` / `S`           | 删掉一个字符 / 整行后进入插入              | Substitute char / line         |
| `p` / `P`           | 粘贴到光标之后 / 之前                      | Put after / before cursor      |
| `gp` / `gP`         | 同上，粘贴后光标停在粘贴内容的末尾         | Put, cursor after text         |
| `r`                 | 用下一个输入的字符替换当前字符             | Replace one character          |
| `~`                 | 切换光标下字符的大小写，并向右移一格       | Toggle case, move right        |
| `g~` / `gU` / `gu`  | 大小写反转 / 全部大写 / 全部小写           | Swap / upper / lower case      |
| `J` / `gJ`          | 与下一行合并（自动补空格 / 不补空格）      | Join lines                     |
| `u` / `Ctrl+r`      | 撤销 / 重做                                | Undo / redo                    |
| `U`                 | 撤销本行上做过的所有改动                   | Undo all changes on line       |
| `.`                 | 重复上一次改动                             | Repeat last change             |
| `>>` / `<<`         | 当前行增加 / 减少一级缩进                  | Indent / dedent line           |
| `=`                 | 按文件类型自动缩进（接动作）               | Auto-reindent                  |
| `gq` / `gw`         | 按 `textwidth` 排版，光标到行尾 / 留在原处 | Format text                    |
| `Ctrl+a` / `Ctrl+x` | 光标处（或之后的）数字 加 1 / 减 1         | Increment / decrement number   |
| `gcc` / `gc`        | 注释或取消注释整行 / 接动作的范围          | Toggle comment                 |
| `gx`                | 用系统默认程序打开光标下的路径或网址       | Open path or URL with system   |
| `&` / `g&`          | 重复上次 `:s`：仅本行 / 整个文件           | Repeat substitute              |
| `Ctrl+l`            | 重绘屏幕，并清除搜索高亮                   | Redraw, clear search highlight |

## 宏与寄存器

| 键            | 作用                                         | English                  |
| ------------- | -------------------------------------------- | ------------------------ |
| `q` + 字母    | 开始把按键录制到该寄存器；再按 `q` 停止录制  | Record macro (q to stop) |
| `@` + 字母    | 播放该寄存器里录制的宏                       | Play macro from register |
| `{n}@` + 字母 | 把该宏连续播放 n 次                          | Play macro n times       |
| `@@`          | 再播放一次上次播放过的宏                     | Repeat last played macro |
| `"` + 字母    | 前缀：指定接下来要用哪个寄存器               | Prefix: choose register  |
| `"0` / `"1`   | 最近一次复制的内容 / 最近一次删除的内容      | Last yank / last delete  |
| `"_`          | 黑洞寄存器：删除的内容直接丢弃，不覆盖别处   | Black hole (discard)     |
| `"+` / `"*`   | 系统剪贴板（本配置已 `unnamedplus`，无需写） | System clipboard         |

## 可视模式

| 键                    | 作用                                       | English                       |
| --------------------- | ------------------------------------------ | ----------------------------- |
| `o`                   | 光标跳到选区另一端，方便调整范围           | Move to other end             |
| `O`                   | 块模式下跳到选区的对角                     | Move to other corner          |
| `gv`                  | 在本次选区和上一次的选区之间切换           | Swap to previous selection    |
| `>` / `<`             | 选区增加 / 减少一级缩进                    | Indent / dedent selection     |
| `=`                   | 对选区自动缩进                             | Auto-reindent selection       |
| `J` / `gJ`            | 把选中的多行合并成一行（补 / 不补空格）    | Join selected lines           |
| `u` / `U` / `~`       | 选区转 小写 / 大写 / 反转大小写            | Lower / upper / swap case     |
| `:`                   | 把选区当作行范围来执行命令行命令           | Run command on range          |
| `!`                   | 用外部命令过滤选中的行                     | Filter lines through command  |
| `I` / `A`             | 块模式：在每行 前 / 后 插入同样内容        | Block insert / append         |
| `c` / `s` / `R`       | 删除选区并进入插入模式                     | Change selection              |
| `d` / `x` / `D` / `X` | 删除选区（不想进寄存器就用 `"_d`）         | Delete selection              |
| `y` / `Y`             | 复制选区                                   | Yank selection                |
| `p` / `P`             | 用寄存器内容覆盖选区（`P` 不消耗寄存器）   | Paste over selection          |
| `i` / `a` + 对象      | 选 内层 / 外层 文本对象，如 `iw`、`a(`     | Inner / outer text object     |
| `]n` / `[n`           | 选中下一个 / 上一个语法节点（Tree-sitter） | Next / previous syntax node   |
| `]N` / `[N`           | 选中下一个 / 上一个同级节点                | Next / previous sibling node  |
| `an` / `in`           | 选中当前节点的父节点 / 子节点              | Parent / child node           |
| `gc` / `gra`          | 注释选区 / 对选区执行代码操作              | Comment / code action         |
| `*` / `#`             | 搜索选中的文本（向下 / 向上）              | Search selection              |
| `@` + 字母            | 对选区里的每一行分别播放该宏               | Play macro on each line       |
| `Ctrl+a` / `Ctrl+x`   | 选区里的数字 加 1 / 减 1                   | Increment / decrement numbers |

## 跳转与 LSP

| 键           | 作用                                         | English                      |
| ------------ | -------------------------------------------- | ---------------------------- |
| `gd` / `gD`  | 跳到符号定义（本函数内 / 从文件头开始找）    | Goto definition              |
| `grn`        | 重命名光标下的符号，所有引用一起改           | Rename symbol                |
| `gra`        | 在光标处打开代码操作（code action）菜单      | Code action                  |
| `grt`        | 跳到该符号的类型定义                         | Goto type definition         |
| `gri`        | 跳到该符号的实现                             | Goto implementation          |
| `grr`        | 在 quickfix 列表里列出所有引用               | List references              |
| `grx`        | 运行光标处的代码镜头（CodeLens）             | Run codelens                 |
| `gO`         | 列出本文件的符号（变量、函数、类型等）       | Document symbols             |
| `K`          | 查光标下单词的文档（`keywordprg`，默认 man） | Hover docs / man page        |
| `Ctrl+s`     | 插入模式下弹出函数签名帮助                   | Signature help (insert)      |
| `[d` / `]d`  | 跳到上一个 / 下一个诊断（错误、警告）        | Previous / next diagnostic   |
| `[D` / `]D`  | 跳到本文件第一个 / 最后一个诊断              | First / last diagnostic      |
| `Ctrl+w` `d` | 在下方小窗口里显示光标处的完整诊断           | Show diagnostic under cursor |
| `gf` / `gF`  | 打开光标下的文件名（`gF` 再跳到行号）        | Goto file / file + line      |
| `gx`         | 用系统默认程序打开光标下的路径或网址         | Open path or URL with system |

## 括号前缀

| 键                      | 作用                                        | English                         |
| ----------------------- | ------------------------------------------- | ------------------------------- |
| `[%` / `]%`             | 跳到上一个 / 下一个配对项，可跨行           | Previous / next matching item   |
| `g%`                    | 反向跳到配对括号（与 `%` 方向相反）         | Matching bracket, backwards     |
| `[(` / `])`             | 跳到上一个 / 下一个未配对的圆括号           | Unmatched parenthesis           |
| `[{` / `]}`             | 跳到上一个 / 下一个未配对的花括号           | Unmatched curly brace           |
| `[[` / `]]`             | 跳到上一个 / 下一个 section（首列有字符）   | Previous / next section         |
| `[]` / `][`             | 同上，但按 SECTIONS（首列是 `{` 或 `}`）    | Previous / next SECTIONS        |
| `[<Space>` / `]<Space>` | 在光标上 / 下插入一个空行，光标不动         | Add empty line above / below    |
| `[b` / `]b`             | 切到上一个 / 下一个缓冲区                   | Previous / next buffer          |
| `[B` / `]B`             | 跳到第一个 / 最后一个缓冲区                 | First / last buffer             |
| `[q` / `]q`             | 跳到上一个 / 下一个 quickfix 列表项         | Previous / next quickfix entry  |
| `[Q` / `]Q`             | 跳到第一个 / 最后一个 quickfix 列表项       | First / last quickfix entry     |
| `[l` / `]l`             | 跳到上一个 / 下一个 location 列表项         | Previous / next location entry  |
| `[L` / `]L`             | 跳到第一个 / 最后一个 location 列表项       | First / last location entry     |
| `[t` / `]t`             | 切到上一个 / 下一个标签页                   | Previous / next tab             |
| `[T` / `]T`             | 跳到第一个 / 最后一个标签页                 | First / last tab                |
| `[a` / `]a`             | 切到参数（arglist）里的上一个 / 下一个文件  | Previous / next argument file   |
| `[A` / `]A`             | 跳到参数列表的第一个 / 最后一个文件         | First / last argument file      |
| `[s` / `]s`             | 跳到上一个 / 下一个拼写错误的单词           | Previous / next misspelled word |
| `[z` / `]z`             | 跳到当前展开的折叠的 开头 / 结尾            | Start / end of open fold        |
| `[c` / `]c`             | 跳到上一个 / 下一个改动处（diff 模式）      | Previous / next change          |
| `[m` / `]m`             | 跳到上一个成员函数开头 / 下一个成员函数结尾 | Previous / next method          |
| `[#` / `]#`             | 跳到上一个 / 下一个未配对的 `#if` `#else`   | Unmatched preprocessor cond     |
| `[i` / `]i`             | 在底部显示光标下单词第一次出现的位置        | Show first occurrence           |
| `[I` / `]I`             | 在底部列出光标下单词的所有出现位置          | List all occurrences            |

> `[d` / `]D` 系列在 0.12 被诊断跳转占用，所以这里不列 `#define` 的旧含义。

## 窗口与标签

| 键                      | 作用                                      | English                           |
| ----------------------- | ----------------------------------------- | --------------------------------- |
| `Ctrl+w` `s` / `v`      | 水平上下分屏 / 垂直左右分屏               | Split horizontally / vertically   |
| `Ctrl+w` `h/j/k/l`      | 切到 左边 / 下边 / 上边 / 右边 的窗口     | Move to window left/down/up/right |
| `Ctrl+w` `w` / `p`      | 切到下一个窗口 / 上一个访问过的窗口       | Next / previous window            |
| `Ctrl+w` `c` / `q`      | 关闭当前窗口（分别是 `:close` / `:quit`） | Close current window              |
| `Ctrl+w` `o`            | 关掉其它所有窗口，只留当前这个            | Close all other windows           |
| `Ctrl+w` `=`            | 把所有窗口调成等高等宽                    | Make all windows equal size       |
| `Ctrl+w` `+` / `-`      | 当前窗口高度 增加 / 减少 N 行             | Increase / decrease height        |
| `Ctrl+w` `>` / `<`      | 当前窗口宽度 增加 / 减少 N 列             | Increase / decrease width         |
| `Ctrl+w` `x`            | 与下一个窗口交换位置，光标跟着走          | Exchange with next window         |
| `Ctrl+w` `r` / `R`      | 所有窗口顺时针 / 逆时针轮转一圈           | Rotate windows down / up          |
| `Ctrl+w` `H/J/K/L`      | 把当前窗口挪到 最左 / 最下 / 最上 / 最右  | Move window to far edge           |
| `Ctrl+w` `t` / `b`      | 切到最顶上 / 最底下 的那个窗口            | Top / bottom window               |
| `Ctrl+w` `T`            | 把当前窗口单独挪到一个新标签页            | Move window to new tab            |
| `Ctrl+w` `n`            | 新开一个水平窗口，里面是空缓冲区          | New window with empty buffer      |
| `gt` / `gT`             | 切到下一个 / 上一个标签页                 | Next / previous tab page          |
| `{n}gt`                 | 直接切到第 n 个标签页                     | Go to tab page n                  |
| `g` `Tab`               | 回到上次访问过的那个标签页                | Last accessed tab page            |
| `:tabnew` / `:tabclose` | 新建 / 关闭标签页                         | New / close tab page              |

## 折叠与滚动

| 键             | 作用                                  | English                         |
| -------------- | ------------------------------------- | ------------------------------- |
| `zf` / `{n}zf` | 创建折叠：接动作 / 从光标起折 N 行    | Create fold over motion / lines |
| `zo` / `zc`    | 打开 / 关闭光标处的折叠               | Open / close fold               |
| `za`           | 打开或关闭光标处的折叠（开关）        | Toggle fold                     |
| `zR` / `zM`    | 递归打开所有折叠 / 关闭所有折叠       | Open all / close all folds      |
| `zr` / `zm`    | 折叠层级加一 / 减一（逐层展开或收起） | Fold level +1 / -1              |
| `zi`           | 临时开关折叠功能：全部展开后再恢复    | Toggle foldenable               |
| `zj` / `zk`    | 跳到下一个 / 上一个折叠的开头         | Next / previous fold            |
| `zd` / `zD`    | 删除光标处的折叠 / 递归删除整组折叠   | Delete fold / recursively       |
| `zv`           | 展开到刚好能看见光标所在的那一行      | Open just enough to see cursor  |
| `zh` / `zl`    | 不换行时，画面向左 / 向右滚一个字符   | Scroll left / right by one char |
| `zs` / `ze`    | 把当前行滚到屏幕 最左 / 最右 端       | Scroll cursor to screen edge    |
| `zH` / `zL`    | 画面向左 / 向右滚半个屏幕宽           | Scroll half a screen left/right |

## 插入模式

| 键                  | 作用                                      | English                         |
| ------------------- | ----------------------------------------- | ------------------------------- |
| `Ctrl+h`            | 删除光标前一个字符（等同退格）            | Delete char before              |
| `Ctrl+w`            | 删除光标前一个词                          | Delete word before              |
| `Ctrl+u`            | 删除从行首到光标的所有内容                | Delete to line start            |
| `Ctrl+t` / `Ctrl+d` | 本行开头增加 / 减少一级缩进               | Indent / dedent line            |
| `Ctrl+r` + 寄存器   | 把寄存器内容原样插入                      | Insert register contents        |
| `Ctrl+o` + 命令     | 临时执行一个普通模式命令，然后回来        | Run one Normal command          |
| `Ctrl+n` / `Ctrl+p` | 在补全候选里向下 / 向上选择               | Next / previous completion      |
| `Ctrl+x` + 子命令   | 触发各类补全（如 `Ctrl+x Ctrl+f` 文件名） | Completion subcommands          |
| `Ctrl+e` / `Ctrl+y` | 复制下面 / 上面一行的同列字符             | Copy char from line below/above |
| `Ctrl+a`            | 重新插入上次插入过的文本                  | Insert previously inserted text |
| `Ctrl+@`            | 插入上次的文本后，退出插入模式            | Insert prev text and stop       |
| `Ctrl+v` / `Ctrl+q` | 按十进制 / 八进制字符码输入一个字符       | Insert char by numeric code     |
| `Ctrl+k`            | 用两个字符输入一个二合字母                | Insert digraph                  |
| `Ctrl+g` `u` / `U`  | 把本行已输入的部分转成 小写 / 大写        | Lowercase / uppercase line      |
| `g` `Ctrl+g`        | 显示当前光标位置和字符信息                | Show position and char info     |
| `Tab` / `S-Tab`     | 有活动代码片段时，跳下一个 / 上一个占位   | Jump snippet placeholder        |
| `Esc` / `Ctrl+c`    | 回到普通模式（`Ctrl+c` 不触发缩写展开）   | Back to Normal mode             |

## 命令行

| 键                  | 作用                                 | English                       |
| ------------------- | ------------------------------------ | ----------------------------- |
| `Ctrl+r` + 寄存器   | 把寄存器内容插入到命令行             | Insert register contents      |
| `Ctrl+w`            | 删除光标前一个词                     | Delete word before            |
| `Ctrl+u`            | 删除光标前的所有内容                 | Delete everything before      |
| `Ctrl+f` / `q:`     | 打开命令行窗口，可用普通模式编辑历史 | Open command-line window      |
| `Ctrl+p` / `Ctrl+n` | 在历史命令里向上 / 向下翻            | Previous / next history entry |
| `Ctrl+b` / `Ctrl+e` | 跳到命令行的 行首 / 行尾             | Start / end of command line   |
| `Ctrl+d`            | 列出所有补全候选                     | List all completions          |
| `%`                 | 展开成当前文件名                     | Current file name             |
| `#`                 | 展开成备用（alternate）文件名        | Alternate file name           |
| `@:`                | 重复执行上一条命令行命令             | Repeat last command line      |
| `Ctrl+c` / `Esc`    | 取消本次命令，回到普通模式           | Cancel command                |

## 终端模式

| 键                   | 作用                               | English                       |
| -------------------- | ---------------------------------- | ----------------------------- |
| `Ctrl+\` `Ctrl+n`    | 回到普通模式（可复制、可滚动浏览） | Back to Normal mode           |
| `Ctrl+\` `Ctrl+o`    | 执行一个普通命令后自动回到终端     | One Normal command, then back |
| `i` / `a`            | 普通模式下调回终端作业，继续输入   | Resume terminal job           |
| 其余按键（含 `Esc`） | 原样转发给终端里正在跑的程序       | Forwarded to the running job  |

> 终端模式下 `Ctrl+w` 也会被转发，不能当窗口前缀用；先 `Ctrl+\ Ctrl+n` 回普通模式。

## 保存与退出

| 键             | 作用                                     | English                   |
| -------------- | ---------------------------------------- | ------------------------- |
| `:w` / `:wa`   | 写入当前文件 / 写入所有改动过的文件      | Write / write all         |
| `:q` / `:qa`   | 关闭当前窗口 / 退出所有窗口              | Quit / quit all           |
| `:wq` / `:x`   | 保存并退出（`:x` 无改动时不写盘）        | Write and quit            |
| `:q!` / `:qa!` | 放弃改动，强制退出                       | Quit, discard changes     |
| `:e 文件`      | 打开指定文件                             | Edit file                 |
| `:bd`          | 关闭当前缓冲区（文件还在，可 `:b` 切回） | Delete buffer             |
| `:s/a/b/g`     | 在当前行把 a 替换成 b（`g` = 全行）      | Substitute in line        |
| `:%s/a/b/g`    | 在整个文件里把 a 替换成 b                | Substitute in whole file  |
| `:g/pat/d`     | 对所有匹配的行执行命令（这里是删除）     | Global command on matches |
| `:!cmd`        | 执行一条 shell 命令                      | Run shell command         |
| `:h 关键字`    | 打开内置帮助                             | Open help                 |
| `:terminal`    | 在当前窗口里打开一个终端                 | Open terminal             |
