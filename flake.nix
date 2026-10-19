# ════════════════════════════════════════════════════════════════════════
# 整份配置的入口。它只做三件事:
#   1. inputs               声明依赖(nixpkgs、home-manager)
#   2. nixosConfigurations  “系统”配置  → sudo nixos-rebuild switch --flake .#XPS9560
#   3. homeConfigurations   “用户”配置  → home-manager switch --flake .#jiro@XPS9560
# 使用了nh和指定了flake入口，所以2、3两步可以分别改为 nh os swotch 和 nh home ssswitch
# 具体内容都在 hosts/ 与 modules/、home/ 里,这里只负责组装。
# ════════════════════════════════════════════════════════════════════════
{
  description = "NixOS + Home Manager 配置(flake)";

  inputs = {
    # 系统软件源:用清华镜像加速。想换回官方源:注释上面、解开下面。
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-26.05&shallow=1";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # unstable 源。flake 规范要求 input 声明写在这里,
    # 但“用不用、用哪些包”全部由 overlays/unstable.nix 决定。
    # 不使用 unstable 时,只需注释 flake.nix 里的 overlay import;
    # 这个 input 留着也不影响构建结果。
    nixpkgs-unstable = {
      url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
      # 不用镜像就写:url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      # follows:让 home-manager 复用同一个 nixpkgs,避免出现两份 nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
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
      # 当前启用了 unstable;不需要时把下面这段 import 整段注释掉即可(也就是overlay列表为空)
      # 系统会回到纯 stable(安装文件不用改)。名单在 overlays/unstable.nix。
      overlays = [
        (import ./overlays/unstable.nix {
          inherit (inputs) nixpkgs nixpkgs-unstable;
          inherit system;
          config = pkgsConfig;
        })
      ];

      # 构造 pkgs:系统和 home 共用这一份。
      pkgs = import nixpkgs {
        inherit system overlays;
        config = pkgsConfig;
      };
    in
    {
      # ── 系统配置 ──────────────────────────────────────────────────────
      nixosConfigurations = {
        XPS9560 = nixpkgs.lib.nixosSystem {
          inherit system;
          # specialArgs:把 flake 的 inputs 传给所有 NixOS 模块(模块里可用 inputs.xxx)
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/XPS9560 # 这台机器:硬件 + 要启用哪些模块组
            {
              # 系统侧也使用同一份 nixpkgs 配置与 overlay 列表,
              # 这样系统模块里写 pkgs.xxx 会得到和 home 一致的版本。
              nixpkgs.config = pkgsConfig;
              nixpkgs.overlays = overlays;
            }
          ];
        };
      };

      # ── 用户配置(独立模式 home-manager,不需要 root)──────────────────
      homeConfigurations."jiro@XPS9560" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs; # 复用上面那份 pkgs(等价于原来 NixOS 模块里的 useGlobalPkgs)
        extraSpecialArgs = {
          inherit inputs; # unstable 包已由 overlay 接管,模块里统一写 pkgs.xxx
        };
        modules = [ ./home/jiro ];
      };

      # 让 `nix fmt` 使用 nixfmt 格式化本仓库
      formatter.${system} = pkgs.nixfmt;
    };
}
