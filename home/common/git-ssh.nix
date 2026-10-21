# Git 提交身份 + GitHub SSH。
#
# 提交身份不写在 flake.nix 里,而是由 home/users/<用户名>.nix 提供:
#   my.git.userName / my.git.userEmail
# 这样 flake.nix 只负责「哪台机器用哪个账号」,个人身份留在用户自己的配置里。
{ config, lib, ... }:

let
  cfg = config.my.git;
in
{
  options.my.git = {
    userName = lib.mkOption {
      type = lib.types.str;
      description = "git 提交者姓名(programs.git.settings.user.name)";
    };

    userEmail = lib.mkOption {
      type = lib.types.str;
      description = "git 提交邮箱;需与 GitHub 账户邮箱一致,提交才会关联到账号";
    };
  };

  config = {
    # ── SSH(仅 github.com)────────────────────────────────────────────
    # enableDefaultConfig = false:只保留这里写的内容,不会混入默认 Host *。
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings."github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = "yes"; # 只用这一把 key,避免 agent 试错
        ControlMaster = "auto"; # 连接复用
        ControlPath = "~/.ssh/sockets/%r@%h-%p";
        ControlPersist = "600";
      };
    };

    # OpenSSH 不会创建 ControlPath 的父目录;缺了它 ControlMaster 会静默降级。
    # 用 activation 而不是 home.file,是为了保证目录权限是 700。
    home.activation.createSshSocketsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "$HOME/.ssh/sockets"
      run chmod 700 "$HOME/.ssh/sockets"
    '';

    # ── Git ───────────────────────────────────────────────────────────
    programs.git = {
      enable = true;
      settings = {
        user.name = cfg.userName;
        user.email = cfg.userEmail;
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
      };
    };
  };
}
