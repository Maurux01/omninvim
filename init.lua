if vim.fn.has("nvim-0.11.5") == 0 then
  error("simplevim requiere Neovim 0.11.5 o superior")
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  if vim.fn.executable("git") == 0 then
    error("Git es necesario para instalar lazy.nvim")
  end
  local output = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
  if vim.v.shell_error ~= 0 then
    error("No se pudo instalar lazy.nvim:\n" .. output)
  end
end
vim.opt.rtp:prepend(lazypath)

require("core.options")
require("core.keymaps")

require("lazy").setup("plugins")
