# nixos-config

个人 NixOS 配置，使用 **flake** 统一管理，Home Manager 以**独立模式**运行。
主机名 `XPS9560`，当前系统为 `NixOS 26.05`。

- 系统与用户配置分离：日常改用户环境只需要 `nh home switch`，不用 sudo
- 单份 nixpkgs 配置：系统与 Home Manager 共用 `flake.nix` 里的 `pkgsConfig`
- 少数包走 unstable：Zed、Helix、Noctalia 桌面外壳
- 双桌面：Plasma 6 与 Niri（平铺合成器 + Noctalia 外壳）共存，登录界面（SDDM）里选
- 全中文注释：每个文件都写明了“为什么这么配”

> 这是个人配置，包含本机磁盘 UUID、用户名、代理端口等。直接套用到别的机器前，
> 请先修改 `hosts/` 与 `modules/users/` 下的内容。

## 目录结构

```text
.
├── flake.nix                     # 入口：inputs、pkgs、NixOS 与 Home Manager 配置
├── flake.lock                    # 锁定所有输入的确切版本
├── overlays/
│   └── unstable.nix              # unstable 包名单 + overlay（唯一维护点）
├── hosts/
│   └── XPS9560/
│       ├── default.nix           # 本机入口：import 模块、主机名、stateVersion
│       ├── hardware-configuration.nix  # 安装器生成：磁盘/内核模块，勿手改
│       ├── disks.nix             # btrfs 挂载参数（noatime/压缩等）
│       ├── external-disks.nix    # 额外分区（NTFS 数据盘 /mnt/data）
│       ├── gpu.nix               # 双显卡：核显 + NVIDIA（PRIME offload）
├── modules/                      # 与机器无关的系统配置
│   ├── system/
│   │   ├── default.nix           # system 层汇总入口
│   │   ├── nix.nix               # flakes、二进制缓存、nh
│   │   ├── base.nix              # PipeWire、蓝牙、NetworkManager
│   │   ├── boot.nix              # systemd-boot
│   │   ├── btrfs.nix             # scrub、fstrim、snapper
│   │   └── locale.nix            # 时区、语言、XDG 目录名
│   ├── desktop/
│   │   ├── default.nix           # desktop 层汇总入口
│   │   ├── plasma.nix            # Plasma 6 + SDDM（Wayland）
│   │   ├── niri.nix              # Niri（平铺合成器），与 Plasma 并列可选
│   │   ├── fonts.nix             # 字体与 fontconfig 默认字体
│   │   └── input-method.nix      # fcitx5 + Rime 雾凇拼音
│   ├── packages/
│   │   └── default.nix           # 系统级包：命令行工具 + 大件桌面应用
│   └── users/
│       └── jiro.nix              # 用户账号、用户组、初始密码
└── home/
    └── jiro/
        ├── default.nix           # 用户级入口：home.packages、备份策略
        ├── shell.nix             # fish、starship、kitty、eza、代理函数
        ├── yazi.nix              # yazi 文件管理器（插件、键位、预览）
        ├── git-ssh.nix           # git 身份、GitHub SSH 配置
        ├── neovim.nix            # Neovim
        ├── helix.nix             # Helix（unstable）
        ├── niri.nix              # niri 配置（生成 base.kdl + 挂 config.kdl）
        ├── noctalia.nix          # Noctalia 外壳（unstable）+ 挂基础配置
        ├── zed-editor.nix        # Zed（unstable）与语言服务器
        └── rime.nix              # Rime 的 default.custom.yaml（候选数、Shift 行为）

dotfiles/                         # 自己手改的用户配置（不走 Nix 生成）
├── niri/
│   └── config.kdl                # ← 日常改这里；保存即热重载，不用 rebuild
└── noctalia/
    └── 00-nix.toml               # Noctalia 基础配置（改完 msg config-reload）
```

## 组成概览

| 项目     | 选择                                                                                            |
| -------- | ----------------------------------------------------------------------------------------------- |
| 引导     | systemd-boot（EFI，保留 10 个旧代）                                                             |
| 文件系统 | btrfs（`@` `/home` `/nix` `/var/log` `/var/cache` `@snapshots`）+ 独立 swap 分区 + vfat `/boot` |
| 快照     | snapper（每日 7、每周 4）+ btrfs 自动 scrub                                                     |
| 桌面     | KDE Plasma 6（SDDM/Wayland）；Niri + Noctalia（unstable）登录界面可切换                         |
| 声音     | PipeWire（含 ALSA/PulseAudio 兼容）                                                             |
| 显卡     | Intel HD 630 核显 + NVIDIA GTX 1050M，PRIME offload（`nvidia-offload` 按需调用独显）            |
| 网络     | NetworkManager                                                                                  |
| 输入法   | fcitx5 + Rime 雾凇拼音（`rime-ice`）                                                            |
| 字体     | Maple Mono NF CN、霞鹜文楷/新月黑、Noto CJK、Inter、Libertinus                                  |
| Shell    | fish + starship + kitty                                                                         |
| 文件管理 | yazi（TUI，fish 函数 `y` 退出后自动 cd；git 状态、压缩包预览、smart-enter）                     |
| 编辑器   | Neovim、Helix、Zed（后两者取 unstable）                                                         |
| 排版     | Typst + Tinymist                                                                                |
| Nix 缓存 | 南京大学 / 中科大 / 清华镜像，官方 `cache.nixos.org` 自动兜底（上海交大源会卡死，已移除）       |

## 日常使用

### 前提

`/etc/nixos` 已软链到本仓库，`nh` 才能直接使用：

