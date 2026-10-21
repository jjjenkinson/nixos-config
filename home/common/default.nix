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
      # `nh home switch` 的求值少实例化几个包;增删/升级需要 `sudo nh os switch`。
      flclash # 代理客户端(基于 clash meta)

      # ── CLI 工具 ──────────────────────────────────
      bat # cat 替代
      ripgrep # grep 替代
      fd # find 替代
      dust # du 替代,显示目录结构
      duf # df 替代
      btop # 系统监控
      fastfetch # 系统信息
      inxi # 硬件/系统详情
      gnumake

      # ── LSP / 格式化 ──────────────────────────────
      nixd # Nix LSP
      nixfmt # Nix 格式化
      rust-analyzer
      rustfmt
      pyright
      ruff

      # ── 排版 / Typst ──────────────────────────────
      typst # 编译器
      tinymist # LSP + 实时预览 + 格式化
    ];

    # 默认编辑器(sudo -e 也会用),具体命令由 my.editor 决定。
    home.sessionVariables = {
      SUDO_EDITOR = config.my.editor;
      EDITOR = config.my.editor;
      VISUAL = config.my.editor;
    };
  };
}
