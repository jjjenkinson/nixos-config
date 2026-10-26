# 更改记录

记录每次有实际行为变化的改动。格式参考 Keep a Changelog，日期为提交日期。

约定：

- **未发布**：已改但还没提交（或已提交未打标签）
- 每条 1–2 行，说清「改了什么 / 为什么」，不贴代码
- 纯格式化、注释整理不单独记

## 未发布

### 文档

- `README.md` 精简为项目简介，详细内容收进单文件 `docs/guide.md`
  （架构 + 程序结构 + 四张流程图 + 用法 + 桌面 / 硬件 / 用户环境要点）
- 新增项目内 Agent 技能 `.agents/skills/nixos-config-change/`：改配置时判断
  层级、遵守约定、选择验证命令、同步文档与快捷键表
- 新增 `docs/CHANGELOG.md`（本文件）
- `.gitignore` 补 `result` / `result-*`（`nix build` 的软链）与 `.bak*`
- 修正四处陈旧说明：`dotfiles/README.md` 补 mango、`00-nix.toml` 的引用路径、
  `niri/KEYS.md` 补 `Mod+Shift+Home/End`、`locale.nix` 里双系统时钟的注释

### 引导

- 引导器从 systemd-boot 换成 **Limine**：菜单字体可缩放、支持链式启动另一个 ESP 上的 Windows
- Limine 使用 Catppuccin Mocha 配色 + 壁纸（`share/wallpapers/wpBootloader1.png`），
  `maxGenerations = 10`
- Windows 启动项按 PARTUUID 指向 `nvme0n1p2` 的 `bootmgfw.efi`，不依赖分区编号

### 结构

- 合并 `hosts/XPS9560/external-disks.nix` 到 `disks.nix`：两者都是「本机磁盘」，
  合并后少一个 import；额外分区用 `//` 并进 `fileSystems`（同一 attrset 不能写两次）

### 快捷键速查

- 新增 `keys` 命令（`home/common/keys.nix`）与 `Alt+Shift+/`：按当前焦点窗口
  打开对应应用的表（`dotfiles/keybindings/*.md`）。终端窗口会再识别前台进程
  （hx / nvim / yazi …）；缺表时用 `notify-send` 通知。
  niri / mango 原有系统快捷键未动；没有焦点窗口时显示各自的完整表
- 按桌面环境自动选探测方式：niri（`niri msg --json`）、mango（`mmsg`）、
  KDE（`kdotool`）、其余 X11（`xdotool`）。KDE 的快捷键需手动绑一次（Plasma 6 限制）
- 新增四份表：`keybindings/{kitty,zed,helix,yazi}.md`
- 显示方式定为 **终端 + fzf 单栏列表**：窗口固定 0.66×0.8，输入关键字实时过滤，
  Enter 只关闭。表格在运行时用 awk 拍平成「段名 / 按键 / 中文 / 英文」并用
  `column -t` 对齐（fzf 自己不排齐列，中文宽度也对不上）；表头行不收录
- `Mod+/`、`Super+Shift+/` 不再自己开 `bat` 窗口，统一改成 `keys niri` / `keys mango`，
  三个入口行为一致；顺带删掉 `niri-keys` / `mango-keys` 两条窗口规则
- 新增文档约定：表格第 3 列是英文说明，新增键位要求中英各写一遍
- 键位表目录 `dotfiles/keys/` 改名为 `dotfiles/keybindings/`，并把
  `niri/KEYS.md` / `mango/KEYS.md` 也合并进来成为 `niri.md` / `mango.md`：
  文件名统一就是 `keys <表名>` 要找的名字，脚本里「应用表 + 合成器表」
  两套查找路径简化为一条（`~/.config/{niri,mango}/KEYS.md` 软链保留，方便手动查看）
- 六张表全部补上英文列（中文同步做简略化）：中文 / 英文都能在 fzf 里搜；
  并按 `AGENTS.md` 的宽度约定重排：一行所有列（含段名）**≤110 字符宽**
  （原先 mango 178 列、niri 131 列，超出窗口的部分一直被截断）
