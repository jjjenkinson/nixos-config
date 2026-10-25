# Zed。版本由 overlays/unstable.nix 决定(不写 package 即 pkgs.zed-editor)。
#
# 设置分两部分：
#   1. 本文件的 userSettings：很少变、且要按机器/用户动态生成的部分
#      （语言、LSP、终端、扩展）。每次 `nh home switch` 由 HM 合并进 settings.json。
#   2. dotfiles/zed/settings.json：主题、字体、AI 等常改项。
#      ~/.config/zed/settings.json 是指向它的软链，所以：
#      - Zed GUI 改设置 = 直接改仓库文件（git 可见）
#      - HM 合并后的结果也写回仓库文件
#
# 为什么用软链而不是硬链：git checkout/restore 会改写仓库里的目标文件，
# 软链指向路径所以不会断；硬链共享 inode，目标一旦被替换就静默分叉。
#
# 合并规则（mutableUserSettings = true，每次 switch 执行）：
#   读 settings.json → 与 Nix 静态值 jq 递归合并（对象递归合并；标量、数组以 Nix 为准）
#   → 用严格 JSON 覆盖写回。由此得到两个必须知道的结论：
#   - settings.json 里的注释每次 switch 都会被抹掉 → 注释写在本文件里
#   - 从 Nix 删掉某个键，settings.json 里原来那份仍会保留（需要手动删）
{
  config,
  hostName,
  lib,
  pkgs,
  ...
}:

let
  # 仓库里那份可编辑、可提交的 Zed 设置
  settingsFile = "${config.my.repoDir}/dotfiles/zed/settings.json";
in
{
  # 保证 ~/.config/zed/settings.json 始终是指向仓库的软链。
  #
  # 为什么需要自愈：如果某个程序用“临时文件 + rename”原子保存，
  # 软链会被换成普通文件。这里先把普通文件的内容写回仓库（不丢数据），
  # 再重建软链。
  # 必须赶在 zedSettingsActivation 之前，让 HM 的合并写进仓库文件。
  home.activation.zedSettingsLink = lib.hm.dag.entryBefore [ "zedSettingsActivation" ] ''
    link=${lib.escapeShellArg "${config.xdg.configHome}/zed/settings.json"}
    mkdir -p ${lib.escapeShellArg "${config.xdg.configHome}/zed"}
    if [ ! -L "$link" ]; then
      if [ -f "$link" ]; then cp -f "$link" ${lib.escapeShellArg settingsFile}; fi
      rm -f "$link"
      ln -sfn ${lib.escapeShellArg settingsFile} "$link"
    fi
  '';

  programs.zed-editor = {
    enable = true;

    # 显式写出来：允许 Zed 改写 settings.json，HM 只往里合并，不做软链。
    mutableUserSettings = true;

    # 写成 auto_install_extensions 进 settings.json，之后由 Zed 自己下载。
    extensions = [
      "nix"
      "catppuccin" # 主题
      "typst" # 语言支持 + 预览
      "toml"
    ];

    userSettings = {
      format_on_save = "on";

      # 写 store 路径，不依赖终端 PATH。
      terminal.shell.program = "${pkgs.fish}/bin/fish";

      # ── 各语言 ────────────────────────────────────────────────────
      # 结构性强、很少改，放 Nix 侧由类型检查兜底。
      languages = {
        "Nix" = {
          language_servers = [
            "nixd"
            "!nil"
          ];
          format_on_save = "on";
          formatter.external.command = "nixfmt";
        };
        "Markdown" = {
          format_on_save = "on";
          markdown_preview.open_markdown_files_in_preview = true;
        };
        "Rust" = {
          language_servers = [ "rust-analyzer" ];
          format_on_save = "on"; # rust-analyzer 内部会调 rustfmt
          tab_size = 4;
        };
        "Python" = {
          language_servers = [
            "pyright"
            "ruff"
          ];
          format_on_save = "on";
          # ⚠️ 点号必须写在同一个属性名里（加引号），
          # 否则 Nix 会解析成嵌套对象，Zed 会报
          # "data did not match any variant of untagged enum FormatterList"。
          formatter = [
            {
              code_actions = {
                "source.fixAll.ruff" = true;
                "source.organizeImports.ruff" = true;
              };
            }
            {
              language_server.name = "ruff";
            }
          ];
          tab_size = 4;
          preferred_line_length = 100;
        };
      };

      # ── nixd ──────────────────────────────────────────────────────
      # 这些 expr 必须随主机名/用户名变化，所以放在 Nix 侧（静态文件做不到）。
      #   nixpkgs          → 包补全 / inlay hint
      #   options.nixos    → 系统侧选项
      #   options.home-manager → HM 是独立模式，不在 nixosConfigurations 里
      lsp.nixd.settings = {
        nixpkgs.expr = "import (builtins.getFlake \"${config.my.repoDir}\").inputs.nixpkgs { }";
        options.nixos.expr = "(builtins.getFlake \"${config.my.repoDir}\").nixosConfigurations.${hostName}.options";
        options.home-manager.expr = "(builtins.getFlake \"${config.my.repoDir}\").homeConfigurations.\"${config.home.username}@${hostName}\".options";
        diagnostic.suppress = [ "sema-extra-with" ]; # 抑制 with 表达式的告警
      };
    };
  };
}
