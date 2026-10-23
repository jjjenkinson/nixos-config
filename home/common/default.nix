{
  pkgs,
  config,
  lib,
  userName,
  ...
}:
{
  # 默认编辑器命令。哪个用户用哪个,在 home/<用户名>/default.nix 里设置。
  options.my.editor = lib.mkOption {
    type = lib.types.str;
    default = "hx";
    description = "EDITOR / VISUAL / SUDO_EDITOR 使用的命令";
  };

  # 本仓库在磁盘上的路径。dotfiles/(niri、noctalia 等可热重载的配置)
  # 通过 out-of-store 软链挂到 ~/.config,靠的就是这个路径。
  #
  # 集中成一个选项的好处:仓库改名/换家目录时只改这里,
  # 不用去每个模块里找硬编码路径。
  # ⚠️ 系统侧的 programs.nh.flake 也有同样的假设,
  #    在 modules/system/nix.nix 里(那里不能用 home 的选项)。
  options.my.repoDir = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/nixos-config";
    defaultText = lib.literalMD "`$HOME/nixos-config`";
    description = "本配置仓库的绝对路径";
  };

  imports = [
    ./rime.nix
    ./shell.nix
    ./yazi.nix
    ./neovim.nix
    ./helix.nix
    ./zed-editor.nix
    ./niri.nix
    ./noctalia.nix
    ./git-ssh.nix
    ./btop.nix
    ./mime.nix # 默认应用设置
  ];

  # 本文件有顶层 options,其余配置必须放在显式 config 下。
  config = {
    # 用户名 / 家目录由 flake.nix 的主机表传入,两台机器共用这份配置。
    home.username = userName;
    home.homeDirectory = "/home/${userName}";
    home.stateVersion = "26.05"; # 首次设置后勿改
    programs.home-manager.enable = true;

    # 重建时把人手修改过的冲突文件直接进回收站(而不是堆一地的 .backup)。
    # ⚠️ 必须赶在 checkLinkTargets 之前导出:该阶段就会读这个变量并处理冲突;
    # 旧写法 entryBefore [ "linkGeneration" ] 太晚,一遇到新冲突文件就会中止激活:
    #   Existing file '...' would be clobbered
    home.activation.setHmBackup = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      export HOME_MANAGER_BACKUP_COMMAND=${pkgs.trash-cli}/bin/trash
    '';

    home.packages = with pkgs; [
      # ── 用户级应用 ────────────────────────────────
      # 注意:firefox / chrome / mpv / vlc / libreoffice / sioyek 在
      # modules/packages/default.nix(系统侧)。它们很少变,放系统侧可以让
      # home 闭包小一点;增删/升级需要 `sudo nh os switch`。
      flclash # 代理客户端(基于 clash meta)

      # ── CLI 工具 ──────────────────────────────────
      bat # cat 替代
      ripgrep # grep 替代
      fd # find 替代
      dust # du 替代,显示目录结构
      duf # df 替代
      # btop 不在 home 安装:系统侧 security.wrappers.btop 提供带 CAP_PERFMON 的版本
      # (核显/独显都能看),配置在 home/common/btop.nix。
      htop
      fastfetch # 系统信息
      inxi # 硬件/系统详情

      ffmpeg

      # 注意:gnumake、nixd/nixfmt、rust-analyzer/rustfmt、pyright/ruff、
      # typst/tinymist 已移到 modules/packages/default.nix(系统侧)。
      # 它们很少变,这样 home 闭包更小(实测 884 → 831 个 store 路径);
      # 对冷启动时间的改善很小,主要是精简 profile。
      # 增删/升级它们需要 `sudo nh os switch`。
    ];

    # 默认编辑器(sudo -e 也会用),具体命令由 my.editor 决定。
    home.sessionVariables = {
      SUDO_EDITOR = config.my.editor;
      EDITOR = config.my.editor;
      VISUAL = config.my.editor;
    };

    # ~/ 下的 XDG 用户目录(文件管理器侧栏、xdg-open、双击文件都依赖它)。
    #
    # 启用后 Home Manager 会写两个只读文件:
    #   ~/.config/user-dirs.dirs —— 目录名与路径
    #   ~/.config/user-dirs.conf —— 内容为 enabled=False,让 xdg-user-dirs-update 别再插手
    # 所以即使系统 locale 是 zh_CN,也不会再生成「文档 / 下载 / 音乐」这类中文目录名。
    #
    # createDirectories:激活时目录不存在就 mkdir(第二台机的新用户需要)。
    # 这里的路径写成 ${config.home.homeDirectory}/xxx 是必需的——
    # user-dirs.dirs 只接受 "$HOME/yyy" 或 "/yyy" 两种形式,写相对路径会被忽略。
    xdg.userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      projects = "${config.home.homeDirectory}/Projects";
      publicShare = "${config.home.homeDirectory}/Public";
      templates = "${config.home.homeDirectory}/Templates";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };
}
