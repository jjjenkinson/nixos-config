# 用户 jiro 的「系统侧」定义:账号与用户组。
# 个人环境(dotfiles、用户软件)在 home/jiro/,由独立模式的 home-manager 管。
{ ... }:

{
  users.users.jiro = {
    isNormalUser = true;
    # wheel           → 可以 sudo
    # networkmanager  → 能改网络设置
    # video           → brightnessctl 能调亮度(配合 modules/desktop/niri.nix 的 udev 规则)
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];

    # 这里不声明密码。
    # initialPassword 只在「首次创建用户」时生效,之后 rebuild 不会改密码;
    # 把明文放在仓库里既没用又会误导。
    # 现在改密码用 `passwd`;要声明式管理就换成 hashedPasswordFile,
    # 哈希文件放在仓库之外(如 /run/secrets/jiro-password)。
  };
}
