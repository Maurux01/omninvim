return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        view = { side = "right", width = 30 },
        renderer = { highlight_git = true },
        filters = { dotfiles = false },
        actions = { open_file = { quit_on_open = false } },
      })
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Explorer" })
      vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeFocus<CR>", { desc = "Focus Explorer" })
    end,
  },
}
