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

  # # 重建时自动备份被接管的既有文件(等价于原 NixOS 侧 backupFileExtension = "backup")
  # home.activation.setHmBackup = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
  #   export HOME_MANAGER_BACKUP_EXT=backup
  #   export HOME_MANAGER_BACKUP_OVERWRITE=1   # 同名 .backup 已存在时覆盖旧的
  # '';
  # home-manager重建时，旧的冲突文件直接进回收站,而不是堆一地的 `.backup`(HM 手册推荐的写法):
  home.activation.setHmBackup = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
    export HOME_MANAGER_BACKUP_COMMAND=${pkgs.trash-cli}/bin/trash
  '';

  imports = [
    ./rime.nix
    ./shell.nix
    ./neovim.nix
    ./helix.nix
    ./zed-editor.nix
    ./git-ssh.nix
  ];

  home.packages = with pkgs; [
    # 用户级软件包
    firefox
    google-chrome # 版本由 overlays/unstable.nix 决定
    mpv
    vlc
    # wpsoffice-cn
    libreoffice
    sioyek # pdf阅读器
    flclash # Proxy client based on clashmeta

    # cli工具
    bat # cat替代
    ripgrep # grep替代
    fd # find替代
    dust # du替代，显示目录结构
    # tree # 和dust类似
    # eza # ls替代
    duf # df替代
    btop # btop系统监控
    fastfetch # 显示系统基本信息
    inxi # 全面显示系统信息
    gnumake

    # lsp
    nixd # nix语言的lsp
    # nil    # nix语言的lsp
    nixfmt # nix官方格式器
    rust-analyzer
    rustfmt
    pyright
    ruff

    # ── 排版 / Typst ────────────────────────────────
    typst # 编译器本体(typst compile / watch)
    tinymist # LSP + 实时预览 + 格式化(编辑器集成用)
  ];

  # 设置用户级默认编辑器，sudo -e也可以使用
  home.sessionVariables = {
    SUDO_EDITOR = "hx";
    EDITOR = "hx";
    VISUAL = "hx";
  };

}
