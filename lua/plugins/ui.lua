return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "frappe", transparent_background = true })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  { "rose-pine/neovim", name = "rose-pine", priority = 1000, config = function() require("rose-pine").setup({ variant =
    "moon" }) end },
  { "folke/tokyonight.nvim", priority = 1000, config = function() require("tokyonight").setup({ style = "night", transparent = true }) end },
  { "sainnhe/gruvbox-material", priority = 1000, config = function() vim.g.gruvbox_material_background = "soft" end },
  { "sainnhe/everforest", priority = 1000, config = function() vim.g.everforest_background = "soft" end },
  { "gbprod/nord.nvim", priority = 1000, config = function() require("nord").setup({ transparent = true }) end },
  { "navarasu/onedark.nvim", priority = 1000, config = function() require("onedark").setup({ style = "darker", transparent = true }) end },
  { "rebelot/kanagawa.nvim", priority = 1000, config = function() require("kanagawa").setup({ theme = "wave", transparent = true }) end },

  { "HiPhish/rainbow-delimiters.nvim", config = function() require("rainbow-delimiters.setup").setup() end },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = { scope = { enabled = false }, indent = { char = "│" } } },
  { "sphamba/smear-cursor.nvim", config = function() require("smear_cursor").setup() end },
  { "mawkler/modicator.nvim", config = function() require("modicator").setup() end },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function() require("lualine")
        .setup({ options = { theme = "auto" } }) end },
  { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons", config = function() require("bufferline")
        .setup() end },
  { "rcarriga/nvim-notify", config = function() vim.notify = require("notify") end },
  { "folke/zen-mode.nvim", config = function() require("zen-mode").setup({ window = { width = 120 } }) end },
}
