# Yazi 快捷键

> Yazi 26.5.6。键位基本是默认值，本仓库（`home/common/yazi.nix`）只用
> `prepend_keymap` 覆盖了三个：`Enter`（智能进入/打开）、`C`（压缩）、
> `M`（改权限）。其余全部沿用官方默认键位。
> 完整默认表：`~` 或 `F1` 打开内置帮助（也可看 yazi 源码的 `keymap-default.toml`）。
>
> 表格约定：`| 键 | 作用 | English |`，第 3 列是英文；一行所有列（含段名）合计
> ≤110 列宽（速查窗口里超宽会被 fzf 截断）。`## ` 标题会作为速查里的段名。

## 浏览

| 键                          | 作用                                  | English                      |
| --------------------------- | ------------------------------------- | ---------------------------- |
| `h` / `l`                   | 返回父目录 / 进入子目录               | Parent / enter               |
| `j` / `k`                   | 下一个 / 上一个文件                   | Next / prev file             |
| `gg` / `G`                  | 跳到第一个 / 最后一个                 | First / last                 |
| `H` / `L`                   | 后退 / 前进（目录历史）               | Back / forward               |
| `Ctrl+u` / `Ctrl+d`         | 上 / 下移半页                         | Half page up/down            |
| `Ctrl+b` / `Ctrl+f`         | 上 / 下翻整页                         | Page up/down                 |
| `Shift+PgUp` / `Shift+PgDn` | 上 / 下移半页                         | Half page up/down            |
| `PgUp` / `PgDn`             | 上 / 下翻整页                         | Page up/down                 |
| `J` / `K`                   | 预览区向下 / 向上滚 5 行              | Seek preview                 |
| `.`                         | 显示 / 隐藏隐藏文件                   | Toggle hidden                |
| `Tab`                       | 钉住当前预览（spot）                  | Spot file                    |
| `g h` / `g c` / `g d`       | 跳到 家目录 / ~/.config / ~/Downloads | Go home / config / Downloads |
| `g` 然后 `Space`            | 交互式选目录跳转                      | Interactive jump             |
| `g f`                       | 跟随光标处的软链                      | Follow symlink               |
| `z` / `Z`                   | fzf 跳转 / zoxide 跳转                | fzf / zoxide jump            |
| `~` / `F1`                  | 打开内置帮助                          | Help                         |

## 选择

| 键        | 作用                         | English          |
| --------- | ---------------------------- | ---------------- |
| `Space`   | 选中 / 取消选中并下移        | Toggle selection |
| `Ctrl+a`  | 全选                         | Select all       |
| `Ctrl+r`  | 反选                         | Invert selection |
| `v` / `V` | 可视模式 / 可视模式（清空）  | Visual mode      |
| `Esc`     | 退出可视、清空选择、取消搜索 | Escape           |

## 打开与查找

| 键            | 作用                             | English               |
| ------------- | -------------------------------- | --------------------- |
| `Enter`       | 智能进入目录 / 打开文件（本机）  | Smart open            |
| `o` / `O`     | 打开 / 交互式选择程序打开        | Open / open with      |
| `Shift+Enter` | 交互式选择程序打开               | Open with             |
| `f`           | 过滤当前目录                     | Filter files          |
| `/` / `?`     | 向后 / 向前查找文件名            | Find / find back      |
| `n` / `N`     | 下一个 / 上一个匹配              | Next / prev found     |
| `Ctrl+s`      | 取消正在进行的搜索               | Cancel search         |
| `s` / `S`     | 按文件名搜（fd）/ 按内容搜（rg） | Search name / content |

## 文件操作

