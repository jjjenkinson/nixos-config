# dotfiles

这里放**我自己直接编辑**的用户配置文件（不由 Nix 生成内容）。

## 为什么要单独放

Nix store 是只读的：凡是由 Nix 生成的文件，改一个字都要 `nh home switch` 重新构建。
把「想随手改」的配置留在 store 外，程序就能靠自己的文件监视立刻热重载。

## 怎么接进 home

在 `home/common/*.nix` 里用 out-of-store 软链：

```nix
xdg.configFile."niri/config.kdl".source =
  config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixos-config/dotfiles/niri/config.kdl";
```

效果：

- `~/.config/niri/config.kdl` 指向本目录的文件
- 直接编辑、保存，niri 会热重载，**不需要 `nh home switch`**
- 文件仍在 git 里，改动可追溯、可回滚

## 约定

- 目录按程序名分组：`dotfiles/niri/`、`dotfiles/foo/`
- 只放「以文本为主、需要频繁手改」的配置
- 软件包、系统服务、能用 Nix 表达好的设置，继续留在 `home/` 与 `modules/` 里

## 当前内容

| 路径                   | 被谁读取                                        | 生效方式                                                                                                         |
| ---------------------- | ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `niri/config.kdl`      | niri（经 `~/.config/niri/config.kdl`）          | 保存即热重载；异常时 `niri msg action load-config-file`                                                          |
| `mango/config.conf`    | mango（经 `~/.config/mango/config.conf`）       | 保存即热重载（`auto_reload_config=1`）                                                                           |
| `noctalia/00-nix.toml` | Noctalia（经 `~/.config/noctalia/00-nix.toml`） | 保存即热重载（配置目录被监听）；会被 `~/.local/state/noctalia/settings.toml` 覆盖同名键；noctalia 不会重写该目录 |
| `helix/config.toml`    | Helix（经 `~/.config/helix/config.toml`）       | 保存后在 Helix 里执行 `:config-reload`（它不监视配置文件）                                                       |
| `helix/languages.toml` | Helix（经 `~/.config/helix/languages.toml`）    | 同上                                                                                                             |
| `zed/settings.json`    | Zed（经 `~/.config/zed/settings.json` 软链）    | 保存即生效；但每次 `nh home switch` 会被 HM 合并后重写（注释丢失）                                               |
| `niri/KEYS.md`         | kitty（`Mod+/` 打开）                           | 手写速查表，改键位后需手动同步                                                                                   |
| `mango/KEYS.md`        | kitty（`Super+Shift+/` 打开）                   | 同上                                                                                                             |

## 已知限制

- **静态文本，没有 Nix 插值**。需要绝对路径的地方只能写死。
  所以 `dotfiles/helix/languages.toml` 里的命令一律写裸名字（从 PATH 找），
  不要写 `/nix/store/…`。
- **程序可能回写这些文件**。用 GUI 改 Noctalia 的设置时，
  改的是仓库里的文件，`git status` 会变脏 —— 这是热重载的代价，不是 bug。
- **别让 Nix 和软链抢同一个路径**。比如写了 `programs.helix.settings`，
  Home Manager 会生成 store 文件把软链顶掉，热重载就失效了。对应选项必须保持为空。

## Zed 的特殊之处

Zed 的 nixd 配置需要按主机名/用户名插值，静态文件做不到，所以它是
「Nix 管稳定项 + 仓库文件 + 软链」的组合：

- 稳定项（扩展、`terminal`、`languages`、`lsp`）在 `home/common/zed-editor.nix`
- 常改项（主题、字体、AI）在 `dotfiles/zed/settings.json`
- `~/.config/zed/settings.json` 软链到上面那份，所以 GUI 改动直接写进仓库文件
- 每次 `nh home switch`：HM 用 jq 把 Nix 静态值与仓库文件递归合并后写回，
  所以**该文件里的注释会被抹掉**，注释写 Nix 侧
- 软链由 activation 自愈：若某个程序原子保存把它换成了普通文件，
  会先把内容写回仓库、再重建软链
