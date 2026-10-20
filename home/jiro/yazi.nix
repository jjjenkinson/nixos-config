# yazi:终端里的文件管理器(TUI)
#
# 为什么用 Home Manager 的 programs.yazi 而不是手写 xdg.configFile:
#   1. 它用 TOML 生成器产出 yazi.toml / keymap.toml,不用自己拼字符串,
#      写错键名在 nix 求值阶段就能发现类型问题
#   2. 插件用软链接装进 ~/.config/yazi/plugins/,GitHub 上手动 clone 那套可以省掉
#   3. enableFishIntegration 会生成一个 shell 函数:退出 yazi 时把当前目录同步回 fish
#
# 为什么 yazi 不放进 dotfiles/(不像 niri / noctalia):
#   yazi 没有配置热重载,改配置必须重启 yazi,软链也省不掉这一步,
#   所以直接由 Nix 生成更简单。
{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;

    # 退出 yazi 后 shell 的当前目录跟着变:`y` 进入,`:q` 出来就直接在刚才浏览的目录
    enableFishIntegration = true;
    shellWrapperName = "y";

    # 额外加进 yazi 包装器 PATH 的程序。
    # 注意:nixpkgs 的 yazi 默认已经带了 fd / ripgrep / fzf / zoxide /
    # ffmpeg / poppler / imagemagick / chafa / resvg / jq / 7zz,
    # 这里只补它没带、而插件需要的。
    extraPackages = with pkgs; [
      ouch # ouch 插件:压缩包内容预览 + 压缩
    ];

    # ── yazi.toml ────────────────────────────────────────────────
    settings = {
      mgr = {
        # 三栏宽度比例:父目录 / 当前目录 / 预览
        ratio = [
          1
          3
          4
        ];
        # natural:文件名里的数字按数值排序(2 在 10 前面)
        sort_by = "natural";
        sort_dir_first = true; # 目录排在文件前面
        linemode = "size"; # 列表右侧默认显示文件大小
        show_hidden = false; # 是否显示隐藏文件,随时可按 `.` 切换
        show_symlink = true; # 软链后面显示 -> 目标
      };

      preview = {
        # 图片/视频预览的最大解码尺寸,超过就缩小,省内存
        max_width = 1000;
        max_height = 1000;
        image_filter = "lanczos3"; # 图片缩放算法,比默认更清晰一点
      };

      # 压缩包不再用内置预览器,改用 ouch 插件(能看到包内目录树)
      plugin.prepend_previewers = [
        {
          mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
          run = "ouch";
        }
      ];

      # git 插件不是「按键触发」的插件,而是一个后台 fetcher:
      # 必须在这里登记,它才会对每个文件跑 `git status` 并把结果交给列表渲染。
      # 少了这一段,插件装上了也什么都不会显示。
      # 两条规则分别覆盖普通文件(*)和目录(*/),目录上才能看到聚合后的状态。
      # 注意:不要写 `id` 字段 —— yazi 26.x 里它是内部字段(serde skip),
      # 由 url/run 自动生成,手写反而会导致配置解析失败。
      plugin.prepend_fetchers = [
        {
          url = "*";
          run = "git";
          group = "git";
        }
        {
          url = "*/";
          run = "git";
          group = "git";
        }
      ];
    };

    # ── keymap.toml ──────────────────────────────────────────────
    # 用 prepend_keymap:只覆盖下面几个键,其余全部沿用 yazi 自带键位
    # (h/j/k/l、空格选中、y/x 复制剪切、d 删除、a 新建、r 重命名……)
    keymap.mgr.prepend_keymap = [
      {
        on = "<Enter>";
        run = "plugin smart-enter";
        desc = "进入目录 / 打开文件(不用区分 h 和 l)";
      }
      {
        on = "C";
        run = "plugin ouch";
        desc = "把选中文件压缩成压缩包";
      }
      {
        on = "M";
        run = "plugin chmod";
        desc = "修改选中文件的权限";
      }
    ];

    # ── 插件 ─────────────────────────────────────────────────────
    # setup = true 的插件,HM 会在 init.lua 里自动补一行
    # require("<名字>"):setup()
    plugins = {
      # 回车在目录上进入、在文件上用默认程序打开
      smart-enter = pkgs.yaziPlugins.smart-enter;

      # 给整个界面加一圈边框(纯外观)
      full-border = {
        package = pkgs.yaziPlugins.full-border;
        setup = true;
      };

      # 文件列表里显示 git 状态标记(? 新增 / M 修改 / D 删除)
      git = {
        package = pkgs.yaziPlugins.git;
        setup = true;
      };

      chmod = pkgs.yaziPlugins.chmod;
      ouch = pkgs.yaziPlugins.ouch;
    };
  };
}
