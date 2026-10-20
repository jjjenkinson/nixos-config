{
  pkgs,
  lib,
  ...
}:
{
  home.username = "jiro";
  home.homeDirectory = "/home/jiro";
  home.stateVersion = "26.05"; # 首次设置后勿改
  programs.home-manager.enable = true;

  # 重建时把人手修改过的冲突文件直接进回收站(而不是堆一地的 .backup)。
  # ⚠️ 必须赶在 checkLinkTargets 之前导出:该阶段就会读这个变量并处理冲突;
  # 旧写法 entryBefore [ "linkGeneration" ] 太晚,一遇到新冲突文件就会中止激活:
  #   Existing file '...' would be clobbered
  home.activation.setHmBackup = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    export HOME_MANAGER_BACKUP_COMMAND=${pkgs.trash-cli}/bin/trash
  '';

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

  # 默认编辑器(sudo -e 也会用)。
  home.sessionVariables = {
    SUDO_EDITOR = "hx";
    EDITOR = "hx";
    VISUAL = "hx";
  };
}
