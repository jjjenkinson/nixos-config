# Helix 快捷键

> Helix 25.07.1，全默认键位（`dotfiles/helix/config.toml` 没改键）。
> 只列常用项；完整表用 `:help` / `:help keymap` 查。
>
> 表格约定：`| 键 | 作用 | English |`，第 3 列是英文；一行所有列（含段名）合计
> ≤110 列宽。`## ` 标题会作为速查里的段名。

## 模式

| 键        | 作用                    | English         |
| --------- | ----------------------- | --------------- |
| `i` / `a` | 光标前 / 后进入插入模式 | Insert          |
| `I` / `A` | 行首 / 行尾进入插入模式 | Insert at edges |
| `o` / `O` | 下方 / 上方新行并插入   | Open line       |
| `v`       | 选择模式                | Select mode     |
| `Esc`     | 回到普通模式            | Normal mode     |
| `:`       | 命令行                  | Command line    |

## 移动

| 键                  | 作用                       | English          |
| ------------------- | -------------------------- | ---------------- |
| `h` `j` `k` `l`     | 左 / 下 / 上 / 右          | Move cursor      |
| `w` / `b` / `e`     | 下一个词 / 上一个词 / 词尾 | Word motions     |
| `W` / `B` / `E`     | 同上，但按空白分词         | Same, by WORD    |
| `0` / `$`           | 行首 / 行尾                | Line start/end   |
| `gg` / `G`          | 文件开头 / 结尾            | File start/end   |
| `Ctrl+u` / `Ctrl+d` | 上 / 下翻半页              | Half page        |
| `Ctrl+b` / `Ctrl+f` | 上 / 下翻整页              | Full page        |
| `mm`                | 跳到匹配的括号             | Matching bracket |

## 编辑

| 键              | 作用                   | English              |
| --------------- | ---------------------- | -------------------- |
| `d` / `c`       | 删除 / 修改选区        | Delete / change      |
| `y` / `p`       | 复制 / 粘贴            | Yank / paste         |
| `x`             | 选中整行               | Select line          |
| `%`             | 全选                   | Select all           |
| `r`             | 替换单个字符           | Replace char         |
| `>` / `<`       | 缩进 / 反缩进          | Indent / dedent      |
| `=`             | 格式化选区             | Format selection     |
| `J`             | 合并行                 | Join lines           |
| `u` / `U`       | 撤销 / 重做            | Undo / redo          |
| `/` / `n` / `N` | 搜索 / 下一个 / 上一个 | Search / next / prev |

## Space

| 键        | 作用             | English              |
| --------- | ---------------- | -------------------- |
| `Space f` | 文件选择器       | File picker          |
| `Space b` | 缓冲区选择器     | Buffer picker        |
| `Space /` | 全局搜索         | Global search        |
| `Space s` | 符号选择器       | Symbol picker        |
| `Space S` | 工作区符号       | Workspace symbols    |
| `Space d` | 文档诊断         | Diagnostics          |
| `Space a` | 代码操作         | Code actions         |
| `Space r` | 重命名符号       | Rename symbol        |
| `Space k` | 悬停文档         | Hover docs           |
| `Space g` | 跳转（定义等）   | Goto                 |
| `Space w` | 窗口菜单         | Window menu          |
| `Space c` | 注释 / 取消注释  | Toggle comment       |
| `Space y` | 复制到系统剪贴板 | Copy to clipboard    |
| `Space p` | 从系统剪贴板粘贴 | Paste from clipboard |
| `Space q` | 录制宏           | Record macro         |
| `Space Q` | 回放宏           | Replay macro         |

## 跳转

| 键                      | 作用                   | English           |
| ----------------------- | ---------------------- | ----------------- |
| `gd` / `gr` / `gy`      | 定义 / 引用 / 类型定义 | Def / refs / type |
| `gi`                    | 实现                   | Implementation    |
| `]d` / `[d`             | 下一个 / 上一个诊断    | Next / prev diag  |
| `Ctrl+w` 然后 `v` / `s` | 垂直 / 水平分屏        | Split v / h       |
| `Ctrl+w` 然后 `h/j/k/l` | 切换窗口               | Switch window     |
| `Ctrl+w` 然后 `q`       | 关闭当前窗口           | Close window      |
