{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    # defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    waylandSupport = true;

    initLua = ''
      -- nvim的lua配置
      vim.opt.clipboard = "unnamedplus"
      vim.opt.number = true
      vim.opt.relativenumber = true
    '';
  };
}
