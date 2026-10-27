# 更新日志

本文件记录本项目所有值得注意的改动。
格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

只记有实际行为变化的改动，每条 1–2 行，说清「改了什么 / 为什么」；
纯格式化、注释整理不单独记。版本标题后的日期是打标签的日期。

## [Unreleased]

### Added

- 新增项目内 Agent 技能 `.agents/skills/nixos-config-change/`：改配置时判断
  层级、遵守约定、选择验证命令、同步文档与快捷键表
- 新增 `docs/CHANGELOG.md`（本文件）
- 新增 `keys` 命令（`home/common/keys.nix`）与 `Alt+Shift+/`：按当前焦点窗口
  打开对应应用的表（`dotfiles/keybindings/*.md`）。终端窗口会再识别前台进程
  （hx / nvim / yazi …）；缺表时用 `notify-send` 通知
- 按桌面环境自动选探测方式：niri（`niri msg --json`）、mango（`mmsg`）、
  KDE（`kdotool`）、其余 X11（`xdotool`）。KDE 的快捷键需手动绑一次（Plasma 6 限制）
- 新增四份表：`keybindings/{kitty,zed,helix,yazi}.md`
- 新增 `neovim.md`：`home/common/neovim.nix` 只设了 `clipboard` / 行号，
  所以整表是 0.12.4 默认键位，按 `:help index` + `nvim --clean` 的 `:map` 输出整理；
  标出 0.12 新增的默认映射（`[`/`]` 家族、`gc`、`gx`、`gn`、matchit 默认启用），
  并注明 `[d`/`]d` 已被诊断跳转占用、`Y` 是 `y$`
- 新增 `firefox.md`：Firefox 158.0.1 默认键位，从已装包的 `browser/omni.ja` 解出
  `browser.xhtml` + `browserSets.ftl` 核对；标出 `Alt+1…9` 切标签等反直觉项
- 新增 `home/common/browser-proxy.nix`：Chrome / Edge 在 niri 下读不到「系统代理」
  （只认 GNOME / KDE），所以覆盖 `~/.local/share/applications` 的 .desktop：
  启动时探测本地代理端口，在监听才加 `--proxy-server`，否则直连；只增加 36 KiB，
  不把浏览器包拉进 home 闭包
- 新增 Rust 工具链到系统侧：`rustc` / `cargo` / `clippy` / `gcc`（链接器 `cc`）；
  与已有的 `rustfmt` / `rust-analyzer` 放在一起。`cargo new/run/clippy/fmt` 已实测可用
- 新增一个本地重打包的 `.deb` 软件，并放到系统侧（定义见 `pkgs/`）
- 新增 `mdpreviewer` 0.1.3（`pkgs/mdpreviewer.nix`，上游 x86_64-linux 预编译
  tarball + `autoPatchelfHook`）：Markdown / Typst 的浏览器实时预览，给 Helix
  这类无内建预览的编辑器当外部预览器用；装在 home 侧 (`home/common/default.nix`)
- Helix 接入 `mdpreviewer`：`Ctrl+s` 保存后把预览同步到光标行，`\m` / `\r` /
  `\q` 打开或切换、重启、关闭预览服务；插入模式也补了 `Ctrl+s`
- 新增 `efibootmgr`（双系统排查）、`microsoft-edge`
- Mango：`Super+N` 切换平铺算法并由 `mango-layout` 弹出当前算法名
- Mango：`Super+P`（选区 + satty 标注）/ `Super+Ctrl+P`（整屏）截图
- Mango：`Ctrl+Alt+Delete` 会话面板、`Super+Alt+L` 锁屏
- Mango：`Super+Shift+/` 打开速查表
- Mango：新增 `mango-xdg-autostart` oneshot，补上 mango 不会拉起 XDG 自启动的问题
- Niri：`Mod+Shift+Home` / `Mod+Shift+End` 把当前工作区顶到最上 / 最下
- Niri：`Mod+F10` Zed、`Mod+F11` 默认文件管理器、`Mod+F12` 默认浏览器
- 新增 `dotfiles/keybindings/sioyek.md`：Sioyek 2.0.0 上游默认键位（当时本机没有
  `keys_user.config`，整表取自包自带的 `/etc/sioyek/keys.config`），按打开 / 翻页 /
  搜索 / 书签 / 高亮 / 传送门等 11 类整理
