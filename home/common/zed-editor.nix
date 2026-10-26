# Zed。版本由 overlays/unstable.nix 决定(不写 package 即 pkgs.zed-editor)。
#
# 设置分两部分：
#   1. 本文件的 userSettings：结构稳定、需要注释或按机器/用户插值的部分
#      （语言、LSP、终端、扩展、agent/AI 成本项）。
#      每次 `nh home switch` 由 HM 合并进 settings.json。
#   2. dotfiles/zed/settings.json：主题、字体等纯外观的常改项。
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
#
# ── language_models.*（仍在 settings.json，JSON 里不能写注释）──
# agent.* 已移到下方 userSettings.agent，成本相关说明见那里的注释。
# 这里只记留在 JSON 里的模型声明：
#   - glm-4.7-flash.max_output_tokens = 30000：留够写长文件，同时给跑飞设上限。
#   - available_models 保留 prompt_cache_key = true：智谱缓存命中 0.23 元/M，
#     未命中 0.8 元/M（GLM-5.3-Flash，2026-10 价格）。
#
# 另：已删的两个失效键（1.25 的 AgentSettings 里不存在，写了也没效果）：
#   project_context / include_active_editor_context
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

  # Agent 工具收到的路径是「项目根目录名/相对路径」（如 nixos-config/docs/x），
  # 不是绝对路径，所以工具权限的 pattern 也只能用 basename 拼。
  # 取 basename 而不是写死 nixos-config：改仓库目录名时这里自动跟随。
  repoDirName = builtins.baseNameOf (lib.removeSuffix "/" config.my.repoDir);
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

      # ── Agent / AI ────────────────────────────────────────────────
      # 放 Nix 侧：这几个键很少变，而且需要注释（settings.json 每次 switch
      # 会被重写，注释留不住）。
      #
      # 成本要点（2026-10 实测）：
      # - threshold 是「已用 token」绝对值。167000 ≈ GLM-4.7-Flash 的可用输入
      #   （200000 − max_output_tokens 30000 = 170000）留 3k 余量。
      #   写成百分比时 Zed 按主模型可用窗口换算（1M − 384K = 616K，"18%"
      #   实测只有约 11 万），和想压到 16.7 万不是一回事。
      # - compaction / thread_summary / commit_message 的 provider 必须是
      #   language_models.openai_compatible 下的键名（这里是 ZhipuAI）。
      #   写 openai_compatible 时查不到 provider，会静默回落主模型
      #   （telemetry 实测 compaction_model = deepseek/deepseek-flash）。
      # 使用 `grep -a '"Agent Compaction Completed"' ~/.local/share/zed/logs/telemetry.log`
      # 确认上下文压缩到底使用的什么模型
      # - 压缩请求要把整个线程一起发出去，所以 threshold 不能超过压缩模型的
      #   可用输入；想放大窗口得先换 compaction_model。
      agent = {
        default_model = {
          provider = "deepseek";
          model = "deepseek-flash";
          effort = "high";
          enable_thinking = true;
        };
        auto_compact = {
          enabled = true; # 键名是 enabled；写成 enable 会被静默忽略
          threshold = 167000;
        };
        # glm-4.7-flash虽然免费，但是总是访问量过大，以下三个要换其他便宜的模型
        # compaction_model = {
        #   provider = "ZhipuAI";
        #   model = "glm-4.7-flash";
        # };
        # thread_summary_model = {
        #   provider = "ZhipuAI";
        #   model = "glm-4.7-flash";
        # };
        # commit_message_model = {
        #   provider = "ZhipuAI";
        #   model = "glm-4.7-flash";
        # };
        default_profile = "write";
        single_file_review = true;
        show_turn_stats = true; # 显示每轮生成耗时（默认 false）
        tool_permissions.tools = {
          # 只放行 docs/ 下的路径；regex 里要转义 basename（目录名可能含元字符）
          delete_path.always_allow = [
            { pattern = "^${lib.escapeRegex repoDirName}/docs/"; }
          ];
          terminal.default = "allow";
          fetch.always_allow = [
            { pattern = "^https?://raw\\.githubusercontent\\.com"; }
            { pattern = "^https?://api\\.github\\.com"; }
            { pattern = "^https?://wiki\\.nixos\\.org"; }
          ];
        };
      };

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
          # 1.25 的 formatter 只接受 Formatter 枚举的变体：
          #   auto / none / prettier / external / code_action / language_server。
          # 旧写法 formatter = [{ code_actions = {…}; } …] 里的 code_actions
          # 不是合法变体，会让整个 settings 解析报
          # "data did not match any variant of untagged enum FormatterList"，
          # 该语言静默退回默认格式化器。
          # 正确做法是两阶段：先跑 code_actions_on_format，再用 ruff 格式化。
          # ⚠️ 动作名里的点号必须写在同一个带引号的属性名里，
          # 否则 Nix 会解析成嵌套对象。
          code_actions_on_format = {
            "source.fixAll.ruff" = true;
            "source.organizeImports.ruff" = true;
          };
          formatter.language_server.name = "ruff";
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
