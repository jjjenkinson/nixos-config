# Kitty 快捷键

> kitty 0.49.1。只列常用项；完整列表见 `kitty --debug-config` 里的 `shortcuts` 段。
> 本仓库（`home/common/shell.nix`）额外改了 `Ctrl+Shift+W` 和 `Alt+1..9`，其余是默认值。
>
> 表格约定：`| 键 | 作用 | English |`，第 3 列是英文；一行所有列（含段名）合计
> ≤110 列宽（速查窗口里超宽会被 fzf 截断）。`## ` 标题会作为速查里的段名。

## 标签

| 键                 | 作用                     | English            |
| ------------------ | ------------------------ | ------------------ |
| `Ctrl+Shift+T`     | 新建标签页               | New tab            |
| `Ctrl+Shift+W`     | 关闭标签页（本仓库改）   | Close tab (custom) |
| `Ctrl+Shift+Q`     | 关闭标签页（kitty 默认） | Close tab (stock)  |
| `Ctrl+Shift+Enter` | 新建窗口                 | New window         |
| `Ctrl+Shift+←/→`   | 上一个 / 下一个标签      | Prev / next tab    |
| `Alt+1` … `Alt+9`  | 跳到第 1–9 个标签        | Jump to tab 1-9    |

## 剪贴板

| 键                              | 作用                 | English         |
| ------------------------------- | -------------------- | --------------- |
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | 复制 / 粘贴          | Copy / paste    |
| `Shift+Insert`                  | 粘贴 X11 主选区      | Paste selection |
| `Ctrl+Shift+S`                  | 同上                 | Same            |
| `Ctrl+Shift+↑/↓`（或 `K/J`）    | 向上 / 向下滚一行    | Scroll one line |
| `Ctrl+Shift+H`                  | 在分页器里看回滚缓冲 | Open scrollback |

## 字号

| 键                     | 作用              | English    |
| ---------------------- | ----------------- | ---------- |
| `Ctrl+Shift+=` / `-`   | 字号放大 / 缩小   | Font +/-   |
| `Ctrl+Shift+Backspace` | 字号还原          | Font reset |
| `Ctrl+Shift+E`         | 用 hints 打开 URL | Open URL   |
