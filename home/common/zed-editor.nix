{
  config,
  hostName,
  pkgs,
  ...
}:

let
  # 仓库的绝对路径。
  # 必须写绝对路径:flake 求值时模块位于 /nix/store/…-source,
  # 用相对路径会指到 store 里的只读副本,nixd 就会去分析那份快照。
  repo = "${config.home.homeDirectory}/nixos-config";
in
{
  programs.zed-editor = {
    enable = true;
    # 不写 package:默认就是 pkgs.zed-editor,版本由 overlays/unstable.nix 决定。
    extensions = [
      "nix"
      "catppuccin" # 主题
      "typst" # 语言支持 + 预览
      "toml"
    ];

    userSettings = {
      # ── 外观 ──────────────────────────────────────────────────────
      theme = {
        mode = "dark";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
      buffer_font_family = "Maple Mono NF CN";
      buffer_font_size = 15;
      agent_buffer_font_size = 15;
      helix_mode = true;

      # ── 行为 ──────────────────────────────────────────────────────
      format_on_save = "on";
      cli_default_open_behavior = "new_window"; # CLI 启动 / 双击
      default_open_behavior = "new_window"; # 外部打开请求

      terminal.shell.program = "${pkgs.fish}/bin/fish"; # 写 store 路径,避免 PATH 问题

      # nixd 首次求值 nixpkgs / options 可能要几秒;
      # 设上限,避免整张补全菜单一直等它。
      completions = {
        lsp = true;
        lsp_fetch_timeout_ms = 3000;
        # 想把当前文件里的单词也混进补全时可打开:
        # words = "enabled";
        # words_min_length = 2;
      };

      # Zed 自带的 AI 编辑预测(Zeta)。不登录会刷 403,不用就改成 "none"。
      "edit_prediction_provider" = "zed";

      # ── 各语言 ────────────────────────────────────────────────────
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
          tab_size = 4;
          preferred_line_length = 100;
        };
      };

      # ── nixd ──────────────────────────────────────────────────────
      # nixpkgs → 包补全 / inlay hint
      # options.nixos → 系统侧选项
      # options.home-manager → HM 是独立模式,不在 nixosConfigurations 里,要单独给
      lsp.nixd.settings = {
        nixpkgs.expr = "import (builtins.getFlake \"${repo}\").inputs.nixpkgs { }";
        options.nixos.expr = "(builtins.getFlake \"${repo}\").nixosConfigurations.${hostName}.options";
        options.home-manager.expr = "(builtins.getFlake \"${repo}\").homeConfigurations.\"${config.home.username}@${hostName}\".options";
        diagnostic.suppress = [ "sema-extra-with" ]; # 抑制 with 表达式的告警
      };

      # ── AI ────────────────────────────────────────────────────────
      # 不配置 context_servers = MCP 工具定义不会进入上下文。
      agent = {
        default_model = {
          provider = "openai_compatible"; # 与下面 language_models 的键对应
          model = "glm-5.3-flash";
        };
        auto_compact = {
          enable = true;
          threshold = "60%";
        };
        project_context = "none"; # 不自动附带项目结构摘要
        include_active_editor_context = false; # 不自动附带当前文件内容
        single_file_review = true; # 评审只带单文件 diff
      };

      language_models.openai_compatible."ZhipuAI" = {
        # Z.ai / GLM Coding Plan 用:
        #   api_url = "https://api.z.ai/api/coding/paas/v4";
        # 国内智谱开放平台的普通 API Key 用下面这个:
        api_url = "https://open.bigmodel.cn/api/paas/v4";

        available_models = [
          {
            name = "glm-5.3-flash"; # 必须与服务商模型 ID 完全一致
            display_name = "GLM-5.3-Flash";
            max_tokens = 1048576; # 按官方文档的上下文长度调整
            max_output_tokens = 32000;
            stream = true;
            reasoning_effort = "high"; # low / high / max
            capabilities = {
              prompt_cache_key = true;
              tools = true; # Agent 编辑文件、执行命令必需
              images = true;
              parallel_tool_calls = true;
              clear_thinking = false;
            };
          }
        ];
      };
    };
  };
}