```bash
sudo rm -rf /etc/nixos
sudo ln -s /home/jiro/nixos-config /etc/nixos
```

### 应用改动

```bash
# 只改了 home/jiro/ 下的内容（不需要 sudo）
nh home switch

# 改了 hosts/、modules/ 或 flake.nix
nh os switch

# 只构建、不切换（检查是否编译通过）
nh os build
```

等价的原始命令：

```bash
home-manager switch --flake .#jiro@XPS9560
sudo nixos-rebuild switch --flake .#XPS9560
```

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

系统层面也可以在开机菜单里选择旧代（保留 10 个）。

### 清理

`modules/system/nix.nix` 已启用 `nh clean`：每周自动清理，保留 30 天内最多 15 代。
手动清理：

```bash
nh clean all
```

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

> 注意：`subvol=@` 这类参数由 `hardware-configuration.nix` 提供，`disks.nix`
> 只追加 `options`，不要在那里写 `device` 或 `subvol`，否则会重复。

## 双桌面（Plasma + Niri）

- **登录切换**：SDDM 会同时列出 `Plasma (Wayland)` 和 `Niri`，选哪个就进哪个
- **系统侧 / 用户侧分工**：`modules/desktop/niri.nix` 负责装 niri、注册会话、
  配 X11 兼容与 noctalia 需要的服务；`home/jiro/niri.nix` 负责 `config.kdl` 与 noctalia
- **配置分两层**：
  - `~/.config/niri/base.kdl`：构建时由 niri 自带 `default-config.kdl` 生成
    （去掉默认的 waybar spawn，alacritty → kitty），在 store 里，随 niri 升级自动更新
  - `~/.config/niri/config.kdl`：软链到仓库里的 `dotfiles/niri/config.kdl`
    （out-of-store 软链），日常编辑这个
- **热重载（不用 rebuild）**：改 `dotfiles/niri/config.kdl` 保存即可，
  niri 会立刻热重载，**不需要 `nh home switch`**。若编辑器用原子保存导致没反应，
  执行 `niri msg action load-config-file`
- **什么时候才需要 rebuild**：改了 `home/jiro/niri.nix` 里的生成规则，或增删软件包
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

## 双显卡（Intel 核显 + NVIDIA 独显）

配置在 `hosts/XPS9560/gpu.nix`（Optimus 笔记本，PRIME render offload）：

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

`home/jiro/rime.nix` 生成 `default.custom.yaml`：

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
- **yazi**：终端文件管理器，配置在 `home/jiro/yazi.nix`

  ```bash
  y          # 进入 yazi（fish 函数），退出后 shell 会停在最后浏览的目录
  ```

  - 键位沿用 yazi 默认（h/j/k/l、空格选中、y/x 复制剪切、d 删除、a 新建、r 重命名），
    只额外加了：`Enter` 智能打开、`C` 压缩、`M` 改权限
  - 预览依赖由 nixpkgs 的 yazi 自带（fd / rg / fzf / zoxide / ffmpeg / poppler /
    chafa / resvg / 7zz），`ouch` 为压缩包目录树预览单独补装
  - **yazi 没有配置热重载**：改 `yazi.nix` 需要 `nh home switch`，然后重开 yazi 才生效

- **eza**：`eza` 别名带 `--icons auto` 和 `--git`；HM 生成的 `ls`/`ll`/`la` 默认不带图标，
  需要的话可用 `home.shellAliases` 覆盖（图标需要 Nerd Font）
- **代理**：默认导出 `127.0.0.1:7890`（flclash），另提供 `proxy_on` / `proxy_off`
  函数；不需要常开代理时，注释 `shell.nix` 里的 `home.sessionVariables` 代理项
- **Git / SSH**：`~/.ssh/id_ed25519` 对应 GitHub，`programs.ssh` 中已配置
  `github.com` 的 Host / IdentityFile / 连接复用
- **编辑器**：Zed 使用 nixd + nixfmt、rust-analyzer、pyright + ruff、tinymist

## 注意事项

1. `hardware-configuration.nix` 由 `nixos-generate-config` 生成，升级或迁移时让工具
   重新生成，不要手工修改。
2. **新增 `.nix` 文件后必须 `git add`**，否则 flake 运行时看不到它（flake 只读取
   已跟踪的文件），会报 `No such file or directory`。
3. `nix build` 生成的 `result` 软链已被 `.gitignore` 忽略，不要 `git add`。
4. `modules/users/jiro.nix` 里的初始密码是明文，仅用于首次安装。建议改成
   `hashedPasswordFile`，并把哈希文件放在仓库之外。
5. 本仓库不含任何私钥或 API Key；Zed 的模型接口只写了地址，密钥需在编辑器内自行填写。
6. 所有磁盘 UUID 都与本机绑定，迁移到其他机器时需要重新生成
   `hardware-configuration.nix` 并检查 `disks.nix` / `external-disks.nix`。

## 迁移到新机器

1. 安装 NixOS 时勾选 flakes（或安装后开启 `nix-command` / `flakes`）
2. 复制 `hosts/XPS9560` 为新主机目录，运行 `nixos-generate-config --dir hosts/<新主机>`
   重新生成硬件配置
3. 修改新主机的 `hardware-configuration.nix`、`disks.nix`、`external-disks.nix`
4. 在 `flake.nix` 里增加对应的 `nixosConfigurations.<新主机>` 与
   `homeConfigurations."<用户>@<新主机>"`
5. `sudo nixos-rebuild switch --flake .#<新主机>`

## License

[MIT](./LICENSE)
