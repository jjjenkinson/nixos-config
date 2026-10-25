# ════════════════════════════════════════════════════════════════════════
# 整份配置的入口。它只做三件事:
#   1. inputs              声明依赖(nixpkgs、home-manager)
#   2. nixosConfigurations 系统配置 → `nh os switch`
#   3. homeConfigurations  用户配置 → `nh home switch`
# 具体内容都在 hosts/、modules/、home/ 里,这里只负责组装。
# ════════════════════════════════════════════════════════════════════════
{
  description = "NixOS + Home Manager 配置(flake)";

  inputs = {
    # Stable 通道：指向 nixos-26.05 分支
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-26.05&shallow=1";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # unstable 源。flake 规范要求 input 写在这里,
    # 但「用不用、用哪些包」全部由 overlays/unstable.nix 决定;
    # 不使用 unstable 时只需注释掉下面的 overlay import,这个 input 留着不影响构建。
    #
    # Unstable 通道：指向 nixos-unstable 分支
    nixpkgs-unstable.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      # url = "github:nix-community/home-manager/release-26.05";

      url = "git+https://github.com/nix-community/home-manager.git?ref=release-26.05&shallow=1"; # 让 home-manager 复用同一个 nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    # 注:unstable 源不在这里声明。它只给 overlays/unstable.nix 用,
    # 所以通过 inputs.nixpkgs-unstable 访问,flake.nix 本体不依赖它。
    let
      system = "x86_64-linux";

      # 系统和用户共用的 nixpkgs 配置(唯一来源)。
      # 以后加 allowBroken / cudaSupport 也只改这里,两边不会漂移。
      pkgsConfig = {
        allowUnfree = true; # 允许非自由软件(google-chrome 等)
      };

      # ── overlays:所有 overlay 的唯一入口 ───────────────────────────
      # 当前启用了 unstable;不需要时把下面这段 import 整段注释掉即可(overlay 列表为空),
      # 系统会回到纯 stable(安装文件不用改)。名单在 overlays/unstable.nix。
      overlays = [
        (import ./overlays/unstable.nix {
          inherit (inputs) nixpkgs nixpkgs-unstable;
          inherit system;
          # unstable 实例也用同一份 config,否则 unfree 包(wechat)求值时报错
          config = pkgsConfig;
        })
      ];

      # 构造 pkgs:系统和 home 共用这一份。
      pkgs = import nixpkgs {
        inherit system overlays;
        config = pkgsConfig;
      };

      # ── 主机表:新增/改名机器只改这里 ────────────────────────────────
      # 键 = 主机名(= hosts/<主机名>/ 目录名 = nixosConfigurations 的属性名)
      # user = 登录账号(= home/<用户名>/ 目录名)
      #
      # 两个名字各自只有「一处权威定义」:
      #   主机名 → 本表的键,经 specialArgs.hostName 传给 hosts/<主机名>/
      #   用户名 → 本表的 user,经 specialArgs.userName 同时传给系统侧和 home 侧
      # 所以新增主机时,除了本表,不需要在任何 .nix 文件里再抄一遍用户名。
      #
      # git 身份、默认编辑器等个人设置不在这里,而在 home/<用户>/default.nix 里,
      # 这样 flake 只负责「哪台机器用哪个账号」。
      hosts = {
        XPS9560 = {
          user = "jiro";
        };
        HHHH = {
          user = "XXXX"; # ← 占位,换成真实用户名
        };
      };

      # ── 所有主机共用的模块层 ──────────────────────────────────────────
      # 放在这里统一注入,hosts/<主机名>/default.nix 就只需要关心
      # 「这台机器的硬件和外设」,不用再抄一遍四行 ../../modules/...。
      # 某台机器不想要其中某一层时,再在它的 default.nix 里用 disabledModules
      # 或选项开关处理(例如桌面环境用 my.desktop.niri / plasma / mango).enable)。
      commonModules = [
        ./modules/system # 系统基础
        ./modules/packages # 系统级软件包
        ./modules/desktop # 桌面、字体、输入法
        ./modules/users # 用户账号
      ];
    in
    {
      # ── 系统配置 ──────────────────────────────────────────────────────
      # mapAttrs 把主机表展开成:
      #   nixosConfigurations.XPS9560 / nixosConfigurations.HHHH
      # 每台机器一个 nixosSystem,但共享同一份 pkgsConfig / overlays / commonModules。
      nixosConfigurations = nixpkgs.lib.mapAttrs (
        name: h:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            hostName = name;
            userName = h.user;
          };
          modules = [
            ./hosts/${name}
          ]
          ++ commonModules
          ++ [
            {
              nixpkgs.config = pkgsConfig;
              nixpkgs.overlays = overlays;
            }
          ];
        }
      ) hosts;

      # ── 用户配置(独立模式 home-manager,不需要 root)──────────────────
      # mapAttrs' 把主机表展开成:
      #   homeConfigurations."jiro@XPS9560" / homeConfigurations."XXXX@HHHH"
      # 每个用户 = home/common(共用) + home/<user>(个人目录)。
      # 用户名 / 主机名通过 extraSpecialArgs 注入,模块里直接当参数用。
      homeConfigurations = nixpkgs.lib.mapAttrs' (
        name: h:
        nixpkgs.lib.nameValuePair "${h.user}@${name}" (
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs;
              hostName = name;
              userName = h.user;
            };
            modules = [
              ./home/common
              ./home/${h.user}
            ];
          }
        )
      ) hosts;

      # 让 `nix fmt` 使用 nixfmt 格式化本仓库
      formatter.${system} = pkgs.nixfmt;
    };
}
