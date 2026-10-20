# modules/users/jiro.nix —— 用户 jiro 的“系统侧”定义(账号、用户组、密码)。
# 用户的个人配置(dotfiles、用户软件)在 home/jiro/,由独立模式的 home-manager 管。
{ ... }: # 用不到的参数(config/lib/pkgs)可以省略

{
  users.users.jiro = {
    isNormalUser = true;
    # wheel:可以 sudo;networkmanager:能改网络设置
    # video:让 brightnessctl 能调屏幕亮度(配合 modules/desktop/niri.nix 里的 udev 规则)
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];

    # ⚠️ initialPassword 只在“首次创建用户”时生效,且是明文。
    # 装完机后建议改成:用 `mkpasswd` 生成哈希,写进一个不进仓库的文件,
    # 然后启用下面这行、删掉 initialPassword。
    initialPassword = "0000";
    # hashedPasswordFile = "/run/secrets/jiro-password";
  };
}
