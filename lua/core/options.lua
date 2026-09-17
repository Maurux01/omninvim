-- Desactivar netrw lo antes posible: nvim-tree lo exige antes de que
-- se cargue el runtime (si se hace dentro del config de lazy ya es tarde
-- y netrwPlugin.vim ya fue sourced).
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.number = true
opt.relativenumber = false
-- Caracteres visibles para las divisiones verticales y horizontales.
-- Sin esto Neovim usa espacios o el theme transparente los deja invisibles.
opt.fillchars = {
  eob = " ",
  vert = "│",
  vertleft = "┤",
  vertright = "├",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  verthoriz = "┼",
}
-- Cada split horizontal conserva su propia statusline -> se ve la división.
opt.laststatus = 2
opt.splitbelow = true
opt.splitright = true
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

-- Los themes con fondo transparente (catppuccin, tokyonight, etc.)
-- dejan WinSeparator del mismo color que el fondo -> splits invisibles.
-- Se fuerza un color visible y se reaplica en cada cambio de theme.
local function fix_winseparator()
  -- Ventana activa: línea clara; inactiva: más apagada pero visible.
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#7f849c", bold = true })
  vim.api.nvim_set_hl(0, "WinSeparatorNC", { fg = "#45475a" })
end
fix_winseparator()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("FixWinSeparator", { clear = true }),
  callback = fix_winseparator,
  desc = "Mantener divisores de splits visibles con cualquier theme",
})
