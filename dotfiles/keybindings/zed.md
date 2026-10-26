# Zed 快捷键

> Zed 1.24.2。`settings.json` 里开了 `helix_mode = true`，所以编辑键位是
> **Helix 风格的子集**，不是完整的 Helix。以 `Ctrl+Shift+P` → “Open Keymap”
> 里显示的绑定为准；同一条快捷键在不同上下文里也可能不同。
>
> 表格约定：`| 键 | 作用 | English |`，第 3 列是英文；一行所有列（含段名）合计
> ≤110 列宽。`## ` 标题会作为速查里的段名。

## 全局

| 键                  | 作用                | English             |
| ------------------- | ------------------- | ------------------- |
| `Ctrl+P`            | 文件搜索            | File finder         |
| `Ctrl+Shift+P`      | 命令面板            | Command palette     |
| `Ctrl+S`            | 保存                | Save                |
| `Ctrl+Shift+S`      | 另存为              | Save as             |
| `Ctrl+W`            | 关闭当前编辑区      | Close pane          |
| `Ctrl+,`            | 打开设置            | Settings            |
| `Ctrl+B`            | 显示 / 隐藏左侧栏   | Toggle left dock    |
| `Ctrl+J`            | 显示 / 隐藏底部面板 | Toggle bottom panel |
| `Ctrl+反引号`       | 显示 / 隐藏终端面板 | Toggle terminal     |
| `Ctrl+Shift+反引号` | 新建终端            | New terminal        |
| `Ctrl+F`            | 文件内查找          | Find in file        |
| `Ctrl+Shift+F`      | 项目内搜索          | Search project      |

## 编辑

| 键                    | 作用                       | English                  |
| --------------------- | -------------------------- | ------------------------ |
| `h` `j` `k` `l`       | 移动光标                   | Move cursor              |
| `w` / `b` / `e`       | 下一个词 / 上一个词 / 词尾 | Word motions             |
| `0` / `$`             | 行首 / 行尾                | Line start/end           |
| `gg` / `G`            | 文件开头 / 结尾            | File start/end           |
| `i` / `a`             | 光标前 / 后进入插入        | Insert                   |
| `I` / `A`             | 行首 / 行尾进入插入        | Insert at edges          |
| `o` / `O`             | 下方 / 上方新行            | Open line                |
| `d` / `c` / `y` / `p` | 删除 / 修改 / 复制 / 粘贴  | Delete/change/yank/paste |
| `x`                   | 选中整行                   | Select line              |
| `v`                   | 选择模式                   | Select mode              |
| `u` / `U`             | 撤销 / 重做                | Undo / redo              |
| `/`                   | 搜索                       | Search                   |

## 通用

| 键                        | 作用              | English           |
| ------------------------- | ----------------- | ----------------- |
| `Ctrl+/`                  | 注释 / 取消注释   | Toggle comment    |
| `Ctrl+Z` / `Ctrl+Shift+Z` | 撤销 / 重做       | Undo / redo       |
| `Ctrl+Shift+K`            | 删除整行          | Delete line       |
| `Alt+↑` / `Alt+↓`         | 上移 / 下移当前行 | Move line up/down |
| `F2`                      | 重命名符号        | Rename symbol     |
| `F12`                     | 跳到定义          | Go to definition  |
| `Shift+F12`               | 查找引用          | Find references   |
