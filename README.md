# nixos-config

个人 NixOS 配置：**flake** 统一管理，Home Manager 以**独立模式**运行。
当前系统为 `NixOS 26.05`。

| 主机      | 用户   | 桌面            | 说明                                      |
| --------- | ------ | --------------- | ----------------------------------------- |
| `XPS9560` | `jiro` | Plasma 6 + Niri | 真实在用的机器                            |
| `HHHH`    | `XXXX` | 仅 Niri         | **占位模板**，换成真实主机名/用户名后再用 |

> `HHHH` 和 `XXXX` 是占位名称，四处必须一起改：
> `hosts/HHHH/`、`home/XXXX/`、`flake.nix` 的主机表、`hosts/HHHH/default.nix` 里的 `my.user.name`。
> 具体步骤见 [新增一台主机](#新增一台主机)。

---

## 它是怎么工作的

### 1. 三层结构

```text
flake.nix          组装：主机表 → 系统配置 / 用户配置
   │
   ├── hosts/<主机名>/      「这台机器」：硬件、主机名、要哪些桌面
   └── modules/             「所有机器共享」的系统配置
   │
   └── home/common/         「所有用户共享」的用户配置
       home/<用户名>/       「这个用户」：git 身份、默认编辑器等
```

- **`modules/`** 里不放任何一台机器的私货（磁盘 UUID、主机名、用户名）。
- **`hosts/<主机名>/`** 只放与本机硬件绑定、或决定「导入哪些模块组」的内容。
- **`home/common/`** 是两个用户共用的用户环境；**`home/<用户名>/`** 只放个人差异。

### 2. `flake.nix` 如何生成两套输出

```nix
hosts = {
  XPS9560 = { user = "jiro"; };
  HHHH    = { user = "XXXX"; };
};
```

`mapAttrs` 把它展开成：

```text
nixosConfigurations.XPS9560          # 系统：nh os switch
nixosConfigurations.HHHH
homeConfigurations."jiro@XPS9560"    # 用户：nh home switch
homeConfigurations."XXXX@HHHH"
```

求值链：

```mermaid
flowchart TD
    A["flake.nix 主机表"] --> B["nixosConfigurations.&lt;主机名&gt;"]
    B --> C["imports ./hosts/&lt;主机名&gt;"]
    C --> D["hosts/&lt;主机名&gt;/default.nix"]
    D --> E["imports ../../modules/*"]
    E --> F["模块系统合并 → 系统闭包"]
    A --> G["homeConfigurations.&quot;&lt;用户&gt;@&lt;主机名&gt;&quot;"]
    G --> H["home/common + home/&lt;用户名&gt;"]
    H --> I["模块系统合并 → home 闭包"]
```

系统配置与 home 配置是**两次完全独立的模块求值**：

- `my.user` / `my.desktop` 只存在于系统侧
- `my.git` / `my.editor` 只存在于 home 侧

两边只是**约定**都用 `my.` 前缀，并不是同一个命名空间。所以不要指望 home 侧能读到 `my.user`。

### 3. `my.*` 选项是怎么传递的

`my` 不是 Nix 关键字，也没有一个地方「定义 my」。它只是普通的属性路径前缀，
真正被声明的是叶子选项。以 `my.editor` 为例：

```nix
# ① 声明：home/common/default.nix
options.my.editor = lib.mkOption {
  type = lib.types.str;
  default = "hx";
};

# ② 赋值：home/jiro/default.nix（等价于 config.my.editor = "hx"）
my.editor = "hx";

# ③ 读取：home/common/default.nix
home.sessionVariables.EDITOR = config.my.editor;
```

模块系统（`lib.evalModules`）把 `home/common` 和 `home/<用户名>` 放进同一次求值：

1. 收集所有 `options.my.editor`，注册选项和默认值
2. 收集所有 `my.editor = ...`，作为「定义」
3. 合并成最终的 `config.my.editor`
4. 其他模块读 `config.my.editor` 时拿到合并结果

几条规则：

- **必须先声明再赋值**，否则报 `The option 'my.xxx' does not exist`
- `type` 会实际检查；`type = lib.types.str` 赋数字会报错
- 两个模块给**不同的值**会冲突，并提示用 `lib.mkForce` / `lib.mkDefault`
- 不给值就用 `default`，所以只写公共默认、个别用户覆盖即可

> 一个文件里只要出现顶层 `options`，其他配置就必须放进显式 `config = { ... };`
> 或写成 `config.xxx = ...`（`home/common/default.nix` 就是这种写法）。
> 没有 `options` 的文件可以直接写 `my.xxx = ...`。

同样的机制也用在系统侧：`modules/users/default.nix` 声明 `my.user`，
`hosts/*/default.nix` 赋值；`modules/desktop/default.nix` 声明
`my.desktop.plasma.enable`，`hosts/XPS9560/default.nix` 用默认值 `true`，
`hosts/HHHH/default.nix` 显式设为 `false`。

### 4. 主机名是怎么确定的

**没有运行时自动分发**。host 是「构建/切换那一刻」由命令选中的：

- `nh os switch` 默认用当前 `hostname` 去匹配 `nixosConfigurations.<主机名>`
- 也可以显式指定：`nh os switch -H HHHH` 或 `sudo nixos-rebuild switch --flake .#HHHH`
- 选中后，`specialArgs.hostName` 传进 `hosts/<主机名>/default.nix`，
  最终写入 `networking.hostName`。所以**主机名既是选择依据，也是配置结果**。
- 开机时不再选择：每个代际都是某个具体主机的完整闭包。

`nh home switch` 类似，默认尝试 `<当前用户>@<当前主机名>`，
也可用 `-c XXXX@HHHH` 显式指定。

首次安装时 Live ISO 的 hostname 通常是 `nixos`，匹配不到任何配置，
所以**必须显式指定** `.#HHHH`。

---

## 目录结构

```text
.
├── flake.nix                     # 入口：inputs、pkgs、主机表、两套配置
├── flake.lock                    # 锁定所有输入的确切版本
├── overlays/
│   └── unstable.nix              # unstable 包名单 + overlay（唯一维护点）
├── hosts/
│   ├── XPS9560/
│   │   ├── default.nix           # 本机入口：主机名、用户、导入模块
│   │   ├── hardware-configuration.nix  # 安装器生成：磁盘/内核模块，勿手改
│   │   ├── disks.nix             # 挂载参数 + /home 快照子卷（oneshot 创建）
│   │   ├── external-disks.nix    # 额外分区（NTFS 数据盘 /mnt/data）
│   │   └── gpu.nix               # 双显卡：核显 + NVIDIA（PRIME offload）
│   └── HHHH/                     # 占位主机（纯 Niri 的最小模板）
│       ├── default.nix           # my.user.name、my.desktop.plasma.enable = false
│       ├── hardware-configuration.nix  # 占位存根（含假挂载点），安装时覆盖
│       └── disks.nix             # 只在 btrfs 时补 /home 快照子卷
├── modules/                      # 与机器无关的系统配置
│   ├── system/
│   │   ├── default.nix           # system 层汇总入口
│   │   ├── nix.nix               # flakes、二进制缓存、nh
│   │   ├── base.nix              # PipeWire、蓝牙、网络、journald、nix-ld
│   │   ├── boot.nix              # systemd-boot
│   │   ├── btrfs.nix             # scrub、fstrim、snapper
│   │   └── locale.nix            # 时区、语言、XDG 目录名
│   ├── desktop/
│   │   ├── default.nix           # desktop 层入口 + SDDM（与桌面无关）
│   │   ├── plasma.nix            # Plasma 6（受 my.desktop.plasma.enable 控制）
│   │   ├── niri.nix              # Niri（平铺合成器），与 Plasma 并列可选
│   │   ├── fonts.nix             # 字体与 fontconfig 默认字体
│   │   └── input-method.nix      # fcitx5 + Rime 雾凇拼音
│   ├── packages/
│   │   └── default.nix           # 系统级包：命令行工具 + 大件桌面应用
│   └── users/
│       └── default.nix           # 主用户（用户名由每台主机指定）
└── home/
    ├── common/                   # 所有用户共用
    │   ├── default.nix           # 入口：home.packages、备份策略、my.editor 声明
    │   ├── shell.nix             # fish/bash、starship、kitty、eza、代理函数
    │   ├── yazi.nix              # yazi 文件管理器（插件、键位、预览）
    │   ├── git-ssh.nix           # my.git 声明、GitHub SSH 配置
    │   ├── neovim.nix            # Neovim
    │   ├── helix.nix             # Helix（unstable）
    │   ├── niri.nix              # niri 配置（生成 base.kdl + 挂 config.kdl）
    │   ├── noctalia.nix          # Noctalia 外壳（unstable）+ 挂基础配置
    │   ├── zed-editor.nix        # Zed（unstable）与语言服务器
    │   └── rime.nix              # Rime 的 default.custom.yaml（候选数、Shift 行为）
    ├── jiro/                     # jiro 的个人模块目录
    │   └── default.nix           # my.git、my.editor；可继续拆多个文件
    └── XXXX/                     # 占位用户的个人模块目录
        └── default.nix           # my.git、my.editor

dotfiles/                         # 自己手改的用户配置（不走 Nix 生成）
├── niri/
│   └── config.kdl                # ← 日常改这里；保存即热重载，不用 rebuild
└── noctalia/
    └── 00-nix.toml               # Noctalia 基础配置（保存即热重载）
```

**命名约定（必须一致）**：

| 名字   | 出现的地方                                                                                          |
| ------ | --------------------------------------------------------------------------------------------------- |
| 主机名 | `flake.nix` 主机表的键、`hosts/<主机名>/`、`nixosConfigurations.<主机名>`                           |
| 用户名 | `flake.nix` 主机表的 `user`、`home/<用户名>/`、`my.user.name`、`homeConfigurations."<用户>@<主机>"` |

---

## 组成概览

| 项目     | 选择                                                                                            |
| -------- | ----------------------------------------------------------------------------------------------- |
| 引导     | systemd-boot（EFI，保留 15 个旧代）                                                             |
| 文件系统 | btrfs（`@` `/home` `/nix` `/var/log` `/var/cache` `@snapshots`）+ 独立 swap 分区 + vfat `/boot` |
| 快照     | snapper（`/` 与 `/home`，每日 7、每周 4）+ btrfs 自动 scrub                                     |
| 桌面     | KDE Plasma 6（SDDM/Wayland）；Niri + Noctalia（unstable）登录界面可切换                         |
| 声音     | PipeWire（含 ALSA/PulseAudio 兼容）                                                             |
| 显卡     | Intel HD 630 核显 + NVIDIA GTX 1050M，PRIME offload（`nvidia-offload` 按需调用独显）            |
| 网络     | NetworkManager                                                                                  |
| 输入法   | fcitx5 + Rime 雾凇拼音（`rime-ice`）                                                            |
| 字体     | Maple Mono NF CN、霞鹜文楷/新月黑、Noto CJK、Inter、Libertinus                                  |
| Shell    | fish（主力）+ bash（兼容）+ starship + kitty                                                    |
| 文件管理 | yazi（TUI，fish 函数 `y` 退出后自动 cd；git 状态、压缩包预览、smart-enter）                     |
| 编辑器   | Neovim、Helix、Zed（后两者取 unstable）                                                         |
| 排版     | Typst + Tinymist                                                                                |
| Nix 缓存 | 中科大 / 清华 / 南京大学镜像，官方 `cache.nixos.org` 自动兜底（上海交大源会卡死，已移除）       |

> 上表描述的是 XPS9560。`HHHH` 是精简模板：没有 NVIDIA，默认只装 Niri。

---

## 日常使用

### 前提

`nh` 已经直接指向仓库路径（`modules/system/nix.nix` 里的 `programs.nh.flake`），
不再依赖 `/etc/nixos` 软链。下面这条只是习惯做法，方便其他工具去 `/etc/nixos`
找配置，可选（路径按实际用户名替换）：

```bash
sudo rm -rf /etc/nixos
sudo ln -s /home/jiro/nixos-config /etc/nixos
```

### 应用改动

```bash
# 只改了 home/common/ 或 home/<用户名>/ 下的内容（不需要 sudo）
nh home switch

# 改了 hosts/、modules/、flake.nix（需要 sudo）
nh os switch

# 只构建、不切换（检查是否编译通过）
nh os build
```

`nh os switch` 会按当前主机名自动选配置；不是当前主机、或主机名还没生效时用 `-H`：

```bash
sudo nh os switch -H HHHH
```

等价的原始命令：

```bash
# XPS9560
home-manager switch --flake .#jiro@XPS9560
sudo nixos-rebuild switch --flake .#XPS9560

# HHHH
home-manager switch --flake .#XXXX@HHHH
sudo nixos-rebuild switch --flake .#HHHH
```

### 新增一台主机

以现在的 `HHHH` / `XXXX` 占位为例，**四处一起改**：

1. **目录**
   ```bash
   git mv hosts/HHHH hosts/<真实主机名>
   git mv home/XXXX home/<真实用户名>
   ```
2. **`flake.nix` 主机表**
   ```nix
   <真实主机名> = { user = "<真实用户名>"; };
   ```
3. **`hosts/<真实主机名>/default.nix`**
   ```nix
   networking.hostName = hostName;      # 不用改，自动来自主机表
   my.user.name = "<真实用户名>";
   my.desktop.plasma.enable = false;    # 要 KDE 就删掉这行或设为 true
   ```
4. **`home/<真实用户名>/default.nix`**
   ```nix
   my.git = {
     userName = "<真实用户名>";
     userEmail = "<真实 GitHub 邮箱>";
   };
   my.editor = "hx"; # 或 "nvim"
   ```

如果只是加一台全新机器，复制 `hosts/HHHH`（最小模板）比复制 XPS9560 更干净，
不会带进 NVIDIA 和 NTFS 挂载。

### 首次安装（占位主机）

1. 安装 NixOS，勾选 flakes（或安装后启用 `nix-command` / `flakes`）
2. 把仓库克隆到该用户家目录：`/home/<用户名>/nixos-config`
   （`programs.nh.flake` 和 README 的路径都按这个约定）
3. **生成真实硬件配置**（会覆盖占位挂载点）：
   ```bash
   sudo nixos-generate-config --dir hosts/<主机名>
   ```
4. 按实际硬件检查 `hosts/<主机名>/default.nix`：
   - Legacy/BIOS 启动：取消 GRUB 那段注释，并关掉 systemd-boot
   - 核显驱动：Gen7 用 `intel-vaapi-driver`，Gen8+ 用 `intel-media-driver`
5. 首次切换（Live ISO 的 hostname 是 `nixos`，必须显式指定）：
   ```bash
   sudo nixos-rebuild switch --flake .#<主机名>
   ```
6. 之后 hostname 生效，直接 `sudo nh os switch` 即可
7. 首次登录后设置密码：`passwd`（配置里没有声明初始密码）

### 更新依赖

```bash
nix flake update                      # 更新全部输入
nix flake update nixpkgs-unstable     # 只更新 unstable 源
```

`nix flake update` 只改 `flake.lock`，还需要再 `nh os switch` / `nh home switch`
才会应用。

### 格式化

```bash
nix fmt        # 使用 nixfmt 格式化仓库内所有 .nix
```

### 回滚

```bash
sudo nixos-rebuild switch --rollback
home-manager switch --rollback
```

系统层面也可以在开机菜单里选择旧代（保留 15 个）。

### 清理

`modules/system/nix.nix` 已启用 `nh clean`：每周自动清理，保留 30 天内最多 15 代。
手动清理：

```bash
nh clean all
```

---

## unstable 包管理

名单集中在 `overlays/unstable.nix`：

```nix
names = [
  # "google-chrome"
  "zed-editor"
  "helix"
  "noctalia" # Niri 的桌面外壳（unstable 更新更快）
];
```

- **新增**：把包名（nixpkgs 里的顶层属性名）加进 `names`，安装处继续写 `pkgs.xxx`
- **移除**：删掉对应那行
- **整体关闭**：注释掉 `flake.nix` 中 `overlays` 列表里的 `(import ./overlays/unstable.nix { ... })`，
  系统立即回到纯 stable，安装文件一行都不用改
- **注意**：overlay 用的是 `nixpkgs-unstable.legacyPackages`（省一次 nixpkgs 求值），
  它没有 `allowUnfree`。如果以后把 `google-chrome` 这类非自由包加进 `names`，
  需要把 `overlays/unstable.nix` 改回 `import nixpkgs-unstable { inherit system config; }`

---

## 桌面（Plasma + Niri / 纯 Niri）

- **XPS9560**：SDDM 列出 `Plasma (Wayland)` 和 `Niri`；`HHHH` 关掉 Plasma，只留 `Niri`
- **开关**：`modules/desktop/default.nix` 里的 `my.desktop.plasma.enable`（默认 `true`），
  `hosts/HHHH/default.nix` 里设为 `false`
- **登录管理器**：SDDM 定义在 `modules/desktop/default.nix`，与桌面环境无关，两台机器共用
- **系统侧 / 用户侧分工**：`modules/desktop/niri.nix` 负责装 niri、注册会话、
  配 X11 兼容与 noctalia 需要的服务；`home/common/niri.nix` 负责 `config.kdl` 与 noctalia
- **配置分两层**：
  - `~/.config/niri/base.kdl`：构建时由 niri 自带 `default-config.kdl` 生成
    （去掉默认的 waybar spawn，alacritty → kitty），在 store 里，随 niri 升级自动更新
  - `~/.config/niri/config.kdl`：软链到仓库里的 `dotfiles/niri/config.kdl`
    （out-of-store 软链），日常编辑这个
- **热重载（不用 rebuild）**：改 `dotfiles/niri/config.kdl` 保存即可，
  niri 会立刻热重载，**不需要 `nh home switch`**。若编辑器用原子保存导致没反应，
  执行 `niri msg action load-config-file`
- **什么时候才需要 rebuild**：改了 `home/common/niri.nix` 里的生成规则，或增删软件包
- **X11 程序**：niri 25.08 起自带 `xwayland-satellite` 集成，只要
  `environment.systemPackages` 里有 `xwayland-satellite`，有 X11 客户端连接时
  niri 会自动拉起它（也会自动重启），不用写 `spawn-at-startup`
- **输入法**：fcitx5 走 Wayland `text-input` 协议；niri 模块已开启 xdg-autostart，
  所以 fcitx5 会随会话自启

## Noctalia 的设置怎么管

配置文件分两层（官方文档 + 5.3.0 实测）：

| 优先级 | 路径                                              | 谁来写                  |
| ------ | ------------------------------------------------- | ----------------------- |
| 低     | `~/.config/noctalia/*.toml`（按文件名字母序合并） | 我们（软链到 dotfiles） |
| 高     | `~/.local/state/noctalia/settings.toml`           | noctalia 设置界面       |

- **两个目录都被监听，保存即热重载**，不用执行命令也不用 rebuild
  （`noctalia msg config-reload` 只是手动兜底）
- **`~/.config/noctalia/` 下的文件永远不会被 noctalia 重写**，包括版本升级迁移。
  迁移只升 `settings.toml`；配置目录里的旧键只在读取时临时规范化，
  并在通知里指出「文件:行:键」让你自己改。⇒ 软链和文件名都是稳定的
- **想写死的项**：写进 `dotfiles/noctalia/00-nix.toml`（文件名前缀决定覆盖顺序，越大越靠后）
- **用界面调**：改动会写进 `settings.toml`，并且**压过**上面文件里的同名键。
  想让配置文件的值得胜，就把 `settings.toml` 里对应键删掉
- **查可用键**：`noctalia config export full`（含内置默认值，约 750 行）
- **校验**：`noctalia config validate`（按真实加载顺序，含 `settings.toml`）
- **备份当前界面设置**：`noctalia config export merged > dotfiles/noctalia/settings-export.toml`
  （恢复：拷回 `~/.local/state/noctalia/settings.toml`；如果是软链，noctalia 会写入链接目标并保留链接）

## 双显卡（Intel 核显 + NVIDIA 独显，仅 XPS9560）

配置在 `hosts/XPS9560/gpu.nix`（Optimus 笔记本，PRIME render offload）。
`HHHH` 作为纯 Intel 模板，不 import 这个文件，只开 `hardware.graphics.enable` +
`intel-vaapi-driver`（HD 4000 是 Gen7，用 i965 驱动；实际硬件不同要相应调整）。

- **平时全部跑核显**，独显空闲（省电、发热低、续航正常）
- **需要独显时**用 `nvidia-offload` 启动单个程序：

  ```bash
  nvidia-offload glxinfo | grep "OpenGL renderer"   # 确认真的用的是独显
  nvidia-offload steam
  nvidia-smi                                        # 查看两张卡状态
  ```

- **驱动分支必须是 `legacy_580`**：nixpkgs 的 `stable` 已是 595 系列，
  而 NVIDIA 从 580 之后不再支持 Pascal（GTX 10xx）。升级 nixpkgs 时不要把它改回默认。
- **不要开 `hardware.nvidia.powerManagement`**：动态断电只支持 Turing 及以后，Pascal 上开了会出问题。
- 第一次从 nouveau 切到 nvidia 后**需要重启**。

## 输入法（Rime 雾凇拼音）

`home/common/rime.nix` 生成 `default.custom.yaml`：

- 候选词数量：7
- `Shift_L` = `commit_code`：把已输入的拼音原样上屏为英文，并切到英文
- `Shift_R` = `inline_ascii`：进入临时西文模式，空格/回车确认后回到中文
- 文件内容变化时自动删除 `~/.local/share/fcitx5/rime/build/default.yaml`，
  让 Rime 重新编译配置（Rime 只按 mtime 判断配置是否更新）

如果升级 nixpkgs 改动了 `rime-ice` 词库或方案，需要手动清一次完整缓存：

```bash
rm -rf ~/.local/share/fcitx5/rime/build
```

## 用户环境

- **Shell**：fish + starship；kitty 作为终端，字体 `Maple Mono NF CN`
- **yazi**：终端文件管理器，配置在 `home/common/yazi.nix`

  ```bash
  y          # 进入 yazi（fish 函数），退出后 shell 会停在最后浏览的目录
  ```

  - 键位沿用 yazi 默认（h/j/k/l、空格选中、y/x 复制剪切、d 删除、a 新建、r 重命名），
    只额外加了：`Enter` 智能打开、`C` 压缩、`M` 改权限
  - 预览依赖由 nixpkgs 的 yazi 自带（fd / rg / fzf / zoxide / ffmpeg / poppler /
    chafa / resvg / 7zz），另外补了 `ouch`（压缩包预览）、`git`（状态标记）、
    `wl-clipboard`（系统剪贴板）
  - **yazi 没有配置热重载**：改 `yazi.nix` 需要 `nh home switch`，然后重开 yazi 才生效

- **eza**：`eza` 别名带 `--icons auto` 和 `--git`；HM 生成的 `ls`/`ll`/`la` 默认不带图标，
  需要的话可用 `home.shellAliases` 覆盖（图标需要 Nerd Font）
- **fzf / zoxide**：fish 与 bash 都启用了 shell 集成：
  `Ctrl-R` 历史、`Ctrl-T` 文件、`Alt-C` 目录；`z <关键字>` 跳目录、`zi` 交互式选择。
  这些是 shell 里直接可用的，和 yazi 内部自带的 fzf/zoxide 是两套（互不影响）
- **代理**：**默认不导出任何代理变量**。需要时在 fish / bash 里执行 `proxy_on`
  （导出 `127.0.0.1:7890`，flclash），用完 `proxy_off`。这样 flclash 没启动时，
  `git` / `curl` 不会去连一个不存在的代理；两种 shell 的函数定义都在 `shell.nix`，
  变量只在函数体里写一份
- **Git / SSH**：提交身份在 `home/<用户名>/default.nix`（`my.git.userName` / `my.git.userEmail`），
  不写在 `flake.nix` 里；`~/.ssh/id_ed25519` 对应 GitHub，`programs.ssh` 中已配置
  `github.com` 的 Host / IdentityFile / 连接复用
- **编辑器**：终端默认编辑器由 `my.editor` 控制（jiro 用 `hx`，占位用户示例用 `nvim`），
  同时写入 `EDITOR` / `VISUAL` / `SUDO_EDITOR`；Zed 使用 nixd + nixfmt、
  rust-analyzer、pyright + ruff、tinymist

## 注意事项

1. **`hardware-configuration.nix` 不要手改**。XPS9560 的是安装器生成的真实文件；
   `HHHH` 里的是占位存根（含假挂载点），首次安装前必须用
   `nixos-generate-config --dir hosts/HHHH` 覆盖。
2. **新增 `.nix` 文件后必须 `git add`**，否则 flake 运行时看不到它（flake 只读取
   已跟踪的文件），会报 `No such file or directory`。
3. `nix build` 生成的 `result` 软链已被 `.gitignore` 忽略，不要 `git add`。
4. **没有声明初始密码**。首次安装后需要进 TTY 用 `passwd` 设一次；
   要声明式管理就换成 `hashedPasswordFile`，哈希文件放在仓库之外（如 `/run/secrets/<用户名>-password`）。
5. 本仓库不含任何私钥或 API Key；Zed 的模型接口只写了地址，密钥需在编辑器内自行填写。
6. 所有磁盘 UUID 都与本机绑定，迁移到其他机器时需要重新生成
   `hardware-configuration.nix` 并检查 `disks.nix` / `external-disks.nix`。
7. `/home` 的 snapper 配置要求 `/home/.snapshots` 是一个子卷，
   由各自主机 `hosts/*/disks.nix` 里的 `create-home-snapshots-subvolume` 开机时补齐
   （只在根分区是 btrfs 时生效），迁移/重装后不要删掉这个服务。
8. `hosts/<主机名>/` 与 `home/<用户名>/` 的目录名必须和 `flake.nix` 主机表一致，
   否则会报 `path does not exist`。

## License

[MIT](./LICENSE)