- sioyek 配置纳入仓库：`dotfiles/sioyek/{prefs,keys}_user.config` 以文件级软链挂到
  `~/.config/sioyek/`（包仍在系统侧）。改仓库文件不用 `nh home switch`，重启 sioyek
  后生效；目录本身保持真实，`shared.db` 等运行时数据不入库

### Changed

- 图片默认关联跟随 Plasma：有 Plasma 用 gwenview，没有则 home 侧安装 `swayimg`
  并关联 `image/*` 的 14 种常见格式；与视频 / 音频 / 网页 / 目录一起集中在
  `home/common/mime.nix`（以前无 Plasma 的主机不写图片关联，双击图片会打不开）
- `my.fileManager` 改为跟随主机表的 `plasma` 字段：有 Plasma 就用自带的
  Dolphin，没有则由 home 侧安装 Thunar 并设为 `inode/directory` 默认程序
- Plasma 开关从 `hosts/<主机>/default.nix` 上移到 `flake.nix` 主机表的 `plasma`
  字段，系统侧 `specialArgs`、home 侧 `extraSpecialArgs` 各读一份；home 不再读
  `nixosConfigurations`，`nh home switch` 不再连带求值整套 NixOS 配置
- `README.md` 精简为项目简介，详细内容收进单文件 `docs/guide.md`
  （架构 + 程序结构 + 四张流程图 + 用法 + 桌面 / 硬件 / 用户环境要点）
- `.gitignore` 补 `result` / `result-*`（`nix build` 的软链）与 `.bak*`
- 引导器从 systemd-boot 换成 **Limine**：菜单字体可缩放、支持链式启动另一个 ESP 上的 Windows
- Limine 使用 Catppuccin Mocha 配色 + 壁纸（`share/wallpapers/wpBootloader1.png`），
  `maxGenerations = 10`
- Windows 启动项按 PARTUUID 指向 `nvme0n1p2` 的 `bootmgfw.efi`，不依赖分区编号
- 合并 `hosts/XPS9560/external-disks.nix` 到 `disks.nix`：两者都是「本机磁盘」，
  合并后少一个 import；额外分区用 `//` 并进 `fileSystems`（同一 attrset 不能写两次）
- 速查显示方式定为 **终端 + fzf 单栏列表**：窗口固定 0.66×0.8，输入关键字实时过滤，
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
- `dotfiles/keybindings/zed.md` 按 Zed 1.25.2 重写：补上预览 / 终端 / 调试 /
  AI 助手 / 编辑预测五类，并把 **Picker** 单独成段（`Ctrl+Shift+S` 多选、
  `Ctrl+Shift+A` 动作菜单，来自 `specific-overrides.json` 的 `Picker > Editor`）
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
- `zed.md` 按 Zed 1.24.2 官方 keymap 重写：补全 `g` / `Space` 系列与 LSP 跳转，
  并在表头说明三层键位的真实优先级（Helix → vim 通用 → Zed 默认）；修正两处错标：
  `Shift+F12` 是「跳实现」、「Alt+Shift+F12」才是查找引用，vim 下 `Ctrl+D` 是翻半页
  （加选下一个相同词要用 `Ctrl+K Ctrl+D`）
- 补全三张常用表：`kitty.md` 按 0.49.1 默认值补齐分屏 / 滚动 / hints / 配置，
  并标出本机改的 `Ctrl+Shift+W` 与 `Alt+1..9`；`helix.md` 按 25.07.1 官方 keymap
  补 goto / Space / 窗口 / 选择器，修正 `G`、`0`/`$`、`Space g`、宏 `Q`/`q` 等误记；
  `niri.md` 补 `Mod+F10–F12` 启动器与 `Ctrl+Alt+Insert`
- `yazi.md` 按 26.5.6 默认 keymap 补全（浏览 / 选择 / 文件 / 标签 / 排序 /
  行模式 / 输入框），并标明本机只用 `prepend_keymap` 改了 `Enter` / `C` / `M`
- `helix.md` 再按 `keymap/default.rs` 复核：修正 `0` / `$` 的说明（`$` 是
  `shell_keep_pipe`，不是行尾）；补 `Space e/E` 文件树、`Space Alt+c`、`Ctrl+W t`、
  `]e/[e`、`g j/g k`、`Alt+x`、`z m`、`Ctrl+z`，并注明 `Tab` 等同 `Ctrl+i`
- starship 提示符改为三行：整行 `─` 分隔线（`$fill`，随窗口宽度自适应；
  颜色用 overlay0 而不是默认的 near-black）、信息行、输入行
