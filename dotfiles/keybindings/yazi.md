# Yazi 快捷键

> Yazi 26.5.6。只列常用项；完整键位见 `~/.config/yazi/keymap.toml` 与 `~`（帮助）。
> 本仓库在 `home/common/yazi.nix` 里加了 `Enter`（智能进入/打开）、`C`（压缩）、`M`（改权限）。
>
> 表格约定：`| 键 | 作用 | English |`，第 3 列是英文；一行所有列（含段名）合计
> ≤110 列宽。`## ` 标题会作为速查里的段名。

## 浏览

| 键              | 作用                    | English              |
| --------------- | ----------------------- | -------------------- |
| `h` `j` `k` `l` | 父目录 / 下 / 上 / 进入 | Parent/down/up/enter |
| `gg` / `G`      | 第一个 / 最后一个       | First / last         |
| `H` / `L`       | 后退 / 前进（目录历史） | Back / forward       |
| `J` / `K`       | 预览区向下 / 向上滚动   | Scroll preview       |
| `.`             | 显示 / 隐藏隐藏文件     | Toggle hidden        |
| `z` / `Z`       | zoxide 跳转（模糊）     | zoxide jump          |
| `~`             | 帮助                    | Help                 |

## 打开

| 键              | 作用                                   | English              |
| --------------- | -------------------------------------- | -------------------- |
| `Enter`         | 智能进入：目录进入、文件用默认程序打开 | Smart open           |
| `o` / `O`       | 打开 / 选择其他程序打开                | Open with            |
| `Space`         | 选中 / 取消选中                        | Select / unselect    |
| `v`             | 可视选择模式                           | Visual mode          |
| `/` / `n` / `N` | 搜索 / 下一个 / 上一个                 | Search / next / prev |

## 文件

| 键        | 作用                  | English            |
| --------- | --------------------- | ------------------ |
| `y` / `x` | 复制 / 剪切           | Copy / cut         |
| `p` / `P` | 粘贴 / 粘贴并覆盖     | Paste / paste over |
| `d` / `D` | 移到回收站 / 永久删除 | Trash / delete     |
| `a` / `r` | 新建 / 重命名         | Create / rename    |
| `C`       | 压缩选中项（插件）    | Compress (plugin)  |
| `M`       | 修改权限（插件）      | Chmod (plugin)     |

## 标签

| 键        | 作用                       | English        |
| --------- | -------------------------- | -------------- |
| `t`       | 新建标签页                 | New tab        |
| `1` … `9` | 切到第 1–9 个标签页        | Go to tab 1-9  |
| `q`       | 退出（shell 跟到当前目录） | Quit, cd shell |
| `Q`       | 退出且不改变 shell 目录    | Quit, keep cwd |
