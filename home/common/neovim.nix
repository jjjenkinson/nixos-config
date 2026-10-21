{ ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    waylandSupport = true; # 系统剪贴板走 wl-clipboard

    initLua = ''
      vim.opt.clipboard = "unnamedplus"
      vim.opt.number = true
      vim.opt.relativenumber = true
    '';
  };
}
