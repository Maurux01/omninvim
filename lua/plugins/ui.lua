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
  { "Mofiqul/dracula.nvim", priority = 1000 },
  { "scottmckendry/cyberdream.nvim", priority = 1000 },
  { "eldritch-theme/eldritch.nvim", priority = 1000 },
  { "nyoom-engineering/oxocarbon.nvim", priority = 1000 },
  { "bluz71/vim-moonfly-colors", priority = 1000, name = "moonfly" },
  { "sainnhe/sonokai", priority = 1000 },
  { "tomasiser/vim-code-dark", priority = 1000 },
  { "Mofiqul/vscode.nvim", priority = 1000, name = "vscode" },
  { "projekt0n/github-nvim-theme", priority = 1000, name = "github-theme" },
  { "EdenEast/nightfox.nvim", priority = 1000 },
  { "marko-cerovac/material.nvim", priority = 1000, config = function() vim.g.material_style = "darker" end },
  { "AlexvZyl/nordic.nvim", priority = 1000, name = "nordic" },
  { "savq/melange-nvim", priority = 1000, name = "melange" },
  { "tiagovla/tokyodark.nvim", priority = 1000 },
  { "Shatur/neovim-ayu", priority = 1000, name = "ayu", config = function() vim.g.ayucolor = "dark" end },
  { "rmehri01/onenord.nvim", priority = 1000, name = "onenord" },
  { "datsfilipe/vesper.nvim", priority = 1000, name = "vesper" },

  { "HiPhish/rainbow-delimiters.nvim", config = function() require("rainbow-delimiters.setup").setup() end },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = { scope = { enabled = false }, indent = { char = "│" } } },
  {
    "sphamba/smear-cursor.nvim",
    config = function()
      require("smear_cursor").setup({
        stiffness = 0.5,
        trailing_stiffness = 0.35,
        trailing_exponent = 2,
        distance_stop_animating = 0.5,
        hide_target_hack = true,
      })
    end,
  },
  { "mawkler/modicator.nvim", config = function() require("modicator").setup() end },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "ThePrimeagen/harpoon" },
    config = function()
      -- Dots for Harpoon slots: ● = current buffer is pinned, ○ = other pins
      local function harpoon_marks()
        local ok, harpoon = pcall(require, "harpoon")
        if not ok then return "" end
        local list_ok, list = pcall(function() return harpoon:list() end)
        if not list_ok or not list or not list.items or #list.items == 0 then
          return ""
        end
        local cur = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
        local parts = {}
        for i, item in ipairs(list.items) do
          if i > 9 then break end
          local path = vim.fn.fnamemodify(item.value or "", ":p")
          parts[#parts + 1] = (path ~= "" and path == cur) and (i .. "●") or (i .. "○")
        end
        return "󰐃 " .. table.concat(parts, " ")
      end
      require("lualine").setup({
        options = { theme = "auto" },
        sections = {
          lualine_c = {
            "filename",
            { harpoon_marks, color = { fg = "#fab387" } },
          },
        },
      })
    end,
  },
  { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons", config = function() require("bufferline")
        .setup() end },
  { "rcarriga/nvim-notify", config = function()
    local notify = require("notify")
    vim.notify = notify
    vim.keymap.set("n", "<leader>nd", function()
      notify.dismiss({ silent = true, pending = true })
      pcall(vim.cmd, "NoiceDismiss")
    end, { desc = "Descartar notificaciones" })
  end },
  { "folke/zen-mode.nvim", config = function() require("zen-mode").setup({ window = { width = 120 } }) end },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        cmdline = { enabled = true, view = "cmdline_popup" },
        popupmenu = { enabled = true },
        messages = { enabled = true },
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
          presets = {
            bottom_search = false,
            command_palette = true,
            long_message_to_split = true,
            lsp_doc_border = true,
        },
        views = {
          cmdline_popup = {
            position = { row = "30%", col = "50%" },
            size = { width = 60, height = "auto" },
          },
        },
      })
    end,
  },
}
