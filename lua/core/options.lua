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
-- Wayland + wl-clipboard: wl-paste imprime "Nothing is copied" (exit 1)
-- con el clipboard vacío y yanky (sync_with_ring) lo dispara al inicio.
-- Se silencia stderr: exit 1 con salida vacía = clipboard vacío, sin error visible.
vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = "wl-copy --foreground --type text/plain",
    ["*"] = "wl-copy --foreground --primary --type text/plain",
  },
  paste = {
    ["+"] = { "sh", "-c", "wl-paste --no-newline 2>/dev/null || true" },
    ["*"] = { "sh", "-c", "wl-paste --primary --no-newline 2>/dev/null || true" },
  },
  cache_enabled = 1,
}
opt.clipboard = "unnamedplus"

-- Neovim solo usa WinSeparator (no existe WinSeparatorNC): todos los
-- bordes comparten el mismo color, por eso activa/inactiva se veían igual.
-- Se deja una base visible y el plugin colorful-winsep pinta la activa.
local function fix_winseparator()
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#6c7086", bg = "NONE", bold = true })
end
fix_winseparator()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("FixWinSeparator", { clear = true }),
  callback = fix_winseparator,
  desc = "Mantener divisores de splits visibles con cualquier theme",
})
