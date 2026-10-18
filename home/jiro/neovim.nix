{ ... }: {
  programs.neovim = {
    enable = true;
    # defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    initLua = ''
      -- nvim的lua配置
      vim.opt.clipboard = "unnameplus"
      vim.opt.number = true
    '';
  };
}
