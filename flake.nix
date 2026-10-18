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
    let
      system = "x86_64-linux";

      # 系统和用户共用的 nixpkgs 配置(唯一来源)。
      # 以后加 overlay / allowBroken / cudaSupport 也只改这里,两边不会漂移。
      pkgsConfig = {
        allowUnfree = true; # 允许非自由软件(google-chrome 等)
      };

      # 用上面的配置构造 pkgs。
      # allowUnfree 这类“许可”开关不改变包本身,所以系统和 home 用的是同一批
      # store 路径,不会重复下载或构建。
      pkgs = import nixpkgs {
        inherit system;
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
            { nixpkgs.config = pkgsConfig; } # 系统侧也使用同一份 nixpkgs 配置
          ];
        };
      };

      # ── 用户配置(独立模式 home-manager,不需要 root)──────────────────
      homeConfigurations."jiro@XPS9560" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs; # 复用上面那份 pkgs(等价于原来 NixOS 模块里的 useGlobalPkgs)
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home/jiro ];
      };

      # 让 `nix fmt` 使用 nixfmt 格式化本仓库
      formatter.${system} = pkgs.nixfmt;
    };
}
