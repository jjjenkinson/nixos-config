{ config, pkgs, ... }:

{
  # 1. 启用并管理 SSH 客户端配置
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # 使用新式 settings 语法（Home Manager 26.05+）
    settings = {
      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = "yes"; # 只使用指定的密钥，避免 Agent 尝试其他密钥
        # 可选：连接复用，加速后续操作
        ControlMaster = "auto";
        ControlPath = "~/.ssh/sockets/%r@%h-%p";
        ControlPersist = "600";
      };
    };
  };

  # 2. 启用 SSH Agent 作为 systemd 用户服务
  # 注意：Home Manager 中选项是 services.ssh-agent.enable，而非 programs.ssh.startAgent
  services.ssh-agent.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "jiro";
      user.email = "chjxg3@163.com"; # 必须与 GitHub 账户邮箱一致，以关联贡献
      init.defaultBranch = "main";
      push.autoSetupRemote = true; # 推送时自动建立追踪关系
      pull.rebase = true;
    };
  };
}
