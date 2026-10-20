{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    # 不写 package:默认就是 pkgs.zed-editor,版本由 overlays/unstable.nix 决定
    extensions = [
      "nix"
      "catppuccin" # theme
      "typst" # Typst 语言支持 + 预览
      "toml"
    ];

    userSettings = {
      theme = {
        mode = "dark";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
      buffer_font_family = "Maple Mono NF CN";
      buffer_font_size = 15;
      agent_buffer_font_size = 15;
      # vim_mode = true;
      helix_mode = true;
      format_on_save = "on";
      # 控制 CLI / 双击行为
      cli_default_open_behavior = "new_window";
      # 控制 UI / 外部打开请求行为
      default_open_behavior = "new_window";

      terminal = {
        shell = {
          program = "${pkgs.fish}/bin/fish"; # 显式指定 Nix store 路径，避免 PATH 问题
          # args = [ "-l" ];                          # 如需登录 shell
        };
      };

      # ── 补全行为 ───────────────────────────────────────────────
      # nixd 启动后要先求值 nixpkgs 与 NixOS options，首次可能需要几秒；
      # 如果让它无限等待，补全菜单会一直不出现。
      completions = {
        lsp = true;
        # LSP 超过 3 秒没响应就先不显示它，避免整张菜单被卡住
        lsp_fetch_timeout_ms = 3000;
        # enabled：把当前文件里出现过的单词也混进补全列表
        # （默认 fallback 只在 LSP 出错/超时时才用）
        # words = "enabled";
        # words_min_length = 2;
      };
      # 启用 Zed 自带的 AI 编辑预测（Zeta）
      "edit_prediction_provider" = "zed";
      languages = {
        "Nix" = {
          language_servers = [
            "nixd"
            "!nil"
          ]; # 只使用 nixd
          format_on_save = "on";
          formatter = {
            external = {
              command = "nixfmt";
            };
          };
        };
        "Markdown" = {
          format_on_save = "on";
          markdown_preview = {
            open_markdown_files_in_preview = true;
          };
        };
        "Rust" = {
          language_servers = [ "rust-analyzer" ];
          format_on_save = "on";
          # rust-analyzer 内部调用 rustfmt，无需额外 formatter
          tab_size = 4;
        };
        # ── Python ───────────────────────────────
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

      # 如果你需要，也可以在这里配置 nixd 的专属选项
      lsp = {
        nixd = {
          settings = {
            # 让 nixd 知道你的 flake:nixpkgs 用于包补全/inlay hint
            nixpkgs.expr = "import (builtins.getFlake \"/home/jiro/nixos-config\").inputs.nixpkgs { }";
            # ── 选项补全 ──────────────────────────────────────────────
            # NixOS 系统侧选项（modules/system、hosts 等）
            options.nixos.expr = "(builtins.getFlake \"/home/jiro/nixos-config\").nixosConfigurations.XPS9560.options";
            # 独立模式 Home Manager 的选项（home/jiro 等）。
            # 你的 HM 不是作为 NixOS 模块加载的，所以它不在
            # nixosConfigurations...options 里，必须单独写这一条。
            options.home-manager.expr = "(builtins.getFlake \"/home/jiro/nixos-config\").homeConfigurations.\"jiro@XPS9560\".options";
            diagnostic = {
              suppress = [ "sema-extra-with" ]; # 示例：抑制特定诊断
            };
          };
        };
      };

      # ====================== AI设置 =====================
      # 不自动加载 MCP server——MCP 工具定义同样占据前缀
      # context_servers = {};  # 不配即不发
      # 设置 Agent 默认使用的模型
      agent = {
        default_model = {
          provider = "openai_compatible"; # 与下方 openai_compatible 里的键名对应
          model = "glm-5.3-flash";
        };
        auto_compact = {
          enable = true;
          threshold = "60%";
        };

        # 不自动附带项目结构摘要（省得最多的单项）
        project_context = "none";
        # 不自动附带当前打开文件内容
        include_active_editor_context = false;
        # 评审只带单文件 diff
        single_file_review = true;
      };

      language_models = {
        openai_compatible = {
          "ZhipuAI" = {
            # Z.ai / GLM Coding Plan 接口
            # api_url = "https://api.z.ai/api/coding/paas/v4";
            # 若走国内智谱开放平台的普通 API Key，改用：
            api_url = "https://open.bigmodel.cn/api/paas/v4";

            available_models = [
              {
                name = "glm-5.3-flash"; # 必须与服务商模型 ID 完全一致
                display_name = "GLM-5.3-Flash";
                max_tokens = 1048576; # 按官方文档的上下文长度调整
                max_output_tokens = 32000;
                stream = true;
                reasoning_effort = "high"; # 推理深度：low high max三档
                capabilities = {
                  prompt_cache_key = true;
                  tools = true; # 启用工具调用（Agent 编辑文件、执行命令必需）
                  images = true;
                  parallel_tool_calls = true;
                  clear_thinking = false;
                };
              }
            ];
          };
        };
      };
    };

  };

}
