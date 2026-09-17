-- Desactivar netrw lo antes posible: nvim-tree lo exige antes de que
-- se cargue el runtime (si se hace dentro del config de lazy ya es tarde
-- y netrwPlugin.vim ya fue sourced).
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.fillchars = { eob = " " }
opt.cmdheight = 0
opt.mouse = "a"
opt.showmode = false
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.clipboard = "unnamedplus"
