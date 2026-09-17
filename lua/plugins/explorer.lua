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
        -- Sigue el buffer activo y al abrir un archivo el foco
        -- pasa al buffer (no te quedas atrapado en el tree).
        update_focused_file = { enable = true },
        actions = {
          open_file = {
            quit_on_open = false,
            focus_file = true,
          },
        },
      })
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Explorer" })
      vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeFocus<CR>", { desc = "Focus Explorer" })
      -- Salta del tree al buffer sin cerrar el tree: <C-l> (Navigator)
      -- o cierra el tree y vuelve al buffer con `q` / <leader>e.
    end,
  },
}
