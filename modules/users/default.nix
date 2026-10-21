# 这台机器的主用户(账号 + 附加组)。
# 用户名由每台主机的 hosts/*/default.nix 指定,不再写死。
{ config, lib, ... }:

let
  cfg = config.my.user;
in
{
  options.my.user = {
    name = lib.mkOption {
      type = lib.types.str;
      example = "XXXX";
      description = "主用户名(唯一登录账号)";
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "wheel"
        "networkmanager"
        "video"
      ];
      description = "附加组;wheel = 可以 sudo";
    };
  };

  config.users.users.${cfg.name} = {
    isNormalUser = true;
    inherit (cfg) extraGroups;
  };
}