- 上一条命令的耗时显示在**分隔线正中**（starship `cmd_duration`）：`format` 里用
  两段 `$fill` 夹住它 —— 同一行的多个 `$fill` 会平分剩余宽度（实测 50 列 → 23 + 23），
  就不需要自己算居中；`min_time = 2000` 只报 2 秒以上的命令，未到阈值时中间为空，
  两段 fill 接上仍是一条整线。试过用 fish `fish_postexec` / bash `DEBUG trap`
  在命令输出后另打一行，改成这个方案后把那两段钩子删掉了
- bash 与 fish 一样由 starship 渲染提示符（`enableBashIntegration` 显式写出，默认也开）
- Helix 的配置移入 `dotfiles/helix/` 并软链到 `~/.config/helix/`：改完保存，
  在 Helix 里 `:config-reload` 即可，不需要 `nh home switch`
- Zed 改为「两层 + 软链」：`home/common/zed-editor.nix` 只放稳定且有结构的部分
  （扩展、终端、`languages`、`lsp.nixd`），每次 switch 用 jq 递归合并；
  主题、字体、AI 等常改项在 `dotfiles/zed/settings.json`，
  `~/.config/zed/settings.json` 软链到它 —— GUI 改动会直接进 git。
  另加 activation 自愈：软链被换成普通文件时先写回仓库再重建
- Helix `languages.toml` 的格式化命令改用 PATH 里的 `nixfmt`，不再写死 store 路径
- 压缩 / 线程摘要 / 提交信息曾指向免费的 `glm-4.7-flash`，但该模型常报 429
  「访问量过大」，现已注释掉，回落到主模型 `deepseek/deepseek-flash`（要花钱，
  想省下来可换成 `glm-5.3-flash`）
- Zed 的 `agent.*`（默认模型、压缩阈值 / 压缩模型、工具权限）从
  `dotfiles/zed/settings.json` 移进 `home/common/zed-editor.nix`：这些键很少变，
  放 Nix 侧才能写注释、走类型检查；仓库 JSON 只留主题、字体等纯外观项
- `modules/packages/` 拆成两个文件：`default.nix`（系统基础设施 + 工具链 + btop wrapper）
  和 `apps.nix`（大件 GUI 应用），用注释说明「放系统侧是为省 home 切换时间」
- Kopuz 的 `callPackage` 移到 `apps.nix`
- Mango 主力修饰键统一为 **Super**，与 niri 对齐；上游 `Alt+Return` / `Alt+Space` /
  `Alt+Q` / `Alt+方向` 等旧绑定注释掉，不两套并存
- Mango 关闭窗口改为 `Super+Q`，铺满改为 `Super+F`
- Niri 注释掉 `empty-workspace-above-first`，不再常驻最上方空工作区
- Niri `Mod+N`（浏览器）解绑
- `mangowc` 加入 unstable 名单（stable 0.12.x → unstable 0.18.x）
- unstable 实例改为 `import nixpkgs-unstable { inherit system config; }`，
  与主 `pkgs` 共用 `allowUnfree`，否则 unfree 的 `wechat` 求值报错
- `helix` 从 unstable 名单移除（两个通道版本接近）

### Fixed

- 修正四处陈旧说明：`dotfiles/README.md` 补 mango、`00-nix.toml` 的引用路径、
  `niri/KEYS.md` 补 `Mod+Shift+Home/End`、`locale.nix` 里双系统时钟的注释
- 修 `keys` 的前台程序识别：Nix 包装器的 `/proc/<pid>/comm` 是 `.hx-wrapped`
  这种名字，先去掉 `.` 前缀和 `-wrapped` 后缀再匹配；同时把「shell → 前台作业」
  沿途的候选逐个查表，避免编辑器派生的 LSP 子进程把结果盖掉
- 顺带修正旧配置里的无效键：`programs`、`helix_mod`、`clear_thinking`、
  重复的 `project_context`，以及会报 `FormatterList` 解析错的嵌套 `code_actions`
- Zed AI 成本：`auto_compact` 的键名写错（`enable` → `enabled`），此前阈值
  实际按默认 90% 生效，配合 1M 上下文声明，单次请求可涨到 55 万 token。
  现在改为绝对 167000；主模型 `max_output_tokens` 32000 → 30000
