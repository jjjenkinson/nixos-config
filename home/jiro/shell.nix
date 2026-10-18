{ pkgs, ... }: {
  programs.fish.enable = true;

  programs.kitty = {
    enable = true;

    # 核心：设置 Kitty 默认启动 fish，并启用 Fish 集成以获得更好的体验
    shellIntegration.enableFishIntegration = true;
    settings = {
      # 开启 Shell 集成，自动加载 fish 的集成脚本
      shell_integration = "enabled";
      shell = "fish";
    };

    # 设置字体（可选）
    font = {
      name = "Maple Mono NF CN"; # 使用你已配置的字体
      size = 12;
    };

    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "alt+1" = "goto_tab 1";
      "alt+2" = "goto_tab 2";
      "alt+3" = "goto_tab 3";
      "alt+4" = "goto_tab 4";
      "alt+5" = "goto_tab 5";
      "alt+6" = "goto_tab 6";
      "alt+7" = "goto_tab 7";
      "alt+8" = "goto_tab 8";
      "alt+9" = "goto_tab 9";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$os$directory$git_branch$git_status$nix_shell$character";
      os.disabled = false;
      os.symbols.NixOS = "  ";
    };
  };

  programs.eza = {
    enable = true; # 由 HM 安装并生成别名(ls/ll/la...)
    icons = "auto"; # ← 文件类型图标(需要 Nerd Font)
    git = true; # 显示 git 状态列
    enableFishIntegration = true;
  };

  # 用户环境变量
  home.sessionVariables = {
    http_proxy = "http://127.0.0.1:7890";
    https_proxy = "http://127.0.0.1:7890";
    HTTP_PROXY = "http://127.0.0.1:7890";
    HTTPS_PROXY = "http://127.0.0.1:7890";
    all_proxy = "socks5://127.0.0.1:7890";
    ALL_PROXY = "socks5://127.0.0.1:7890";
    # 本地/内网不走代理，务必设置
    no_proxy = "localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.local";
    NO_PROXY = "localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.local";
  };

  programs.bash.bashrcExtra = ''
    # 上面的 proxy_on / proxy_off
    proxy_on() {
      export http_proxy="http://127.0.0.1:7890"
      export https_proxy="http://127.0.0.1:7890"
      export HTTP_PROXY=$http_proxy HTTPS_PROXY=$https_proxy
      export all_proxy="socks5://127.0.0.1:7890" ALL_PROXY=$all_proxy
      export no_proxy="localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
      export NO_PROXY=$no_proxy
      echo "proxy on: 127.0.0.1:7890"
    }
    proxy_off() {
      unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
      unset all_proxy ALL_PROXY no_proxy NO_PROXY
      echo "proxy off"
    }
  '';

  programs.fish.functions.proxy_on.body = ''
    set -gx http_proxy "http://127.0.0.1:7890"
    set -gx https_proxy "http://127.0.0.1:7890"
    set -gx HTTP_PROXY $http_proxy HTTPS_PROXY $https_proxy
    set -gx all_proxy "socks5://127.0.0.1:7890"
    set -gx ALL_PROXY $all_proxy
    set -gx no_proxy "localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
    set -gx NO_PROXY $no_proxy
    echo "proxy on: 127.0.0.1:7890"
  '';
  programs.fish.functions.proxy_off.body = ''
    set -e http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
    set -e all_proxy ALL_PROXY no_proxy NO_PROXY
    echo "proxy off"
  '';
}
