# dotfiles

这里放**我自己直接编辑**的用户配置文件（不由 Nix 生成内容）。

## 为什么要单独放

Nix store 是只读的：凡是由 Nix 生成的文件，改一个字都要 `nh home switch` 重新构建。
把「想随手改」的配置留在 store 外，程序就能靠自己的文件监视立刻热重载。

## 怎么接进 home

在 `home/jiro/*.nix` 里用 out-of-store 软链：

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

| 路径                   | 被谁读取                 | 热重载                   |
| ---------------------- | ------------------------ | ------------------------ |
| `niri/config.kdl`      | niri（经 `~/.config/niri/config.kdl`） | 是（保存即生效；异常时执行 `niri msg action load-config-file`） |
