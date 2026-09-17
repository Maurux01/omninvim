return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeOpen", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer" },
      { "<leader>E", "<cmd>NvimTreeFocus<CR>", desc = "Focus Explorer" },
    },
    config = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        -- API vigente: api.config.mappings.default_on_attach fue renombrado a api.map.on_attach.default
        if api.map and api.map.on_attach and api.map.on_attach.default then
          api.map.on_attach.default(bufnr)
        else
          api.config.mappings.default_on_attach(bufnr)
        end

        -- Vuelve a la ventana/buffer anterior SIN cerrar el tree.
        local function back_to_prev_buf()
          vim.cmd("wincmd p")
        end
        vim.keymap.set(
          "n",
          "<leader><Tab>",
          back_to_prev_buf,
          { buffer = bufnr, desc = "Volver al buffer anterior (sin cerrar tree)" }
        )
        vim.keymap.set(
          "n",
          "<BS>",
          back_to_prev_buf,
          { buffer = bufnr, desc = "Volver al buffer anterior (sin cerrar tree)" }
        )
        -- El tree esta a la derecha: <C-h> salta al buffer de la izquierda.
        vim.keymap.set(
          "n",
          "<C-h>",
          back_to_prev_buf,
          { buffer = bufnr, desc = "Volver al buffer anterior (sin cerrar tree)" }
        )
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
        disable_netrw = true,
        hijack_netrw = true,
        -- No compite con oil.nvim al abrir `nvim <dir>`: oil tiene
        -- default_file_explorer = false y solo se abre con `-` / <leader>o.
        hijack_directories = { enable = true },
        view = { side = "right", width = 30 },
        renderer = { highlight_git = "name" },
        filters = { dotfiles = false },
        -- Sigue el buffer activo y al abrir un archivo el foco
        -- pasa al buffer (no te quedas atrapado en el tree).
        update_focused_file = { enable = true },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
      })
      -- Desde el tree vuelve al buffer sin cerrarlo: <leader><Tab>,
      -- <BS> o <C-h>. Cierra el tree y vuelve con `q` / <leader>e.
    end,
  },
}
