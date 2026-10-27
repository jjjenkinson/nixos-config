# Sioyek 快捷键

> Sioyek 2.0.0-unstable-2026-04-08（`modules/packages/apps.nix` 里的 `pkgs.sioyek`）。
> 本机没有 `~/.config/sioyek/keys_user.config`，仓库里也没有 sioyek 配置，
> 所以下表全部来自包自带的 `/etc/sioyek/keys.config`，即上游默认键位。
>
> 几个容易忽略的点：大多数移动命令都能带数字前缀（`150gg` 跳到第 150 页）；
> `q` 是退出整个程序，`Ctrl+w` 才是关窗口；`k` / `j` 只在已经放下视觉标记
> （右键点击）后才生效；`h` / `m` / `p` 都是“前缀键”，按完要再按一个字母。
>
> 表格约定：`| 键 | 作用 | English |`，第 3 列是英文；一行所有列合计 ≤110 列宽。
> `## ` 标题会作为速查里的段名。

## 打开与窗口

| 键       | 作用                 | English               |
| -------- | -------------------- | --------------------- |
| `o`      | 打开文件对话框       | Open document         |
| `Ctrl+o` | 内嵌文件选择器       | Embedded file picker  |
| `Ctrl+O` | 从当前文件目录开始选 | Picker at current dir |
| `O`      | 最近打开的文档列表   | Recent documents      |
| `Ctrl+t` | 新建窗口             | New window            |
| `Ctrl+w` | 关闭当前窗口         | Close window          |
| `q`      | 退出 sioyek          | Quit                  |

## 翻页与移动

| 键                              | 作用                              | English             |
| ------------------------------- | --------------------------------- | ------------------- |
| `gg` / `Ctrl+Home`              | 跳到开头（可带页码，如 `150gg`）  | Go to beginning     |
| `G` / `End`                     | 跳到结尾                          | Go to end           |
| `Home`                          | 弹出输入框，输入页码跳转          | Go to page          |
| `t`                             | 目录（TOC）                       | Table of contents   |
| `Space` / `PageDown`            | 下一屏                            | Screen down         |
| `Shift+Space` / `PageUp`        | 上一屏                            | Screen up           |
| `Ctrl+PageDown` / `Ctrl+PageUp` | 下一页 / 上一页                   | Next / prev page    |
| `gc` / `gC`                     | 下一章 / 上一章                   | Next / prev chapter |
| `^` / `$`                       | 页面左 / 右边缘（忽略留白）       | Page edges          |
| `zz`                            | 跳到页面右上角（适合双栏）        | Top-right corner    |
| `→` / `←`                       | 视图左移 / 右移（上游绑定是反的） | Move left / right   |

## 历史

| 键                           | 作用           | English        |
| ---------------------------- | -------------- | -------------- |
| `Backspace` / `Ctrl+←`       | 上一个浏览位置 | Previous state |
| `Shift+Backspace` / `Ctrl+→` | 下一个浏览位置 | Next state     |

## 缩放与旋转

| 键         | 作用                | English         |
| ---------- | ------------------- | --------------- |
| `+` / `-`  | 放大 / 缩小         | Zoom in / out   |
| `=` / `F9` | 适配页宽            | Fit width       |
| `F10`      | 适配页宽并忽略留白  | Fit width smart |
| `r` / `R`  | 顺时针 / 逆时针旋转 | Rotate          |

## 搜索

| 键                | 作用                     | English           |
| ----------------- | ------------------------ | ----------------- |
| `/` / `Ctrl+f`    | 搜索文档（可带页码范围） | Search            |
| `c/` / `c Ctrl+f` | 只在当前章节搜索         | Search chapter    |
| `n` / `N`         | 下一个 / 上一个结果      | Next / prev match |

## 书签

| 键   | 作用                 | English            |
| ---- | -------------------- | ------------------ |
| `b`  | 添加书签（输入说明） | Add bookmark       |
| `db` | 删除书签             | Delete bookmark    |
| `gb` | 本文档的书签列表     | Document bookmarks |
| `gB` | 所有文档的书签列表   | All bookmarks      |

## 高亮

| 键            | 作用                 | English               |
| ------------- | -------------------- | --------------------- |
| `h` + 字母    | 添加高亮，字母是类型 | Add highlight         |
| `gh` / `gH`   | 本文档 / 全部高亮    | Highlights            |
| `dh`          | 删除选中的高亮       | Delete highlight      |
| `gnh` / `gNh` | 下一个 / 上一个高亮  | Next / prev highlight |

## 标记

| 键             | 作用                  | English               |
| -------------- | --------------------- | --------------------- |
| `m` + 字母     | 设置标记              | Set mark              |
| `` ` `` + 字母 | 跳到标记              | Go to mark            |
| `k` / `j`      | 视觉标记上 / 下移一行 | Visual mark up / down |
| `↑` / `↓`      | 同上（方向键）        | Visual mark arrows    |

## 传送门

| 键                | 作用                 | English              |
| ----------------- | -------------------- | -------------------- |
| `p`               | 设置传送门源 / 目标  | Portal               |
| `dp`              | 删除最近的传送门     | Delete portal        |
| `gp` / `Tab`      | 跳到传送门           | Go to portal         |
| `P` / `Shift+Tab` | 编辑传送门目标       | Edit portal          |
| `F12`             | 开关辅助窗口         | Helper window        |
| `l`               | 查看当前行的定义预览 | Overview definition  |
| `Ctrl+]`          | 跳到定义             | Go to definition     |
| `]`               | 传送门到定义         | Portal to definition |

## 选择与剪贴板

| 键       | 作用                     | English             |
| -------- | ------------------------ | ------------------- |
| `v`      | 键盘选择文本             | Keyboard select     |
| `F`      | 键盘智能跳转             | Keyboard smart jump |
| `f`      | 用键盘打开链接           | Open link           |
| `Ctrl+c` | 复制选中文字             | Copy                |
| `s`      | 用外部搜索引擎搜选中文字 | External search     |
| `:`      | 打开命令行               | Command line        |

## 显示与模式

| 键    | 作用             | English           |
| ----- | ---------------- | ----------------- |
| `F11` | 全屏             | Fullscreen        |
| `F8`  | 反色（深色模式） | Dark mode         |
| `F1`  | 高亮链接         | Highlight links   |
| `F4`  | Synctex 模式开关 | Toggle synctex    |
| `F5`  | 演示模式         | Presentation mode |
| `F6`  | 鼠标拖动平移     | Mouse drag mode   |
| `F7`  | 视觉滚动模式     | Visual scroll     |
