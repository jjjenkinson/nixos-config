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
        "seat" # lemurs 启的 Wayland 会话需要(nixpkgs tests/lemurs 同样要求)
      ];
      description = "附加组;wheel = 可以 sudo,seat = 用 seatd 拿显卡/输入设备";
    };
  };

  config.users.users.${cfg.name} = {
    isNormalUser = true;
    inherit (cfg) extraGroups;
  };
}
