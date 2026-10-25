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

### 软件包

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
