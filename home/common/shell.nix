# Shell 与终端:fish(主力)、bash(兼容)、kitty、starship、eza、代理函数。
{ ... }:

{
  # ── fish(默认 shell)────────────────────────────────────────────────
  programs.fish.enable = true;

  # ── bash(备用 / 脚本兼容)──────────────────────────────────────────
  # 必须 enable 才会生成 ~/.bashrc;只写 bashrcExtra 是不生效的。
  programs.bash.enable = true;

  # ── 终端 ────────────────────────────────────────────────────────────
  programs.kitty = {
    enable = true;

    # 让 kitty 启动 fish,并加载 fish 的 shell 集成(shell 相关快捷键等)。
    shellIntegration.enableFishIntegration = true;
    settings = {
      shell_integration = "enabled";
      shell = "fish";
    };

    font = {
      name = "Maple Mono NF CN";
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

  # ── 提示符 ──────────────────────────────────────────────────────────
  programs.starship = {
    enable = true;
    settings = {
      format = "$os$directory$git_branch$git_status$nix_shell$character";
      os.disabled = false;
      os.symbols.NixOS = "  ";
    };
  };

  # ── ls 替代 ─────────────────────────────────────────────
  programs.eza = {
    enable = true;
    icons = "auto"; # 文件类型图标(需要 Nerd Font)
    git = true; # 显示 git 状态列
    enableFishIntegration = true;
  };

  # ── 模糊查找 / 目录跳转 ─────────────────────────────────
  # yazi 自带的 fzf / zoxide 只在它的包装器 PATH 里,不会进入 shell;
  # 这里单独启用,让 shell 里也能直接用。
  programs.fzf = {
    enable = true;
    enableFishIntegration = true; # Ctrl-R 历史 / Ctrl-T 文件 / Alt-C 目录
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true; # z <关键字> 跳目录,zi 交互式
    enableBashIntegration = true;
  };

  # ── 代理 ────────────────────────────────────────────────────────────
  # 默认不导出任何代理变量。需要时手动 `proxy_on`,用完 `proxy_off`:
  # flclash 没启动时,常开的代理变量会让 git / curl / pip 一直连不存在的端口。
  # 变量只在函数体里写一份,fish 与 bash 各一个实现、内容保持一致。
  programs.bash.bashrcExtra = ''
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
