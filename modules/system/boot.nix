# ── 引导器:Limine ────────────────────────────────────────────────────────
#
# 从 systemd-boot 换成 Limine 的两个理由:
#   1. systemd-boot 没有字号选项,想放大菜单只能降低控制台分辨率(整屏放大);
#      Limine 直接支持 term_font_scale,只缩放字体,不动分辨率。
#   2. Limine 的启动项支持「卷资源」语法(boot(N):/…),可以直接从另一个
#      分区链式启动 Windows —— 本机的 Windows ESP 是 nvme0n1p2,
#      而 NixOS 的 ESP 是 nvme0n1p9,两者不是同一个分区。
{ pkgs, ... }:

{
  boot.loader.limine = {
    enable = true;

    # 菜单里最多列出多少代。作用等同原来的 systemd-boot.configurationLimit。
    # 只影响菜单显示,不影响 GC;太多会让菜单很长、ESP 里也堆很多内核。
    maxGenerations = 10;

    # ── 菜单外观(Catppuccin Mocha)──────────────────────────────
    #
    # 颜色全部用 RRGGBB / TTRRGGBB:
    #   · 前景/背景/调色板里的颜色都是单色
    #   · 背景多出来的 TT 是【透明度】:00 = 完全不透明,FF = 全透
    style = {
      # 壁纸:开机时铺满屏幕。可以写多张,limine 每次随机选一张。
      wallpapers = [ ../../share/wallpapers/wpBootloader1.png ];
      wallpaperStyle = "stretched";

      interface = {
        # 顶部标题。不写就是只有菜单,比较空。
        branding = "NixOS";
        brandingColor = "cba6f7"; # mauve
        # 按键提示:平时很淡,倒计时数字用蓝色跳出来
        helpColor = "6c7086"; # overlay0
        helpColorBright = "89b4fa"; # blue
      };

      graphicalTerminal = {
        font = {
          # 1x1 = 原始大小;2x2 = 宽高各放大一倍。
          # 嫌大改 2x1 / 1x2,嫌小可以用 3x3(上限 8)。
          scale = "2x2";
          # 字间距(像素)。放大后留 2px 会松一点、更好读。
          spacing = 2;
        };

        # Catppuccin Mocha:普通 8 色 + 亮色 8 色
        # 顺序固定:black red green yellow blue magenta cyan white
        palette = "45475a;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;bac2de";
        brightPalette = "585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;a6adc8";

        # 正文颜色:text / rosewater
        foreground = "cdd6f4";
        brightForeground = "f5e0dc";
      };
    };

    # ── 额外启动项(拼在 limine.conf 末尾)──────────────────────────
    #
    # Windows 装在 nvme0n1p2 的 ESP 上。limine 的路径语法是:
    #   resource(argument):/path
    #     boot()   → 配置文件所在分区 = NixOS 的 ESP(nvme0n1p9)
    #     boot(2)  → 引导盘的第 2 个分区 = nvme0n1p2(1-based,和 lsblk 的 pX 一致)
    # 所以这里必须写 boot(2),不能写默认的 boot():。
    #
    # 若以后分区重新编号,可把 boot(2) 换成 guid(<nvme0n1p2 的 PARTUUID>):/…,
    # 查法:sudo blkid -s PARTUUID -o value /dev/nvme0n1p2
    extraEntries = ''
      /Microsoft Windows
        protocol: efi
        path: guid(8085de80-454c-4fc1-babb-e9ab8e45c6d6):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  # ── 内核 ────────────────────────────────────────────────────────────
  # 不写这一行时,内核由 nixpkgs 的 stable 系列决定(本仓库曾求值为 6.18.57 LTS)。
  # 想用更新的内核,就固定一个「系列」:
  #   linuxPackages_7_2 / _7_3 → 固定 7.2.x / 7.3.x
  #   linuxPackages_latest     → 跟着 nixpkgs 跳到最新主版本(不推荐:会悄悄跨大版本)
  # 固定系列的好处:只在 7.3.x 内升级补丁;等这个系列 EOL、nixpkgs 把它删掉时,
  # 求值会直接报错提醒你换一个,而不是某次更新后内核突然变了个大版本。
  #
  # ⚠️ 换内核必须验证独显:本机 GTX 1050 是 Pascal,只能用 nvidia legacy_580,
  #    已实测 580.178.04 能针对 7.3 编译出内核模块。如果 nvidia 模块构建失败,
  #    就退回上一个能用的系列(比如 6.18),否则会卡在构建或开机加载不了驱动。
  boot.kernelPackages = pkgs.linuxPackages_7_3;

  boot.loader.efi.canTouchEfiVariables = true; # 允许安装器写 EFI 启动项

}