| 键        | 作用                          | English             |
| --------- | ----------------------------- | ------------------- |
| `y` / `x` | 复制 / 剪切                   | Copy / cut          |
| `Y` / `X` | 取消复制 / 剪切状态           | Unyank              |
| `p` / `P` | 粘贴 / 粘贴并覆盖             | Paste / paste over  |
| `-` / `_` | 软链绝对路径 / 相对路径       | Symlink abs / rel   |
| `Ctrl+-`  | 硬链接                        | Hardlink            |
| `d` / `D` | 移到回收站 / 永久删除         | Trash / delete      |
| `a`       | 新建文件（以 `/` 结尾建目录） | Create              |
| `r`       | 重命名（光标停在扩展名前）    | Rename              |
| `;` / `:` | 运行 shell 命令 / 阻塞运行    | Shell / shell block |
| `C`       | 压缩选中项（本机插件）        | Compress (custom)   |
| `M`       | 修改权限（本机插件）          | Chmod (custom)      |

## 标签

| 键           | 作用                       | English         |
| ------------ | -------------------------- | --------------- |
| `t` 然后 `t` | 在当前目录新建标签页       | New tab         |
| `t` 然后 `r` | 重命名当前标签页           | Rename tab      |
| `1` … `9`    | 切到第 1–9 个标签页        | Go to tab 1-9   |
| `[` / `]`    | 上一个 / 下一个标签页      | Prev / next tab |
| `{` / `}`    | 标签页左移 / 右移          | Swap tab        |
| `w`          | 打开任务管理器             | Task manager    |
| `Ctrl+c`     | 关闭当前标签页             | Close tab       |
| `Ctrl+z`     | 挂起 yazi（fg 回来）       | Suspend         |
| `q`          | 退出（shell 跟到当前目录） | Quit, cd shell  |
| `Q`          | 退出且不改变 shell 目录    | Quit, keep cwd  |

## 排序

| 键            | 作用              | English      |
| ------------- | ----------------- | ------------ |
| `, m` / `, M` | 按修改时间 / 反向 | By mtime     |
| `, b` / `, B` | 按创建时间 / 反向 | By btime     |
| `, e` / `, E` | 按扩展名 / 反向   | By extension |
| `, a` / `, A` | 按字母 / 反向     | Alphabetical |
| `, n` / `, N` | 按自然顺序 / 反向 | Natural      |
| `, s` / `, S` | 按大小 / 反向     | By size      |
| `, r`         | 随机排序          | Random       |

## 显示与复制

| 键                    | 作用                           | English                   |
| --------------------- | ------------------------------ | ------------------------- |
| `m s` / `m p` / `m b` | 行模式：大小 / 权限 / 创建时间 | Linemode size/perms/btime |
| `m m` / `m o` / `m n` | 行模式：修改时间 / 所有者 / 无 | Linemode mtime/owner/none |
| `c c` / `c d`         | 复制文件 URL / 所在目录 URL    | Copy path / dirname       |
| `c f` / `c n`         | 复制文件名 / 去扩展名文件名    | Copy filename             |

## 输入与确认

| 键                  | 作用                      | English            |
| ------------------- | ------------------------- | ------------------ |
| `Enter` / `Esc`     | 提交 / 取消               | Submit / cancel    |
| `y` / `n`           | 确认 / 取消（确认框）     | Yes / no           |
| `i` / `a`           | 进入插入 / 追加模式       | Insert / append    |
| `0` / `$`           | 行首 / 行尾               | Line start / end   |
| `Ctrl+u` / `Ctrl+k` | 删到行首 / 删到行尾       | Kill to start/end  |
| `Ctrl+w` / `Alt+d`  | 删前一个词 / 后一个词     | Delete word        |
| `u` / `Ctrl+r`      | 撤销 / 重做               | Undo / redo        |
| `Tab` / `Enter`     | 提交补全 / 补全并提交输入 | Submit completion  |
| `Ctrl+n` / `Ctrl+p` | 下一个 / 上一个补全候选   | Next / prev item   |
| `Alt+j` / `Alt+k`   | 同上                      | Same               |
| `j` / `k`           | 选择框里 下一个 / 上一个  | Next / prev option |
