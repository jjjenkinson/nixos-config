# Shell 与终端:fish(主力)、bash(兼容)、kitty、starship、eza、代理函数。
{ lib, ... }:

{
  # ── fish(默认 shell)────────────────────────────────────────────────
  programs.fish = {
    enable = true;

    # 让【终端里的命令】用英文消息:nix / gcc / ls 之类切到 en_US。
    # 只影响本 shell 启动的进程;由 niri / fuzzel 启动的 GUI 不受影响,
    # 仍然是 LANG=zh_CN(中文菜单),原因见 modules/system/locale.nix。
    #
    # ⚠️ 必须写在 interactiveShellInit,不能写 shellInit:
    #   shellInit 每次启动 fish 都会执行(含非交互),而 niri-session 会先 exec
    #   一个登录 shell 再 exec niri,非交互导出的变量会顺着 exec 进入整个图形
    #   会话,noctalia / Chrome 的菜单就会跟着变英文。
    #   interactiveShellInit 会被包进 `status is-interactive` 判断,只在终端里生效。
    #
    # ⚠️ 变量名是 LC_MESSAGES(复数),写成 LC_MESSAGE 不会报错也不会生效。
    interactiveShellInit = "set -gx LC_MESSAGES en_US.UTF-8";
  };
  # ── bash(备用 / 脚本兼容)──────────────────────────────────────────
  # 必须 enable 才会生成 ~/.bashrc;只写 bashrcExtra 是不生效的。
  programs.bash = {
    enable = true;

    # 终端里的命令用英文消息(同 fish,说明见 modules/system/locale.nix)。
    #
    # 这里必须是 initExtra,不能塞进 bashrcExtra:
    #   HM 生成的 ~/.bashrc 顺序是 bashrcExtra → `[[ $- == *i* ]] || return`
    #   → initExtra。所以 bashrcExtra 在非交互 shell 里也会执行,而
    #   initExtra 只有交互式 shell 才执行。放错位置会经 niri-session 污染 GUI。
    initExtra = "export LC_MESSAGES=en_US.UTF-8";
  };

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
    enableFishIntegration = true; # 关键：让 Fish 使用 Starship
    enableBashIntegration = true;
    settings = {
      # 三行:
      #   1. 整行分隔线：两段 $fill 各填一半，上一条命令的耗时夹在中间 → 视觉居中
      #   2. 信息行(os / 目录 / git / nix shell)
      #   3. 输入行(character)
      #
      # 为什么写两个 $fill：starship 没有「居中」这种模块，但同一行里的多个 $fill
      # 会把剩余宽度平分（实测 50 列宽、中间是「5s」时左右各 23 个 ─）。
      # 耗时未到 min_time 时中间是空的，两段 fill 直接接上，仍是一条连续整线。
      # format = "$fill$cmd_duration$fill$line_break$os$directory$git_branch$git_status$nix_shell$line_break$character";
      format = lib.concatStrings [
        "$fill$cmd_duration$fill$line_break$line_break"
        "$os$directory$git_branch$git_status$nix_shell$character"
      ];
      os.disabled = false;
      os.symbols.NixOS = "  ";

      # fill 行上只能放 fill 和夹在中间的耗时:fill 只填「当前行剩下的宽度」,
      # 后面再跟其他模块就会被挤到行尾之外。
      # 注意 $fill 后面只能接 $ 开头的模块名;接普通文字要写成 ${line_break} 或加分隔符,
      # 否则 starship 会把 "fillfoo" 当成一个模块名。
      #
      # 默认样式是 bold black,在深色背景(如 Catppuccin Mocha)上几乎看不见;
      # 换成 overlay0 灰。符号用制表符横线 ─ 而不是 -:
      # 等宽字体里的 - 两侧带留白,铺满会变成一串短横;─ 能连成一条整线。
      fill = {
        symbol = "─";
        style = "fg:#6c7086";
      };

      # 上一条命令的耗时，夹在两段 fill 中间（见上面 format 的说明）。
      cmd_duration = {
        # 只报耗时不短于 2 秒的命令，短命令不打扰
        min_time = 2000;
        # false → 粗粒度（1s / 1m5s）；true → 1234ms / 1s234ms
        show_milliseconds = false;
        # 两侧各留一个空格，免得和 ─ 贴在一起
        format = " $duration ";
        style = "fg:#6c7086"; # 同分隔线同色，不抢眼
      };
    };
  };

  # ── ls 替代 ─────────────────────────────────────────────
  programs.eza = {
    enable = true;
    icons = "auto"; # 文件类型图标(需要 Nerd Font)
    git = true; # 显示 git 状态列
    enableFishIntegration = true;
    enableBashIntegration = true;
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
  # 注意:bashrcExtra 在非交互 shell 里也会执行,所以这里只放函数定义
  # (定义函数不改变环境),LC_MESSAGES 放在上面的 initExtra 里。
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
