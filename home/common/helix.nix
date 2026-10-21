# Helix。版本由 overlays/unstable.nix 决定(不写 package 即 pkgs.helix)。
# 设为默认编辑器由 home/common/default.nix 的 EDITOR/VISUAL 负责。
{ pkgs, lib, ... }:

{
  programs.helix = {
    enable = true;

    settings = {
      # 内置主题:catppuccin_{latte,frappe,macchiato,mocha}、autumn_night 等
      theme = "catppuccin_mocha";

      editor = {
        default-yank-register = "+"; # 与系统剪贴板共用寄存器
        line-number = "relative";
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        lsp.display-messages = true;
        bufferline = "multiple";
        scrolloff = 18;
        soft-wrap.enable = true;
      };
    };

    # 语言服务器与各语言的格式化/LSP 绑定。
    languages = {
      language-server = {
        rust-analyzer.command = "rust-analyzer";
        nixd.command = "nixd";
        tinymist.command = "tinymist";
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.nixfmt;
          language-servers = [ "nixd" ];
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ];
        }
        {
          name = "typst";
          auto-format = true;
          language-servers = [ "tinymist" ];
        }
      ];
    };
  };
}