- 弹窗终端从 kitty 换成 **foot**：实测「按下 → 窗口出现」kitty 240ms、foot 80ms，
  而脚本 + awk/column + fzf 合计才 45ms —— 迟钝的瓶颈全在 kitty 新开窗口上
  （跳自己的配置 `--config NONE` 只快 10ms，`single_instance=yes` 也不复用进程）。
  foot 用独立配置文件（`font=Maple Mono NF CN:size=12`、`pad=6x6`），
  不碰 `~/.config/foot/foot.ini`；`--app-id=keys` 让原有两条窗口规则继续生效，
  niri / mango 的配置只改了注释。kitty 仍是 `Mod+T` 的终端
- 弹窗配色调暗：foot 默认是纯黑底 + 纯白字，而 fzf 默认把当前行画成 256 色的
  `bg+=237`（浅灰），`--layout=reverse` 下就贴在顶部像一条白带。现在 foot 用
  `#1b1b1b` 底 / `#c8c8c8` 字，fzf 显式指定整套颜色（当前行 `#2f2f2f`），
  bg 与 foot 保持一致，不会有拼缝
- 收录规则改为「表头带「作用」列才进速查」：mango 末尾的「niri 对照」两张表
  列语义不同，不再混进取速查（否则会把 `column -t` 的列宽撑坏）
- 拍平时去掉 `反引号` 与 `**粗体**` 标记；keysym 改用键帽写法
  （`Mod+[` / `Mod+,` / `Mod+-`），完整拼写放表下散文里

### 用户环境

- starship 提示符改为三行：整行 `─` 分隔线（`$fill`，随窗口宽度自适应；
  颜色用 overlay0 而不是默认的 near-black）、信息行、输入行
- 上一条命令的耗时显示在**分隔线正中**（starship `cmd_duration`）：`format` 里用
  两段 `$fill` 夹住它 —— 同一行的多个 `$fill` 会平分剩余宽度（实测 50 列 → 23 + 23），
  就不需要自己算居中；`min_time = 2000` 只报 2 秒以上的命令，未到阈值时中间为空，
  两段 fill 接上仍是一条整线。试过用 fish `fish_postexec` / bash `DEBUG trap`
  在命令输出后另打一行，改成这个方案后把那两段钩子删掉了
- bash 与 fish 一样由 starship 渲染提示符（`enableBashIntegration` 显式写出，默认也开）

### 编辑器

- Helix 的配置移入 `dotfiles/helix/` 并软链到 `~/.config/helix/`：改完保存，
  在 Helix 里 `:config-reload` 即可，不需要 `nh home switch`
- Zed 改为「两层 + 软链」：`home/common/zed-editor.nix` 只放稳定且有结构的部分
  （扩展、终端、`languages`、`lsp.nixd`），每次 switch 用 jq 递归合并；
  主题、字体、AI 等常改项在 `dotfiles/zed/settings.json`，
  `~/.config/zed/settings.json` 软链到它 —— GUI 改动会直接进 git。
  另加 activation 自愈：软链被换成普通文件时先写回仓库再重建
- 顺带修正旧配置里的无效键：`programs`、`helix_mod`、`clear_thinking`、
  重复的 `project_context`，以及会报 `FormatterList` 解析错的嵌套 `code_actions`
- Helix `languages.toml` 的格式化命令改用 PATH 里的 `nixfmt`，不再写死 store 路径

### 软件包

- 新增 Rust 工具链到系统侧：`rustc` / `cargo` / `clippy` / `gcc`（链接器 `cc`）；
  与已有的 `rustfmt` / `rust-analyzer` 放在一起。`cargo new/run/clippy/fmt` 已实测可用
- 新增一个本地重打包的 `.deb` 软件，并放到系统侧（定义见 `pkgs/`）
- `modules/packages/` 拆成两个文件：`default.nix`（系统基础设施 + 工具链 + btop wrapper）
  和 `apps.nix`（大件 GUI 应用），用注释说明「放系统侧是为省 home 切换时间」
- 新增 `efibootmgr`（双系统排查）、`microsoft-edge`
- Kopuz 的 `callPackage` 移到 `apps.nix`

### Mango

- 主力修饰键统一为 **Super**，与 niri 对齐；上游 `Alt+Return` / `Alt+Space` /
  `Alt+Q` / `Alt+方向` 等旧绑定注释掉，不两套并存
