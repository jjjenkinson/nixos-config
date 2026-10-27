# nixos-config

个人 NixOS 配置仓库：**flake** 统一管理，Home Manager 以**独立模式**运行
（`nh home switch` 不需要 sudo）。当前系统 `NixOS 26.05`。

| 主机      | 用户   | 桌面                    | 说明                                                  |
| --------- | ------ | ----------------------- | ----------------------------------------------------- |
| `XPS9560` | `jiro` | Plasma 6 + Niri + Mango | 在用机器：Intel + NVIDIA 双显卡，与 Windows 11 双系统 |
| `HHHH`    | `XXXX` | 仅 Niri                 | **占位模板**，换成真实主机名/用户名后即可用于新机器   |

> `HHHH` / `XXXX` 是占位名。要改的只有两处目录名加一条主机表，主机名和用户名会由
> flake 自动注入，别在任何 `.nix` 里再抄一遍。步骤见 [新增一台主机](docs/guide.md#新增一台主机)。

## 特点

- **系统与用户分离**：`nh os switch`（系统）和 `nh home switch`（用户）互不牵连，
  改用户配置不用 sudo，也不用重启系统
- **三套桌面共存**：Plasma 6 / Niri / MangoWC，登录时选；每台机器用开关决定装哪些
- **两类配置**：主体用 Nix 声明式管理；`dotfiles/` 里是可以手改、保存即热重载的
  纯文本配置（niri、mango、noctalia等），日常调键位不用 rebuild
- **unstable 集中管理**：哪些包走 unstable 只写在一个 overlay 文件里，
  注释掉一行就能整体退回 pure stable
- **随处可呼出快捷键速查表**：自动监测当前激活窗口，`Alt+Shift+/` 弹出一个浮动窗口，可以使用fzf速查当前应用的快捷键。 `Super+Shift+/` 呼出窗口管理器的快捷键速查表
- **双系统**：Limine 引导 NixOS 和 Windows，Windows 的 ESP 只读不改

## 快速开始

```bash
nh home switch          # 改了 home/**（不需要 sudo）
sudo nh os switch       # 改了 hosts/**、modules/**、flake.nix
nh os build             # 只构建不切换，检查是否编译通过
```

开机菜单里可以直接选旧代回滚；系统侧回滚命令见 [日常用法](docs/guide.md#更新与回滚)。

## 目录速览

```text
.
├── flake.nix              # 入口：inputs、pkgs、主机表、两套输出
├── hosts/<主机名>/        # 「这台机器」：硬件、磁盘、显卡、桌面开关
├── modules/               # 「所有机器共享」的系统配置
│   ├── system/            #   引导、btrfs、locale、基础服务、nix 设置
│   ├── packages/          #   default.nix = 系统基础；apps.nix = GUI 应用
│   ├── desktop/           #   登录器、Plasma、Niri、Mango、字体、输入法
│   └── users/             #   用户与用户组
├── home/
│   ├── common/            # 「所有用户共享」的用户环境
│   └── <用户名>/          # 「这个用户」：git 身份、默认编辑器
├── overlays/unstable.nix  # unstable 包名单（唯一维护点）
├── dotfiles/              # 手改 + 热重载的配置（niri / mango / noctalia）
├── .agents/skills/        # 给 Zed Agent 的项目内技能
└── docs/                  # 详细文档与更改记录
```

## 文档

| 文档                          | 内容                                             |
| ----------------------------- | ------------------------------------------------ |
| [使用手册](docs/guide.md)     | 架构、目录、日常用法、桌面、硬件与引导、用户环境 |
| [更改记录](docs/CHANGELOG.md) | 按日期记录的改动                                 |

## 几条硬性约定

1. **`hardware-configuration.nix` 不手改**：真实机器的是安装器生成的；
   占位主机里的是示例，首次安装前必须用 `nixos-generate-config --dir` 覆盖
2. **新增 `.nix` 文件后必须 `git add`**：flake 只读 Git 已跟踪的文件，
   否则报 `No such file or directory`
3. **主机名/用户名只写在两处**：`flake.nix` 的主机表、对应目录名
4. **磁盘 UUID、`/home` 子卷这类东西与机器绑定**，迁移机器时重新生成

细节都在 [使用手册](docs/guide.md) 里。

## License

[MIT](./LICENSE)