- 修 Zed Python 格式化的真正原因：`formatter` 只接受 `auto` / `none` / `prettier` /
  `external` / `code_action`（字符串）/ `language_server` 这几种变体，原来的
  `[{ code_actions = { … } }]` 用的是不存在的 `code_actions`，所以 Zed.log 反复报
  `FormatterList` 解析失败、Python 退回默认格式化器。现在改成两阶段：
  `code_actions_on_format`（Ruff 整理 import / fixAll）→ `formatter.language_server`（ruff）
- 修正 Zed 压缩 / 摘要 / 提交信息模型的 provider：必须写
  `language_models.openai_compatible` 下的键名（`ZhipuAI`），原来写
  `openai_compatible` 查不到 provider，会静默回落主模型（telemetry 实测压缩
  走的是 `deepseek/deepseek-flash`）；压缩阈值同时改为绝对 167000
- 修正 Zed `delete_path` 的放行 pattern：工具拿到的是「项目名/相对路径」
  （`nixos-config/docs/…`），原来写绝对路径 `^/home/jiro/nixos-config/docs/`
  永远匹配不到；现在由 `config.my.repoDir` 取 basename 拼接，改仓库目录名时自动跟随
- 修复 `modules/desktop/mango.nix` 重复函数头导致的求值失败

### Removed

- 删掉两个 1.25 已不存在的失效键 `project_context` / `include_active_editor_context`

## [1.0.0] - 2026-10-25

### Added

- 初始化仓库：flake + 独立模式 Home Manager（`nh home switch` 不需要 sudo）
- 配置 GitHub SSH：`IdentityFile`、`IdentitiesOnly`、连接复用，`~/.ssh/sockets` 权限 700
- 新增 `dotfiles/niri/KEYS.md`，记录 niri 全部绑定，`Mod+/` 打开
- 新增 MangoWC 桌面，与 Niri、Plasma 共存，登录界面里可切换
- 补齐 Mango 快捷键、截图脚本、平铺算法切换通知
- 登录管理器记住上次会话与上次用户名
- 新增音乐播放器（Kopuz 本地打包、LX Music），默认音视频播放统一交给 mpv
- 新增 `home/common/mime.nix`：视频 / 音频 / 网页 / 目录四类默认应用
- 新增 `my.editor`，不同用户可用不同默认编辑器
- 引入 `hosts/HHHH` + `home/XXXX` 占位，支持第二台只装 niri 的机器
- 新增 yazi，`y` 进入、`q` 退出后 shell 目录跟随
- `nix.settings` 加 `connect-timeout` / `stalled-download-timeout`，镜像卡住时快速跳过

### Changed

- 登录管理器换成 **lemurs**（纯文本 TUI，不依赖合成器，故障时错误直接打在 tty）
- 明确 `KEYS.md` 是独立文档：改动 `config.kdl` 后需手动更新
- 说明两个通道的命名差异：属性名都是 `mangowc`，pname 分别是 `mangowc` / `mango`
- 整套配置重构：`hosts/` 描述机器、`home/` 描述人、`modules/` 放共享零件，
  `flake.nix` 只负责组装
- 主机名 / 用户名收敛到 `flake.nix` 的主机表，通过 `specialArgs` 注入
- 桌面开关统一成 `my.desktop.{niri,plasma,mango}.enable`
- btop 改为系统侧 `security.wrappers.btop`：`CAP_PERFMON` 看核显，
  `cudaSupport` 提供 NVML RUNPATH 看独显
- 默认布局不预置 GPU 面板，按 `5` / `6` 临时打开
- 用户名不再写死，`modules/users` 按 `my.user.name` 建账号并加入
  `wheel` / `networkmanager` / `video` / `seat`
- git 身份从 `flake.nix` 移到 `home/<用户名>/default.nix`
- yazi 的 git 状态列通过 `prepend_fetchers` 注册，插件本身不会自动生效
- unstable 包集中到 `overlays/unstable.nix` 一个名单里
- 关闭 unstable 只需注释掉 `flake.nix` 里的一处 import，安装文件不用改

### Fixed

- 修复 `inode/directory` 被 kitty 抢走的问题（desktop ID 必须写
  `org.kde.dolphin.desktop`）
- 修复 `nh home switch` 过慢：工具链与大件 GUI 移到系统侧，home 闭包从
  884 降到 831 个 store 路径

[Unreleased]: https://github.com/jjjenkinson/nixos-config/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/jjjenkinson/nixos-config/releases/tag/v1.0.0