- 关闭窗口改为 `Super+Q`，铺满改为 `Super+F`
- `Super+N` 切换平铺算法并由 `mango-layout` 弹出当前算法名
- `Super+P`（选区 + satty 标注）/ `Super+Ctrl+P`（整屏）截图
- `Ctrl+Alt+Delete` 会话面板、`Super+Alt+L` 锁屏
- `Super+Shift+/` 打开 `KEYS.md` 速查表
- 新增 `mango-xdg-autostart` oneshot，补上 mango 不会拉起 XDG 自启动的问题
- 修复 `modules/desktop/mango.nix` 重复函数头导致的求值失败

### Niri

- 新增 `dotfiles/niri/KEYS.md`，`Mod+/` 用浮动 kitty 打开；该文件手写，改键位后要手动同步
- `Mod+Shift+Home` / `Mod+Shift+End`：把当前工作区顶到最上 / 最下
- `Mod+F10` Zed、`Mod+F11` 默认文件管理器、`Mod+F12` 默认浏览器
- 注释掉 `empty-workspace-above-first`，不再常驻最上方空工作区
- `Mod+N`（浏览器）解绑

### unstable 管理

- `mangowc` 加入 unstable 名单（stable 0.12.x → unstable 0.18.x）
- unstable 实例改为 `import nixpkgs-unstable { inherit system config; }`，
  与主 `pkgs` 共用 `allowUnfree`，否则 unfree 的 `wechat` 求值报错
- `helix` 从名单移除（两个通道版本接近）

## 2026-10-23

### 快捷键速查表

- 新增 `dotfiles/niri/KEYS.md`，记录 niri 全部绑定，`Mod+/` 打开
- 明确该文件是独立文档：改动 `config.kdl` 后需手动更新

### Mango 加入

- 新增 MangoWC 桌面，与 Niri、Plasma 共存，登录界面里可切换
- 补齐快捷键、截图脚本、平铺算法切换通知
- 说明两个通道的命名差异：属性名都是 `mangowc`，pname 分别是 `mangowc` / `mango`

### 登录器与结构重构

- 登录管理器换成 **lemurs**（纯文本 TUI，不依赖合成器，故障时错误直接打在 tty）
- 记住上次会话与上次用户名
- 整套配置重构：`hosts/` 描述机器、`home/` 描述人、`modules/` 放共享零件，
  `flake.nix` 只负责组装
- 主机名 / 用户名收敛到 `flake.nix` 的主机表，通过 `specialArgs` 注入
- 桌面开关统一成 `my.desktop.{niri,plasma,mango}.enable`

## 2026-10-21

### 音乐、默认应用与杂项

- 新增音乐播放器（Kopuz 本地打包、LX Music），默认音视频播放统一交给 mpv
- 新增 `home/common/mime.nix`：视频 / 音频 / 网页 / 目录四类默认应用
- 修复 `inode/directory` 被 kitty 抢走的问题（desktop ID 必须写
  `org.kde.dolphin.desktop`）
- 整理注释

### btop GPU 监控

- btop 改为系统侧 `security.wrappers.btop`：`CAP_PERFMON` 看核显，
  `cudaSupport` 提供 NVML RUNPATH 看独显
- 默认布局不预置 GPU 面板，按 `5` / `6` 临时打开

### 多主机与多用户

- 引入 `hosts/HHHH` + `home/XXXX` 占位，支持第二台只装 niri 的机器
- 用户名不再写死，`modules/users` 按 `my.user.name` 建账号并加入
  `wheel` / `networkmanager` / `video` / `seat`
- git 身份从 `flake.nix` 移到 `home/<用户名>/default.nix`
- 新增 `my.editor`，不同用户可用不同默认编辑器

### yazi

- 新增 yazi，`y` 进入、`q` 退出后 shell 目录跟随
- git 状态列通过 `prepend_fetchers` 注册，插件本身不会自动生效

## 2026-10-20

### 切换速度

- 修复 `nh home switch` 过慢：工具链与大件 GUI 移到系统侧，home 闭包从
  884 降到 831 个 store 路径
- `nix.settings` 加 `connect-timeout` / `stalled-download-timeout`，镜像卡住时快速跳过

### unstable overlay

- unstable 包集中到 `overlays/unstable.nix` 一个名单里
- 关闭时只需注释掉 `flake.nix` 里的一处 import，安装文件不用改

## 2026-10-19

- 初始化仓库：flake + 独立模式 Home Manager（`nh home switch` 不需要 sudo）
- 配置 GitHub SSH：`IdentityFile`、`IdentitiesOnly`、连接复用，`~/.ssh/sockets` 权限 700
