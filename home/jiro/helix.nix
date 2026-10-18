{ pkgs, lib, ... }:
{
  programs.helix = {
    enable = true;
    # 设为默认编辑器，设置 EDITOR/VISUAL 环境变量
    # 也可以外层设置home.sessionVariables
    # defaultEditor = true;

    settings = {
      theme = "autumn_night_transparent"; # 主题名称
      editor = {
        default-yank-register = "+";
        line-number = "relative"; # 相对行号
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        lsp.display-messages = true; # 显示 LSP 消息
        bufferline = "multiple"; # 显示缓冲区标签
        # mouse = false; # 禁用鼠标
        scrolloff = 18; # 滚动时保持的垂直边距
        soft-wrap.enable = true; # 启用软换行
      };
    };
    # ... 其他设置 ...
    languages = {
      # 定义语言服务器，并可根据需要添加参数
      language-server = {
        rust-analyzer = {
          command = "rust-analyzer";
        };
        nixd = {
          # Nix LSP
          command = "nixd";
        };
        tinymist = {
          command = "tinymist";
        };
      };

      # 为特定语言启用服务器和格式化器
      language = [
        {
          name = "nix";
          auto-format = true; # 保存时自动格式化
          formatter = {
            command = lib.getExe pkgs.nixfmt; # 使用 Nix 包提供的格式化器
          };
          language-servers = [ "nixd" ];
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ]; # 指定使用的服务器
        }
        {
          name = "typst";
          auto-format = true;
          language-servers = [ "tinymist" ]; # 指定使用的服务器
        }
      ];
    };
  };
}
