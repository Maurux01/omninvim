return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup()
    end,
  },
  {
    "folke/flash.nvim",
    config = function()
      require("flash").setup()
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup()
    end,
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      -- Oil abre el directorio COMO UN BUFFER: editas, creas y
      -- renombras sin abrir/cerrar el tree lateral.
      { "-", "<cmd>Oil<CR>", desc = "Oil (dir como buffer)" },
      { "<leader>o", "<cmd>Oil<CR>", desc = "Oil (dir como buffer)" },
    },
    config = function()
      require("oil").setup({
        -- Solo nvim-tree secuestra `nvim <dir>`: oil se abre
        -- explicito con `-` / <leader>o para no pelear al inicio.
        default_file_explorer = false,
        view_options = {
          show_hidden = true,
        },
      })
    end,
  },
  {
    "numToStr/Navigator.nvim",
    config = function()
      require("Navigator").setup()
    end,
  },
  {
    "gbprod/yanky.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("yanky").setup({
        ring = {
          history_length = 100,
          storage_path = vim.fn.stdpath("data") .. "/yanky",
        },
      })

      vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank" })
      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Paste After" })
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Paste Before" })

      vim.keymap.set(
        "n",
        "<C-p>",
        "<Plug>(YankyCycleForward)",
        { desc = "Yanky Forward" }
      )

      vim.keymap.set(
        "n",
        "<C-n>",
        "<Plug>(YankyCycleBackward)",
        { desc = "Yanky Backward" }
      )
    end,
  },
  {
    "chrisgrieser/nvim-genghis",
    dependencies = { "stevearc/dressing.nvim" },
    config = function()
      local genghis = require("genghis")

      vim.keymap.set(
        "n",
        "<leader>fn",
        genghis.createNewFile,
        { desc = "New File" }
      )

      vim.keymap.set(
        "n",
        "<leader>fr",
        genghis.renameFile,
        { desc = "Rename File" }
      )

      vim.keymap.set(
        "n",
        "<leader>fm",
        genghis.moveAndRenameFile,
        { desc = "Move File" }
      )

      vim.keymap.set(
        "n",
        "<leader>fD",
        genghis.trashFile,
        { desc = "Trash File" }
      )
    end,
  },
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
  },
}
