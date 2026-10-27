# Firefox 快捷键

> Firefox 158.0.1（系统侧包，见 `modules/packages/apps.nix`）。本仓库没有
> `user.js` / userChrome，也没有改键位，下表全是默认值。
> 来源：从已装的 `lib/firefox/browser/omni.ja` 里解出的 `browser.xhtml`（键定义）
> 与 `browserSets.ftl`、`devtools/startup/key-shortcuts.ftl`（按键值），
> 比第三方教程准 —— 尤其标签页和 Linux 分支最近有改动。
>
> 表格约定：`| 键 | 作用 | English |`，一行所有列合计 ≤120 字符宽（速查窗口里
> 超宽会被 fzf 截断）。`## ` 标题会作为速查里的段名。
>
> 两处容易踩的键位：按序号跳标签是 **`Alt+1…9`**（不是 `Ctrl+1…9`）；
> `Ctrl+Tab` / `Ctrl+Shift+Tab` 是按标签栏位置前 / 后循环（实测），
> 不是按最近使用顺序。

## 标签页

| 键               | 作用                      | English             |
| ---------------- | ------------------------- | ------------------- |
| `Ctrl+T`         | 新建标签页                | New tab             |
| `Ctrl+W`         | 关闭标签页                | Close tab           |
| `Ctrl+Shift+T`   | 恢复刚关闭的标签页 / 窗口 | Reopen closed tab   |
| `Ctrl+Tab`       | 下一个标签（按位置顺序）  | Next tab (in order) |
| `Ctrl+Shift+Tab` | 上一个标签（按位置顺序）  | Prev tab (in order) |
| `Alt+1…8`        | 跳到第 1–8 个标签         | Go to tab 1-8       |
| `Alt+9`          | 跳到最后一个标签          | Go to last tab      |
| `Ctrl+M`         | 静音 / 取消静音当前标签   | Mute tab            |

## 窗口

| 键             | 作用             | English       |
| -------------- | ---------------- | ------------- |
| `Ctrl+N`       | 新建窗口         | New window    |
| `Ctrl+Shift+P` | 新建隐私窗口     | New private   |
| `Ctrl+Shift+N` | 恢复刚关闭的窗口 | Reopen window |
| `F11`          | 全屏开关         | Fullscreen    |
| `Ctrl+,`       | 打开设置         | Preferences   |
| `Ctrl+Q`       | 退出 Firefox     | Quit          |

## 导航

| 键                         | 作用             | English     |
| -------------------------- | ---------------- | ----------- |
| `Alt+←` / `Ctrl+[`         | 后退             | Back        |
| `Alt+→` / `Ctrl+]`         | 前进             | Forward     |
| `Alt+Home`                 | 回到主页         | Home page   |
| `Ctrl+R` / `F5`            | 重新载入         | Reload      |
| `Ctrl+Shift+R` / `Ctrl+F5` | 忽略缓存重新载入 | Hard reload |
| `Esc`                      | 停止载入         | Stop        |
| `Ctrl+O`                   | 打开本地文件     | Open file   |

## 地址栏与查找

| 键                          | 作用                | English       |
| --------------------------- | ------------------- | ------------- |
| `Ctrl+L` / `Alt+D`          | 聚焦地址栏          | Address bar   |
| `Ctrl+K`                    | 聚焦搜索栏          | Search bar    |
| `Ctrl+F`                    | 页内查找            | Find          |
| `Ctrl+G` / `F3`             | 查找下一个          | Find next     |
| `Ctrl+Shift+G` / `Shift+F3` | 查找上一个          | Find previous |
| `Ctrl+Shift+S`              | 截图（选区 / 整页） | Screenshot    |

## 页面

| 键                  | 作用           | English        |
| ------------------- | -------------- | -------------- |
| `Ctrl++` / `Ctrl+-` | 放大 / 缩小    | Zoom in / out  |
| `Ctrl+0`            | 恢复 100% 缩放 | Reset zoom     |
| `Ctrl+P`            | 打印           | Print          |
| `Ctrl+S`            | 保存页面       | Save page      |
| `Ctrl+U`            | 查看页面源码   | View source    |
| `Ctrl+I`            | 页面信息       | Page info      |
| `Ctrl+Alt+R`        | 阅读模式开关   | Reader mode    |
| `Ctrl+Shift+]`      | 画中画开关     | Picture-in-pic |

## 书签与历史

| 键               | 作用               | English           |
| ---------------- | ------------------ | ----------------- |
| `Ctrl+D`         | 收藏当前页面       | Bookmark page     |
| `Ctrl+Shift+D`   | 收藏所有标签页     | Bookmark all tabs |
| `Ctrl+B`         | 书签侧栏开关       | Bookmarks sidebar |
| `Ctrl+Shift+O`   | 书签库（管理书签） | Bookmarks library |
| `Ctrl+Shift+B`   | 书签工具栏开关     | Bookmarks toolbar |
| `Ctrl+H`         | 历史侧栏开关       | History sidebar   |
| `Ctrl+Shift+H`   | 历史库（管理历史） | History library   |
| `Ctrl+Shift+Del` | 清除最近历史       | Clear history     |

## 侧栏

| 键           | 作用                                        | English         |
| ------------ | ------------------------------------------- | --------------- |
| `Ctrl+Alt+Z` | 侧栏开关                                    | Toggle sidebar  |
| `Ctrl+Alt+U` | 标签页侧栏                                  | Tabs sidebar    |
| `Ctrl+Alt+X` | AI 聊天侧栏（需 `browser.ml.chat.enabled`） | AI chat sidebar |

## 开发者工具

| 键                     | 作用           | English         |
| ---------------------- | -------------- | --------------- |
| `F12` / `Ctrl+Shift+I` | 开发者工具箱   | DevTools        |
| `Ctrl+Shift+C`         | 检查器         | Inspector       |
| `Ctrl+Shift+K`         | Web 控制台     | Web console     |
| `Ctrl+Shift+J`         | 浏览器控制台   | Browser console |
| `Ctrl+Shift+E`         | 网络面板       | Network monitor |
| `Ctrl+Shift+Z`         | JS 调试器      | Debugger        |
| `Ctrl+Shift+M`         | 响应式设计模式 | Responsive mode |
| `Shift+F7`             | 样式编辑器     | Style editor    |
| `Shift+F5`             | 性能面板       | Performance     |
| `Shift+F9`             | 存储面板       | Storage         |

## 其他

| 键                        | 作用                          | English            |
| ------------------------- | ----------------------------- | ------------------ |
| `Ctrl+Shift+A`            | 附加组件管理                  | Add-ons manager    |
| `Ctrl+Shift+Y`            | 下载面板（Linux 键位）        | Downloads          |
| `Shift+Esc`               | 任务管理器（about:processes） | Task manager       |
| `Ctrl+Shift+X`            | 切换文本方向                  | Text direction     |
| `Ctrl+Z` / `Ctrl+Shift+Z` | 撤销 / 重做                   | Undo / redo        |
| `Ctrl+X` / `C` / `V`      | 剪切 / 复制 / 粘贴            | Cut / copy / paste |
| `Ctrl+A`                  | 全选                          | Select all         |
